#!/usr/bin/env bash
# Installer for agent-coding.
#
#   ./install.sh                 # self-install: provision THIS repo (submodules, binary, wiring)
#   ./install.sh <target-dir>    # install the harness scaffolding INTO another project
#
# Online (no local checkout needed):
#   curl -fsSL https://raw.githubusercontent.com/nobodyonlyc/agent-coding/master/install.sh | bash -s <target-dir>
#
# In target mode the scaffolding (harness CLI, skills-src, helper scripts, agent
# projections, and the backlog DB) is copied into <target-dir>, which may be a
# brand-new directory or an existing project. Idempotent and re-runnable.
set -euo pipefail

# Where this script's source repo lives. Empty when piped (curl | bash): we then
# bootstrap by cloning the repo into a temp dir (see ensure_source).
_self="${BASH_SOURCE[0]:-}"
if [ -n "$_self" ] && [ -f "$_self" ]; then
  SOURCE_DIR="$(cd "$(dirname "$_self")" && pwd)"
else
  SOURCE_DIR=""
fi
SKILLS_SRC_SOURCE=""   # set once SOURCE_DIR is finalized
BOOTSTRAP_TMP=""       # temp clone dir to clean up on exit (bootstrap only)

# The harness CLI binary — downloaded from GitHub Releases when missing.
# Overridable: HARNESS_REPO=<owner/name>  HARNESS_VERSION=<tag|latest>
HARNESS_REPO="${HARNESS_REPO:-nobodyonlyc/harness}"
HARNESS_VERSION="${HARNESS_VERSION:-latest}"

# The agent-coding source repo, used to bootstrap online (curl | bash) installs.
# Overridable: AGENT_CODING_REPO=<git-url>  AGENT_CODING_REF=<branch|tag>
AGENT_CODING_REPO="${AGENT_CODING_REPO:-https://github.com/nobodyonlyc/agent-coding.git}"
AGENT_CODING_REF="${AGENT_CODING_REF:-master}"

usage() {
  cat <<'EOF'
Usage: ./install.sh [TARGET_DIR]

  (no argument)   Self-install: provision this repo in place.
  TARGET_DIR      Install the harness scaffolding into another project.
                  TARGET_DIR is created if it does not exist (new project),
                  or augmented in place if it does (existing project).

Environment:
  HARNESS_REPO     GitHub owner/name for the CLI release  (default: nobodyonlyc/harness)
  HARNESS_VERSION  Release tag, or "latest"               (default: latest)
EOF
}

# -------------------------------------------------------------------- helpers

# Relative path from $2 to $1 (for portable symlinks); falls back to absolute.
rel_path() { python3 -c "import os,sys;print(os.path.relpath(sys.argv[1],sys.argv[2]))" "$1" "$2" 2>/dev/null || echo "$1"; }

detect_platform() {
  local os arch
  os="$(uname -s | tr '[:upper:]' '[:lower:]')"
  arch="$(uname -m)"
  case "$os" in
    linux*)  os="linux" ;;
    darwin*) os="darwin" ;;
  esac
  case "$arch" in
    x86_64|amd64)  arch="x86_64" ;;
    arm64|aarch64) arch="aarch64" ;;
  esac
  printf '%s-%s' "$os" "$arch"
}

# Make a freshly-placed binary runnable on this host (exec bit + macOS gatekeeper).
bless_binary() {
  local bin="$1"
  chmod +x "$bin"
  if [ "$(uname -s)" = "Darwin" ]; then
    xattr -d com.apple.quarantine "$bin" 2>/dev/null || true
    command -v codesign >/dev/null 2>&1 && codesign --force --sign - "$bin" >/dev/null 2>&1 || true
  fi
}

# Download the harness CLI into $1.
download_harness() {
  local dest="$1" platform asset url rc=0
  platform="$(detect_platform)"
  asset="harness-${platform}"
  if [ "$HARNESS_VERSION" = "latest" ]; then
    url="https://github.com/${HARNESS_REPO}/releases/latest/download/${asset}"
  else
    url="https://github.com/${HARNESS_REPO}/releases/download/${HARNESS_VERSION}/${asset}"
  fi
  echo "    Downloading ${asset} (${HARNESS_VERSION}) from GitHub Releases ..."
  if command -v curl >/dev/null 2>&1; then
    curl -fsSL "$url" -o "$dest" || rc=$?
  elif command -v wget >/dev/null 2>&1; then
    wget -qO "$dest" "$url" || rc=$?
  else
    echo "    ERROR: need curl or wget to download the harness binary." >&2
    return 1
  fi
  if [ "$rc" -ne 0 ] || [ ! -s "$dest" ]; then
    rm -f "$dest"
    echo "    ERROR: could not download ${asset} (${HARNESS_VERSION})." >&2
    echo "    URL: $url" >&2
    echo "    Releases: https://github.com/${HARNESS_REPO}/releases — or pin: HARNESS_VERSION=<tag> ./install.sh" >&2
    return 1
  fi
  bless_binary "$dest"
  return 0
}

# Ensure $SOURCE_DIR/harness exists and is runnable (the canonical copy we clone from).
ensure_source_binary() {
  echo "==> Checking harness CLI ..."
  if [ -x "$SOURCE_DIR/harness" ]; then
    echo "    harness binary present: $("$SOURCE_DIR/harness" --version 2>/dev/null || echo ok)"
  elif [ -f "$SOURCE_DIR/harness" ]; then
    bless_binary "$SOURCE_DIR/harness"
    echo "    harness binary present — set executable bit."
  else
    echo "    harness binary not found — fetching from GitHub Releases (${HARNESS_REPO}) ..."
    if download_harness "$SOURCE_DIR/harness"; then
      echo "    Installed harness: $("$SOURCE_DIR/harness" --version 2>/dev/null || echo ok)"
    else
      echo "    WARN: automatic download failed — provide the prebuilt CLI manually to use backlog commands." >&2
    fi
  fi
}

# Copy a file into the target only if absent; never clobber project-owned files.
copy_if_absent() {
  local src="$1" dst="$2"
  if [ -e "$dst" ]; then
    echo "    keep   $(basename "$dst") (already present)"
  elif [ -f "$src" ]; then
    cp "$src" "$dst"
    echo "    copy   $(basename "$dst")"
  fi
}

# Mirror a directory tree into the target, excluding any .git metadata so the
# copied submodule lands as plain (standalone) files.
mirror_tree() {
  local src="$1" dst="$2"
  if command -v rsync >/dev/null 2>&1; then
    rsync -a --delete --exclude '.git' --exclude '.git/' "$src/" "$dst/"
  else
    rm -rf "$dst"
    mkdir -p "$dst"
    cp -R "$src/." "$dst/"
    find "$dst" -name '.git' -prune -exec rm -rf {} + 2>/dev/null || true
  fi
}

# True when SOURCE_DIR is (or can become) a usable agent-coding checkout.
is_local_checkout() {
  [ -n "$SOURCE_DIR" ] || return 1
  [ -f "$SOURCE_DIR/.harness/skills-src/install.sh" ] && return 0
  [ -d "$SOURCE_DIR/.git" ] && return 0
  git -C "$SOURCE_DIR" rev-parse --is-inside-work-tree >/dev/null 2>&1
}

# Clone agent-coding into a temp dir for online (curl | bash) installs, then
# point SOURCE_DIR at it. Submodule URLs are rewritten SSH -> HTTPS so a public
# clone needs no SSH key. The clone is removed on exit via the cleanup trap.
bootstrap_source() {
  command -v git >/dev/null 2>&1 || { echo "ERROR: git is required for an online install." >&2; exit 1; }
  BOOTSTRAP_TMP="$(mktemp -d)"
  local dest="$BOOTSTRAP_TMP/agent-coding"
  echo "==> Bootstrapping: cloning $AGENT_CODING_REPO ($AGENT_CODING_REF) ..."
  git clone --depth 1 --branch "$AGENT_CODING_REF" "$AGENT_CODING_REPO" "$dest" \
    || { echo "ERROR: failed to clone $AGENT_CODING_REPO ($AGENT_CODING_REF)." >&2; exit 1; }
  # Make submodule fetches work without SSH credentials.
  git -C "$dest" config url."https://github.com/".insteadOf "git@github.com:"
  git -C "$dest" config url."https://github.com/".insteadOf "ssh://git@github.com/"
  git -C "$dest" submodule update --init --recursive --depth 1 \
    || { echo "ERROR: failed to fetch submodules in the bootstrap clone." >&2; exit 1; }
  SOURCE_DIR="$dest"
}

# Guarantee SOURCE_DIR is a populated agent-coding checkout, bootstrapping when not.
ensure_source() {
  is_local_checkout || bootstrap_source
  SKILLS_SRC_SOURCE="$SOURCE_DIR/.harness/skills-src"
}

cleanup_bootstrap() { [ -n "$BOOTSTRAP_TMP" ] && rm -rf "$BOOTSTRAP_TMP"; return 0; }
trap cleanup_bootstrap EXIT

# Append the harness-managed ignore block to the target .gitignore if missing.
ensure_gitignore() {
  local gi="$1/.gitignore" marker="# >>> harness-managed >>>"
  [ -f "$gi" ] && grep -qF "$marker" "$gi" && return 0
  {
    echo ""
    echo "$marker"
    echo ".harness/harness.db"
    echo ".harness/.lock"
    echo ".harness/context.json"
    echo ".harness/trace.md"
    echo ".harness/reports/"
    echo ".harness/logs/"
    echo "/harness"
    echo ".claude/settings.local.json"
    echo ".claude/skills"
    echo ".agents/workflows/"
    echo ".agents/skills"
    echo ".agents/skills.json"
    echo "session-handoff.md"
    echo "# <<< harness-managed <<<"
  } >> "$gi"
  echo "    gitignore: appended harness-managed block"
}

# ------------------------------------------------------------- self-install

self_install() {
  echo "==> agent-coding install (self)"
  echo "    project: $SOURCE_DIR"

  # Submodules: harness-skills (.harness/skills-src) + nested vendor/caveman.
  echo "==> Syncing git submodules (harness-skills + vendor/caveman) ..."
  if [ -d "$SOURCE_DIR/.git" ] || git -C "$SOURCE_DIR" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    git -C "$SOURCE_DIR" submodule sync --recursive >/dev/null 2>&1 || true
    git -C "$SOURCE_DIR" submodule update --init --recursive
  else
    echo "    WARN: not a git checkout — cannot fetch submodules."
  fi

  if [ ! -f "$SKILLS_SRC_SOURCE/install.sh" ]; then
    echo "    ERROR: $SKILLS_SRC_SOURCE/install.sh missing — submodule did not populate." >&2
    echo "    Try: git submodule update --init --recursive" >&2
    exit 1
  fi

  echo "==> Wiring agent projections (skills / workflows / hooks) ..."
  bash "$SKILLS_SRC_SOURCE/install.sh"

  ensure_source_binary

  if [ -x "$SOURCE_DIR/harness" ] && [ ! -f "$SOURCE_DIR/.harness/harness.db" ]; then
    echo "==> Building harness database (init --bare) ..."
    ( cd "$SOURCE_DIR" && ./harness init --bare ) || echo "    WARN: 'harness init --bare' failed; run it manually." >&2
  fi

  echo ""
  echo "==> Install complete."
  if [ -x "$SOURCE_DIR/harness" ]; then
    echo "    Next: ./init.sh        (sync app deps + baseline verification)"
    echo "          ./harness status (view backlog)"
    echo ""
    echo "    To set up another project: ./install.sh <target-dir>"
  else
    echo "    Next: install the harness binary, then ./init.sh"
  fi
}

# ----------------------------------------------------------- target-install

target_install() {
  local target="$1"

  # Resolve to an absolute path, creating the directory for a new project.
  if [ ! -d "$target" ]; then
    echo "==> Creating new project directory: $target"
    mkdir -p "$target"
  fi
  target="$(cd "$target" && pwd)"

  if [ "$target" = "$SOURCE_DIR" ]; then
    self_install
    return
  fi

  echo "==> agent-coding install (target)"
  echo "    source : $SOURCE_DIR"
  echo "    target : $target"

  # The source must be fully provisioned before we can clone from it.
  echo "==> Ensuring source is provisioned ..."
  if [ -d "$SOURCE_DIR/.git" ] || git -C "$SOURCE_DIR" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    git -C "$SOURCE_DIR" submodule sync --recursive >/dev/null 2>&1 || true
    git -C "$SOURCE_DIR" submodule update --init --recursive
  fi
  if [ ! -f "$SKILLS_SRC_SOURCE/install.sh" ]; then
    echo "    ERROR: $SKILLS_SRC_SOURCE missing — run ./install.sh (self) first." >&2
    exit 1
  fi
  ensure_source_binary

  # Harness assumes a git repo (hooks, git-guard). Initialize one if absent.
  if ! git -C "$target" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    echo "==> Initializing git repository in target ..."
    git -C "$target" init -q
  fi

  # 1. Harness CLI binary.
  echo "==> Installing harness binary ..."
  if [ -f "$SOURCE_DIR/harness" ]; then
    cp "$SOURCE_DIR/harness" "$target/harness"
    bless_binary "$target/harness"
    echo "    copy   harness ($("$target/harness" --version 2>/dev/null || echo ok))"
  else
    echo "    WARN: source harness binary unavailable — fetching directly ..."
    download_harness "$target/harness" || echo "    WARN: target has no harness binary." >&2
  fi

  # 2. Skills/workflows/hooks source — copied as standalone files (no submodule).
  echo "==> Copying skills-src into target/.harness/skills-src ..."
  mkdir -p "$target/.harness"
  mirror_tree "$SKILLS_SRC_SOURCE" "$target/.harness/skills-src"

  # 3. Helper scripts and operating-rule docs (never clobber existing ones).
  echo "==> Installing helper scripts and docs ..."
  copy_if_absent "$SOURCE_DIR/init.sh"   "$target/init.sh"
  copy_if_absent "$SOURCE_DIR/run.sh"    "$target/run.sh"
  copy_if_absent "$SOURCE_DIR/AGENTS.md" "$target/AGENTS.md"
  copy_if_absent "$SOURCE_DIR/CLAUDE.md" "$target/CLAUDE.md"
  [ -f "$target/init.sh" ] && chmod +x "$target/init.sh"
  [ -f "$target/run.sh" ]  && chmod +x "$target/run.sh"
  ensure_gitignore "$target"

  # 4. Wire agent projections for the target. The nested installer derives the
  #    project root from the copied skills-src (two levels up == target), so it
  #    wires the target, not the source.
  echo "==> Wiring agent projections (skills / workflows / hooks) ..."
  bash "$target/.harness/skills-src/install.sh"

  # 5. Build the backlog DB. Seed F01 for a fresh project; import an existing
  #    features.json (if the project already carried one) with --bare.
  if [ -x "$target/harness" ] && [ ! -f "$target/.harness/harness.db" ]; then
    if [ -f "$target/.harness/features.json" ]; then
      echo "==> Building harness database (init --bare; existing features.json) ..."
      ( cd "$target" && ./harness init --bare ) || echo "    WARN: 'harness init --bare' failed; run it manually." >&2
    else
      echo "==> Building harness database (init; seeding backlog) ..."
      ( cd "$target" && ./harness init ) || echo "    WARN: 'harness init' failed; run it manually." >&2
    fi
  fi

  echo ""
  echo "==> Install complete in: $target"
  if [ -x "$target/harness" ]; then
    echo "    Next: cd $target"
    echo "          ./init.sh        (sync app deps + baseline verification)"
    echo "          ./harness status (view backlog)"
  else
    echo "    Next: provide the harness binary in $target, then ./init.sh"
  fi
}

# ----------------------------------------------------------------- dispatch

TARGET_ARG=""
while [ $# -gt 0 ]; do
  case "$1" in
    -h|--help) usage; exit 0 ;;
    --) shift; break ;;
    -*) echo "Unknown option: $1" >&2; usage >&2; exit 2 ;;
    *)  if [ -n "$TARGET_ARG" ]; then echo "Unexpected extra argument: $1" >&2; exit 2; fi
        TARGET_ARG="$1" ;;
  esac
  shift
done
[ $# -gt 0 ] && TARGET_ARG="${TARGET_ARG:-$1}"

if [ -z "$TARGET_ARG" ]; then
  if ! is_local_checkout; then
    echo "ERROR: an online (curl | bash) install requires a target directory." >&2
    echo "  curl -fsSL <url>/install.sh | bash -s <target-dir>" >&2
    exit 2
  fi
  ensure_source
  self_install
else
  ensure_source
  target_install "$TARGET_ARG"
fi

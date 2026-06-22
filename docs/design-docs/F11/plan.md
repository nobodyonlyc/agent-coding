# Plan: Multi-agent projection in install.sh

## Behavior to implement
install.sh symlinks .claude/skills, generates .agent/workflows/harness-*, leaves codex path-based.

## Approach
Replace the F01 skeleton install.sh with real projection:
- Resolve PROJECT_ROOT (superproject of the submodule).
- Claude Code: symlink .claude/skills -> skills-src/skills (relative, idempotent).
- Antigravity: generate .agent/workflows/harness-<name>.md adapters for each workflow-* (pointing to
  the canonical SKILL.md; description copied from frontmatter).
- Codex: path-based, print note (no projection).
- wire_hooks(): merge config-templates (populated in F12) into .claude/settings.json via jq if present,
  else print manual instructions. Defensive: skip cleanly if templates absent.
Keep grep anchors .claude/skills and .agent/workflows (verification).

## Files to touch
- Modify: .harness/skills-src/install.sh
- This repo: bump submodule; docs/design-docs/F11/evidence.md.

## Not in scope
- The hook scripts + config-templates content (F12) — install.sh references them defensively.

## Risks / unknowns
- Must stay bash-safe and idempotent (re-runnable); symlink replace must not delete a real dir.

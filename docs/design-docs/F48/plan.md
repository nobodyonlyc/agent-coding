# Plan: Hook injects + auto-logs resolved expert chain at code-phase entry

## Behavior to implement
At Phase-5 (code) entry, a hook deterministically — without model judgment — does two things:
1. **INJECT** a system-reminder naming the exact skills to load BY NAME (e.g.
   `dev-be` + `dev-go` + `golang-pro` for a Go backend), with each name's `skills/<name>/SKILL.md`
   as a fallback. This drives skill selection by machinery, not a weak model's semantic guess.
2. **AUTO-LOG** the resolved chain to the task observability record — `.harness/trace.md` AND the
   active task-state file — so "which skills this task used" is captured automatically, with no
   dependence on the model remembering to call `harness trace`.

The chain comes from the F47 resolver (`scripts/experts-resolver.sh`) reading the machine-readable
Stack block in `docs/design/architecture.md`. Same single source of truth; zero new mapping.

## Approach
1. **Hook** — `hooks/expert-inject.sh`, event **PreToolUse(Bash)**, soft (exit 0; never blocks).
   On each invocation it:
   - Early-exits unless: `.harness/features.json`, `docs/design/architecture.md`, and the resolver
     all exist, and `jq` is available.
   - Finds each `in_progress` feature whose task-state `.harness/tasks/<id>.md` `## Current phase`
     is `code` (the documented Phase-5 marker in resources/task-state.md).
   - **Idempotency:** skips a task whose task-state already has a `## Resolved skill chain (auto)`
     section — so it fires exactly once at code-phase entry, not on every later bash command.
   - Resolves the chain via `experts-resolver.sh --stack docs/design/architecture.md --format names`
     (component inferred from framework / defaulted to dev-be by the resolver). Empty/failed
     resolution → skip silently (no Stack block yet, etc.).
   - **(1) INJECT:** writes a `<system-reminder>` naming each skill (+ fallback path) to **stderr**
     (the portable channel — Antigravity's bridge reads stderr; Claude surfaces it) AND emits a
     Claude-native `hookSpecificOutput.additionalContext` JSON to **stdout** (built with python3 so
     quoting is safe) so the model receives it without the tool call being blocked.
   - **(2) AUTO-LOG:** appends a `## Resolved skill chain (auto)` section (timestamp + inline chain)
     to the task-state file, and a one-line trace record to `.harness/trace.md`.
2. **Wiring** — add `expert-inject.sh` to the PreToolUse(Bash) chain in
   `config-templates/claude.settings.json` and the `harness-gates` PreToolUse chain in
   `config-templates/antigravity.hooks.json` (via the antigravity-hook bridge). It is a passive
   injector that self-filters, so it shares the existing command matcher like the other gates.
3. **Tests (the two FROZEN verifications):**
   - `scripts/test-expert-inject-hook.sh` — builds a temp project fixture (features.json with one
     in_progress feature in `code` phase + an architecture.md Stack block for a Go backend), runs the
     hook from that CWD, and asserts the combined output (stdout+stderr) names the full chain
     `dev-be dev-go golang-pro` and includes the fallback path form `skills/dev-go/SKILL.md`. Also:
     a frontend Stack (React) injects `dev-fe ... react-expert`; a non-`code` phase injects nothing.
   - `scripts/test-expert-inject-log.sh` — same fixture; runs the hook and asserts `.harness/trace.md`
     gained a line containing the chain and the task-state gained a `## Resolved skill chain (auto)`
     section; runs the hook a SECOND time and asserts NO duplicate (idempotency); asserts nothing is
     logged when phase is not `code`.
4. **Evidence** — record hook output + both logs + idempotency proof in `docs/design-docs/F48/evidence.md`.

## Files to touch
- `.harness/skills-src/hooks/expert-inject.sh` — new, executable
- `.harness/skills-src/scripts/test-expert-inject-hook.sh` — new, executable (frozen verification)
- `.harness/skills-src/scripts/test-expert-inject-log.sh` — new, executable (frozen verification)
- `.harness/skills-src/config-templates/claude.settings.json` — wire the hook
- `.harness/skills-src/config-templates/antigravity.hooks.json` — wire the hook
- `docs/design-docs/F48/evidence.md`

## Not in scope
- Modifying the `harness` binary or the F47 resolver (consumed read-only).
- F50 projection / F51 implicit policy.
- Proving a live host actually loads the named skills — a hook can inject + log, but cannot force a
  model to read SKILL.md (same honest limit noted in caveman-activate.sh). The skills/AGENTS rules
  carry the "read the SKILL.md" obligation; this hook makes the chain explicit and observable.

## Risks / unknowns
- **Cross-host injection channel** — Claude wants `additionalContext` JSON on stdout; Antigravity's
  bridge captures stderr as the decision reason and discards stdout. Emit to BOTH so each host gets
  it; tests capture combined output so either channel satisfies them.
- **Phase detection** — relies on the task-state `## Current phase: code` convention; if a workflow
  never sets it, the hook stays silent (acceptable — fail-quiet, never wrong).
- **Idempotency marker** — keying off the `## Resolved skill chain (auto)` section keeps it to one
  injection; if a task legitimately re-enters code, the section already exists and it won't re-inject
  (acceptable for this US; re-resolve-on-stack-change is out of scope).
- **Non-determinism from timestamps** — logs carry a UTC timestamp, so tests assert substring +
  idempotency (single section), not byte-equality.
- **Frozen-verification immutability** — write both test case tables fully before `harness start`.

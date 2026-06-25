# Evidence: Hook injects + auto-logs resolved expert chain at code-phase entry

## What was built
`hooks/expert-inject.sh` — a soft (exit 0, never-blocking) **PreToolUse(Bash)** hook that makes
Phase-5 skill loading **driven and observable by machinery**, not model judgment.

On each invocation it:
- Early-exits unless `.harness/features.json`, `docs/design/architecture.md`, the F47 resolver, `jq`
  and `python3` are all present.
- For each `in_progress` feature, reads `.harness/tasks/<id>.md` `## Current phase`; acts only when
  it is `code` (the documented Phase-5 marker, resources/task-state.md).
- Is **idempotent**: skips a task whose task-state already has a `## Resolved skill chain (auto)`
  section, so it fires exactly once at code-phase entry.
- Resolves the chain deterministically via `experts-resolver.sh --stack docs/design/architecture.md
  --format names` (component inferred from framework / defaulted to dev-be by the resolver).
- **(1) INJECTS** a `<system-reminder>` naming each skill BY NAME with its `skills/<name>/SKILL.md`
  fallback path, to **stderr** (portable: Antigravity's bridge carries stderr as the allow `reason`;
  Claude surfaces it) AND as a Claude-native `hookSpecificOutput.additionalContext` JSON on
  **stdout** (built with python3 for safe quoting) so the model receives it without the tool call
  being blocked.
- **(2) AUTO-LOGS** the chain to both observability sinks: a `## Resolved skill chain (auto)` section
  (timestamp + inline chain) in the task-state file, and a one-line `skill=expert-inject` record in
  `.harness/trace.md` — no dependence on the model calling `harness trace`.

Wired into both host configs: `config-templates/claude.settings.json` (PreToolUse Bash chain) and
`config-templates/antigravity.hooks.json` (`harness-gates` PreToolUse chain, via the
antigravity-hook bridge). Both files validate as JSON.

Sample (Go backend, code phase): stderr/additionalContext name `dev-be`, `dev-go`, `golang-pro`
(+ fallback paths); trace.md gets
`… | skill=expert-inject | feature=FX1 | … | result=dev-be dev-go golang-pro`; task-state gains the
`## Resolved skill chain (auto)` section with the same chain.

## How it was verified
Two FROZEN verifications, each building a throwaway project fixture and running the hook from that
CWD (the hook finds the resolver by its own path, independent of CWD):

- `bash .harness/skills-src/scripts/test-expert-inject-hook.sh` → **PASS (9 checks)** — INJECTION:
  Go backend names the full chain `dev-be dev-go golang-pro` and emits `skills/dev-go/SKILL.md` and a
  `system-reminder` block; React frontend infers `dev-fe` and names `react-expert`; a `design` phase
  injects nothing; a `code` phase with no resolvable language injects nothing (fail-quiet).
- `bash .harness/skills-src/scripts/test-expert-inject-log.sh` → **PASS (10 checks)** — AUTO-LOG:
  trace.md is created and logs the expert-inject skill, the full chain, and the feature id;
  task-state gains the chain section; a SECOND run does not duplicate either sink (idempotency,
  counts == 1); a `review` phase writes no trace and adds no task-state section.

Baseline `scripts/validate.sh` → `== validate: PASS ==`; the F47 resolver and its test are untouched.

## Key decisions made
- **Phase detection via the task-state `## Current phase: code` convention.** It is host-agnostic
  (a file under `.harness/`) and already maintained by the workflows, so the hook needs no new
  signal. If a workflow never sets the phase, the hook stays silent — fail-quiet, never wrong.
- **Emit to BOTH channels.** Claude consumes `additionalContext` JSON on stdout; the Antigravity
  bridge discards stdout and carries stderr as the decision `reason`. Writing the reminder to stderr
  AND the JSON to stdout means each host gets it without host-detection logic.
- **Idempotency keyed on the logged section**, not a separate marker file — the auto-log IS the
  marker, so inject and log are consistently one-shot and there is no extra state to clean up.
- **Soft, never-blocking.** A passive injector must not deny tool calls; it exits 0 always. The honest
  limit (cf. caveman-activate.sh): a hook can name + log the chain but cannot force a model to read
  each SKILL.md — the skills/AGENTS rules carry that obligation; this makes the chain explicit and
  observable so the omission is at least detectable in the trace.
- **Reuse F47, add no mapping.** The hook shells out to the resolver, which reads the same
  `metadata.delegates` frontmatter — one source of truth from frontmatter → resolver → hook.

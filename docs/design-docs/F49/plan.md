# Plan: Gate audit — remove model self-evaluation from all gates

## Behavior to implement
Audit every gate/hook so each pass/fail decision is computed by a SCRIPT reading artifacts (tests,
lint, evidence, exit codes, command strings, token counts) — never by the model judging its own
work. Record the findings. Convert any soft "model thinks it's done" gate to a mechanical check, or —
where the decision is an irreducible judgment — flag it `tier=judgment` and route it to a stronger
authority (the user, or a stronger model), so it is never a silent self-eval. Enforce the result
with a frozen lint.

## Audit result (the finding)
Read all 19 `hooks/*.sh`. Classification:
- **mechanical** (blocks via exit 1/2, decision read from an artifact): `git-guard` (command + git
  branch), `phase-guard` (plan.md), `quality-gate` / `review-gate` / `review-fix-gate` /
  `it-testcase-gate` / `e2e-coverage-gate` / `test-type-coverage-gate` (evidence.md),
  `stack-decision-gate` (architecture.md + stack-versions.md), `persona-gate` (context.json,
  HARD mode), `context-budget-guard` (token count).
- **judgment** (irreducible, routed — NOT self-eval): `step-gate` — "confirm before the next step"
  routes the advance decision to the **user** (gated) or a logged decision (auto). This is the one
  judgment chokepoint; it must be tagged `tier=judgment` so it is never mistaken for a mechanical
  gate or a model self-grade.
- **advisory** (never blocks; nudge/helper only): `task-state-guard`, `session-guard`,
  `caveman-budget`, `caveman-activate`, `notify`, `expert-inject`, `antigravity-hook` (bridge).

No gate currently decides pass/fail from a model self-affirmation. The lint locks that in and guards
against regression.

## Approach
1. **Co-located classification tag.** Add one line to each `hooks/*.sh` header:
   `# gate-audit: <mechanical|judgment|advisory> — <decision basis / routing>`. Truth lives next to
   the code so it cannot drift from a separate table.
2. **Frozen lint** — `scripts/lint-no-self-eval-gates.sh`, enforcing:
   - **Completeness:** every `hooks/*.sh` carries exactly one `# gate-audit:` tag with a valid type.
   - **mechanical** ⇒ the script contains a blocking `exit 1`/`exit 2` AND reads a real artifact
     (a file test/`grep`/`awk`/path, or `$COMMAND`/`CLAUDE_TOOL_INPUT`, or an exit-code read) — i.e.
     the decision provably derives from an artifact, not a self-report.
   - **judgment** ⇒ the header declares `tier=judgment` AND a routing word (`route`/`stronger`/
     `user`), so the chokepoint is explicit and escalated, never silent.
   - **advisory** ⇒ the script NEVER blocks (no `exit 1`/`exit 2`) — it can only nudge.
   - **Anti-self-eval scan (the core check):** no gate may gate a decision on a model
     self-affirmation phrase (`looks good`, `lgtm`, `i confirm`, `i think`, `self-assess`,
     `trust me`, `seems (done|fine|correct)`). Flag any occurrence used in a gate.
   - Prints a summary count and the per-type tally; exit 0 only when all checks pass.
3. **Findings doc** — `resources/gate-audit.md`: the human-readable audit (table of every gate →
   type → decision basis → blocks?), plus the principle and the one judgment chokepoint. The header
   tags are the machine source of truth; this doc is the narrative the lint backs.
4. **Evidence** — record the lint output, the per-type tally, and a negative test (inject a fake
   self-eval gate → lint fails) in `docs/design-docs/F49/evidence.md`.

## Files to touch
- `.harness/skills-src/hooks/*.sh` — add the `# gate-audit:` header tag to each (19 files)
- `.harness/skills-src/scripts/lint-no-self-eval-gates.sh` — new, executable (frozen verification)
- `.harness/skills-src/resources/gate-audit.md` — new, the findings record
- `docs/design-docs/F49/evidence.md`

## Not in scope
- Changing any gate's actual decision logic (the audit found them already mechanical) — this US adds
  classification + enforcement, not new behavior. `step-gate` stays a judgment gate (correctly so).
- The skill-internal review/judgment done by `check-review-loop` etc. — those are separate agents,
  not hooks; the GATE that enforces their output (`review-fix-gate`) is mechanical and in scope.
- F50 projection / F51 implicit policy.

## Risks / unknowns
- **Proving "reads an artifact" syntactically.** A lint can't fully prove semantics; the positive
  check (blocking gate must contain a file/command/exit read) is a strong, deterministic proxy and
  every current mechanical gate satisfies it. Paired with the anti-self-eval phrase scan, it catches
  the realistic regression (someone adds a gate that greps the model's prose for "looks good").
- **Tag drift.** Mitigated by co-locating the tag in the gate file and making the lint require it on
  every file (a new untagged hook fails the lint).
- **advisory gates that read artifacts but never block** (task-state-guard, expert-inject) must not
  be misread as self-eval — they make NO pass/fail decision, so the `no blocking exit` invariant is
  the correct, checkable definition.
- **Frozen-verification immutability** — finalize the lint's checks before `harness start`.

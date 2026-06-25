# Evidence: Gate audit — remove model self-evaluation from all gates

## What was built
A complete audit of all 19 `hooks/*.sh`, a co-located classification tag on each, a frozen lint that
enforces the classification mechanically, and a findings record.

- **Audit + classification tag** — each hook carries one header line
  `# gate-audit: <mechanical|judgment|advisory> — <decision basis / routing>`. Result:
  **11 mechanical** (decision read from an artifact, blocks via exit 1/2), **1 judgment**
  (`step-gate`, the irreducible advance-confirmation, routed to the user / logged in auto), and
  **7 advisory** (never block — `task-state-guard`, `session-guard`, `caveman-budget`,
  `caveman-activate`, `notify`, `expert-inject`, `antigravity-hook`).
- **Frozen lint** — `scripts/lint-no-self-eval-gates.sh` enforces five invariants:
  *completeness* (exactly one valid tag per hook); *mechanical* ⇒ contains a blocking `exit 1`/`exit 2`
  AND reads an artifact (file/`grep`/`awk`/path, `$COMMAND`/`CLAUDE_TOOL_INPUT`, or `$?`);
  *judgment* ⇒ declares `tier=judgment` AND a routing word (route/stronger/user); *advisory* ⇒ never
  blocks; *no-self-eval* ⇒ no gate gates a decision on a self-affirmation phrase
  (`looks good`/`lgtm`/`i confirm`/`self-assess`/`trust me`/`seems (done|fine|correct|good)`/…). It
  accepts `--hooks-dir <dir>` so a copy can be linted in isolation (default: the real `hooks/`).
- **Findings record** — `resources/gate-audit.md`: the principle, the per-gate classification table,
  and the conclusion. The header tags are the machine source of truth; the doc is the narrative.

**Finding:** no gate decides pass/fail by the model judging its own work. The enforcement gates are
all mechanical; the only judgment is `step-gate`, which routes to the user / a logged decision (a
stronger authority can audit it), not to the author-model.

## How it was verified
Frozen verification: `bash .harness/skills-src/scripts/lint-no-self-eval-gates.sh`

- **Positive (real tree):** `lint-no-self-eval: PASS (19 gates: 11 mechanical, 1 judgment, 7
  advisory; no model self-eval)`, exit 0.
- **Negative (regression catches), each via `--hooks-dir` on a copy with one injected violation:**
  - untagged hook → FAIL naming `orphan.sh` (completeness).
  - advisory with `exit 1` → FAIL naming `bad-adv.sh`.
  - mechanical that greps `"looks good"` to decide → FAIL naming `bad-self.sh` (self-eval).
  - mechanical with no blocking exit → FAIL naming `bad-mech.sh`.
  - judgment without `tier=judgment` → FAIL naming `bad-judg.sh`.
  - control (clean copy) → PASS.
- **Tagged hooks still execute:** `git-guard` blocks a force-push to master (exit 1); `notify` exits
  0; the F48 `expert-inject` tests still pass (`9` + `10` checks) after its tag was added.
- **Baseline:** `scripts/validate.sh` → `== validate: PASS ==`.

## Test
- lint-no-self-eval-gates (frozen) — PASS, exit 0; tally 11/1/7 matches the audit.
- 5 negative cases each produce exit 1 with the offending file named; control copy PASS.
- Regression guard: F48 inject hook tests green; `validate.sh` PASS.

## Review
- [x] **R1 — "reads an artifact" is a syntactic proxy, not a semantic proof.** Accepted: a lint
  cannot prove semantics; the positive check (a blocking gate must contain a file/command/exit read)
  plus the self-affirmation-phrase scan catches the realistic regression (a gate that greps the
  model's prose for "looks good"). Every current mechanical gate satisfies the positive check.
- [x] **R2 — advisory gates that read artifacts (task-state-guard, expert-inject) could look like
  self-eval.** Resolved: they make NO pass/fail decision (never block); the `no blocking exit`
  invariant is the correct, checkable definition of advisory, and the lint enforces it.
- [x] **R3 — is `step-gate` a model self-grade?** No: the advance decision routes to the user (gated)
  or a logged decision (auto) that a stronger reviewer can audit — tagged `tier=judgment`. The lint
  requires the tier tag + a routing word so the chokepoint can never be silent.
- [x] **R4 — tag drift.** Mitigated: the tag lives in the gate file and the lint requires it on every
  `hooks/*.sh`; a new untagged hook fails.
No open findings remain.

## Key decisions made
- **Co-locate the classification with the code, not in a separate table.** The header tag travels
  with the gate; a drifting external registry was the very failure F46 fixed for the expert map.
  `resources/gate-audit.md` is narrative only; the lint reads the tags.
- **Define "advisory" as `never blocks`, mechanically.** This cleanly separates the gates that
  *read artifacts to nudge* from the gates that *read artifacts to decide* — no semantic guessing.
- **Keep `step-gate` a judgment gate rather than forcing it mechanical.** "Is this step good enough
  to advance" is genuinely irreducible; the honest move is to label it `tier=judgment` and route it
  to a stronger authority, not to fake a mechanical check. The lint makes that routing mandatory.
- **No gate logic changed.** The audit found the gates already mechanical; this US adds the
  classification + enforcement layer only (scope discipline).

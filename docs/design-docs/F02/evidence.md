# Evidence: Core resources: mapping, autonomy, persona, token-budget, step-gate

## What was built
Five shared convention docs under `.harness/skills-src/resources/` (submodule commit `ec19ad0`):

- `agent-tool-mapping.md` — capability→agent map (ask-user / spawn-subagents / generate-image) + model-tier (fast/strong) + click-select rule.
- `autonomy-mode.md` — `gated` (default) vs `auto`, the always-stop list overriding both, storage in task-state `Mode:`.
- `persona-mode.md` — **the Developer vs Non-Technical contract**: question depth, language, surface-vs-decide, stop cadence, per-phase behavior. Gates are explicitly persona-independent.
- `token-budget.md` — caveman policy (inter-agent only, never user-facing unless opted in), artifact compaction, context threshold, "quality outranks cost" hard rule. Links `vendor/caveman`.
- `step-gate.md` — confirm-before-next-step contract (run next / run all / revise / stop), auto-mode logging, persona interaction, skill+hook backstop.

The empty `resources/.gitkeep` was removed (directory now has real content).

## Test
The exact F02 verification command was run and passed:

```
$ bash -c 'cd .harness/skills-src && for f in resources/agent-tool-mapping.md \
    resources/autonomy-mode.md resources/persona-mode.md resources/token-budget.md \
    resources/step-gate.md; do test -f "$f" || exit 1; done && bash scripts/validate.sh'
== validate harness-skills ==
== validate: PASS ==
VERIFY-CMD: PASS
```

Docs-only feature (markdown), so per `check-test-strategy` the test scope is **structural only** —
no UT/IT/regression/e2e/perf/security runtime applies. `validate.sh` confirms structure integrity.

## Review
Self-review of the five docs:

- **Cross-link integrity:** persona-mode ↔ step-gate ↔ autonomy-mode reference each other so an
  author cannot read one in isolation; token-budget links agent-tool-mapping (model-tier) and
  `../vendor/caveman` (verified the path exists in the submodule). No dangling links.
- **Consistency check:** "gates are persona-independent" in persona-mode matches step-gate's
  "review/test identical for both" and token-budget's "quality outranks cost" — the three do not
  contradict on the central rule that cost/persona never weaken a quality gate. Confirmed aligned.
- **Conciseness:** each doc is < ~120 lines, honoring token-budget's own compaction guidance
  (these are included-by-reference, so bloat would be self-defeating).
- No correctness or scope issues; conventions/per-language docs correctly deferred to F16.

## Key decisions made
- **Persona is a communication/question-depth setting, not a quality setting** — encoded
  explicitly so future skill authors never gate-skip for non-tech users.
- **Caveman scoped to inter-agent prose only** — protects user-facing clarity (esp. Non-Technical)
  while still capturing the bulk of wasted tokens.
- **Gate lives in the skill, enforcement in a hook (F12)** — belt-and-suspenders, documented now
  so F12 has a contract to implement against.

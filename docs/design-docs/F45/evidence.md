# Evidence: F45 — Enforce test rigor (IT test-case tables + full E2E coverage + green-verdict gates)

## What was built
Skills (harness-skills submodule, branch `improve-test-flow`):
- `test-integration` — mandatory `### Integration Test Cases` table (ID/Scenario/Preconditions/
  Steps/Input/Expected Output/Result), with a worked 4-case example; Expected Output must be concrete.
- `test-e2e` — full-system coverage rule (every `design-ux-flow` flow → a spec), `### E2E Coverage
  Matrix`, and a Playwright Page Object Model scaffold.
- `test-unit` / `test-regression` — require a green verdict line (test counts / baseline ref).
- `check-test-strategy` — documents the enforced evidence formats.

Hooks (PreToolUse on `harness verify`):
- `test-type-coverage-gate.sh` — blocks if any recorded `<type>:` verdict is not PASS.
- `it-testcase-gate.sh` — blocks if integration selected without a test-case table (Steps +
  Expected Output + ≥1 executed row).
- `e2e-coverage-gate.sh` — blocks if e2e selected without a coverage matrix, without a spec-file
  reference, or with any flow MISSING/UNCOVERED/PARTIAL/TODO.

Wiring: added to `config-templates/claude.settings.json` and the live `.claude/settings.json`.

## Test
F45 verification ran from the project root and passed:
```
grep -q it-testcase-gate .claude/settings.json && cd .harness/skills-src \
 && for h in test-type-coverage-gate it-testcase-gate e2e-coverage-gate; do test -x hooks/$h.sh; done \
 && grep -qi "Integration Test Cases" skills/test-integration/SKILL.md \
 && grep -qi "E2E Coverage Matrix" skills/test-e2e/SKILL.md \
 && grep -q it-testcase-gate config-templates/claude.settings.json \
 && bash scripts/validate.sh
-> VERIFICATION PASS (validate: PASS)
```

Behavioural gate tests (fixtures under a temp sandbox, since the gates act on evidence files):
- unit: PASS — gate behaviour, 5 fixtures, all as expected:
  | Fixture | Gate | Expected | Got |
  |---------|------|----------|-----|
  | full proper evidence | all three | allow (exit 0) | allow |
  | integration recorded, no case table | it-testcase | block (exit 1) | block |
  | e2e matrix with a MISSING row | e2e-coverage | block (exit 1) | block |
  | unit verdict = FAIL | test-type-coverage | block (exit 1) | block |
  | unit-only (no IT/e2e) | it-testcase + e2e-coverage | allow (fail-open) | allow |
- regression: PASS — ran all three gates against every existing feature's evidence
  (`docs/design-docs/F01..F44/evidence.md`); 0 features tripped (no false positives).
- All three hooks pass `bash -n`; submodule `scripts/validate.sh` -> PASS.

This is a docs/tooling feature (skill text + bash gates); no application runtime test applies.

## Review
Self-review against the repo's quality rules:
- The gates fail open when their tier is not selected, keying off the formal `- <type>:` record
  line. Prose-only `## Test` sections in F01–F44 contain no such line, so legacy evidence is never
  tripped — confirmed empirically against all 44 features.
- Skills and gates are deliberately coupled: each gate enforces exactly the evidence format its
  skill prescribes, so an agent following the skill passes the gate by construction.
- "Do not weaken an Expected Output / delete an uncovered row to force a pass" is stated in both the
  skills and the gate messages, upholding quality-over-cost ([token-budget.md]).
- No gate weakens an existing one; they were appended after `quality-gate` in the PreToolUse chain.
- Out-of-scope, recorded honestly: the harness binary is not installed, so verification was run
  manually rather than via `harness verify`; the stale root `hooks/` copy was left untouched
  (live settings reference `.harness/skills-src/hooks/`). Not pushed, per the chosen git flow.

## Key decisions made
- Gates derive the selected test types from the evidence `## Test` verdict lines, not from
  `features.json` — because `verification` there is a flat list of shell commands, not structured
  test-type metadata.
- `test-type-coverage-gate` does not force a `unit:` line to exist (would false-positive on
  legitimately code-free infra/docs features); it only requires that any recorded verdict is green.

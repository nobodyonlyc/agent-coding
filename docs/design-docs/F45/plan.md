# Plan: F45 — Enforce test rigor (IT test-case tables + full E2E coverage + green-verdict gates)

## Problem
The Phase 7 test skills (test-unit/integration/regression/e2e) were advisory: they described good
practice but nothing enforced it. The only test-related gate (`quality-gate`) checked that a
`## Test` heading exists in evidence — not that the recorded tests passed, that integration tests
were written as concrete test cases, or that a UI's E2E coverage was complete. An agent could record
a vague "integration: works" or cover only a couple of UI flows and still pass `harness verify`.

## Goal
Make the test methodology enforceable for UT, IT, regression, and E2E:
- IT must be documented test cases with explicit steps and a concrete expected output.
- For UI, E2E must cover the whole system — every user flow from `design-ux-flow` gets a spec.
- A recorded test-type verdict that is not PASS must block verify.
- Keep it backward-compatible: never trip the 44 existing passing features.

## Approach
Skills and gates are coupled through the evidence `## Test` format the skills already use:

1. **Skills (harness-skills submodule)** — define the canonical evidence formats:
   - `test-integration`: mandatory `### Integration Test Cases` table
     (ID · Scenario · Preconditions · Steps · Input · Expected Output · Result) + worked example.
   - `test-e2e`: full-system coverage rule + `### E2E Coverage Matrix` (flow → spec → Status) +
     Playwright POM scaffold.
   - `test-unit` / `test-regression`: require a green verdict line (counts / baseline ref).
   - `check-test-strategy`: document which gate enforces which format.

2. **Gates (PreToolUse on `harness verify <id>`, reading `docs/design-docs/<id>/evidence.md`)**:
   - `test-type-coverage-gate.sh` — block if any recorded `<type>:` verdict is not PASS.
   - `it-testcase-gate.sh` — when `integration:` is recorded, require a test-case table with
     Steps + Expected Output and ≥1 executed (PASS/FAIL) row.
   - `e2e-coverage-gate.sh` — when `e2e:` is recorded, require a coverage matrix, ≥1 real spec-file
     reference, and no flow left MISSING/UNCOVERED/PARTIAL/TODO.
   Each gate fails open (exit 0) when its tier is not selected, so unrelated features are untouched.

3. **Wiring** — add the three gates to `config-templates/claude.settings.json` (template) and the
   live `.claude/settings.json` PreToolUse Bash matcher.

## Scope / non-goals
- No new app code (this repo is a scaffolding platform; the gates govern generated projects).
- The stale root `hooks/` copy is out of scope (live settings reference `.harness/skills-src/hooks/`).

## Risks
- False positives on existing evidence → mitigated: gates key off formal `- <type>:` record lines,
  which prose-only `## Test` sections (F01–F44) do not contain. Verified across all 44 features.

## Git
Skill/hook changes live in the `harness-skills` submodule (branch `improve-test-flow`, commit
`8ccec39`); the parent bumps the gitlink + live settings (commit `e4da33c`). Not pushed.

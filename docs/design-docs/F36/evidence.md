# Evidence: Deep: component dev skills (be/fe/cli/db/batch)

## What was built
Raised the five Phase 5 component dev skills to the deep bar. As code-touching skills, on-demand
depth = a short **Bad-vs-Good** fenced example per skill (the standard's preferred form). Each
gained a `Use when:` trigger, a `## One-Liner`, a `**Gate:**` on the self-check, and the example:

- **dev-be** — contract drift / injection / secret vs validated + parameterized + designed errors.
- **dev-fe** — happy-only view vs all-states + data hook + presentational view.
- **dev-cli** — error-to-stdout/exit-0 vs error-to-stderr/non-zero + parseable stdout.
- **dev-db** — editing a shipped migration / silent drop vs forward-only + data-preserving + index.
- **dev-batch** — unbounded/no-checkpoint/double-apply vs bounded + checkpointed + idempotent.

Conventions links, always-stop (dev-db destructive), and handoff wiring preserved.

## How it was verified
Immutable verification command:
```
cd .harness/skills-src && for s in dev-be dev-fe dev-cli dev-db dev-batch; do \
  bash scripts/lint-depth.sh "$s" >/dev/null || exit 1; done && bash scripts/validate.sh
```
Result: all five `lint-depth` PASS, `validate: PASS`, EXIT=0. Relative-link recheck: no broken links.

## Review
- [x] Each `description` has a `Use when:` clause.
- [x] Each skill has a `## One-Liner`.
- [x] Each has an explicit Gate on the self-check.
- [x] On-demand depth = Bad-vs-Good example (code-touching skills).
- [x] Examples kept 4-10 lines, illustrative not framework-locked; links re-verified; `validate.sh` PASS.

## Key decisions made
- Bad-vs-Good over output templates here, per the standard's preference for code rules.
- Language dev skills (dev-js-ts/python/go/rust) are intentionally out of scope — they are F38 (light).
- Scope held to F36.

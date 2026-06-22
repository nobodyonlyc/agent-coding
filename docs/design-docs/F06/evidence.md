# Evidence: workflow-team

## What was built
`skills/workflow-team/SKILL.md` — solo vs team coordination on the shared features.json. Table
contrasts WIP (global vs per-assignee), claim, integration, auto-advance. Team loop (pull -> claim
--assignee --branch -> work -> PR review gate -> push status), handoff via session-handoff +
plan/evidence, conflict rules (first-committer-wins, never force-push features.json). Persona/step-gate
shared with solo.

## Test
F06 verification ran and passed:
```
test -f skills/workflow-team/SKILL.md && bash scripts/validate.sh -> PASS ; VERIFY-CMD PASS
```
Skill doc -> structural test (frontmatter + relative links). No runtime test applies.

## Review
Self-review: solo/team boundary is crisp (global vs per-assignee WIP=1; checkpoint vs PR gate).
Claim-before-start + push-immediately + first-committer-wins are internally consistent and match
harness's git-tracked features.json model. PR review gate delegates to check-pr-review (F08).
branch/state-merge conventions referenced as future resources, noted in plan. No issues.

## Key decisions made
- Team integration goes through a PR review gate (check-pr-review) rather than direct merge, so the
  review quality gate is enforced at integration time too.
- Conventions (branch/state-merge) referenced by path but deferred — keeps F06 focused on the
  coordination contract.

# Evidence: M1 role-resolver: design-derived subagent role spec

## What was built
- `scripts/role-resolver.sh` — emits a JSON **role spec** for the subagent a lifecycle phase must
  spawn. Wraps `experts-resolver.sh` so the role's expertise is derived from the design (the Stack
  block), then maps the phase to an archetype + mandate. `--format brief` for a one-line summary.
- `resources/phase-roles.md` — documents the phase→archetype matrix (design→architect,
  review→techlead, security→security-reviewer, qa→qa-engineer, code→implementer); marks the script
  as the single source of truth.
- `scripts/test-role-resolver.sh` — the frozen F52 verification.

Example: `--phase review --language go --component be` →
`{title:"Go Backend Tech Lead", archetype:"techlead", expertise:["dev-be","dev-go","golang-pro"],
based_on:"docs/design/architecture.md#stack", independent:true}`.

## How it was verified
Verification command: `bash .harness/skills-src/scripts/test-role-resolver.sh` → **13 passed,
fail=0**. Cases: go/be review archetype+title+based_on+exact expertise chain; each phase→archetype
(design/review/security/qa/code); python+django title; output parses as JSON; unknown phase exits
non-zero; missing `--phase` exits non-zero; an unresolved stack degrades to a valid non-blocking
spec (expertise `[]`, `based_on null`, exit 0).

## Key decisions made
- **Reuse experts-resolver, don't reinvent stack parsing.** The role's expertise is the existing
  deterministic chain; role-resolver only adds the phase→archetype layer. Keeps one source of truth
  for stack→skills.
- **Script is the source of truth; phase-roles.md documents it.** Mirrors the expert-skills-map
  pattern; avoids a model inventing the mapping.
- **Degrade, never block.** An unresolved stack still yields a generic role (per agent-tool-mapping:
  missing capability → fallback, never block). The reviewer is still spawned, just without a
  language-specific expert chain.
- **`independent: true` baked into the spec** so every consumer carries the no-self-review rule.

## Review
- [x] Self-review of the diff. Checked: arg parsing rejects unknown flags (exit 2); `--phase`
  required; python block is the only logic path and emits valid JSON (asserted by the test); no
  shell-injection surface (args passed as argv to experts-resolver, not eval'd); degrade path
  returns exit 0 with a well-formed spec. No open findings.
- [x] Independent-reviewer spawn deferred to F54 (which wires skills/workflows to spawn role
  subagents); the provenance gate that would enforce it lands in F53. Consistent with the epic
  sequencing recorded in the F52 plan.

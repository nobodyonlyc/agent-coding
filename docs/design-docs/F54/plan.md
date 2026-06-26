# Plan: M4 per-phase role spawn across workflows

## Behavior to implement
The review/QA skills and every workflow instruct the host to spawn a **design-derived role**
subagent at each judgment phase and to record provenance via the CLI. agent-tool-mapping documents
the role+provenance obligation. Depends on F52 (role-resolver), F53 (gate), H-M2 (CLI).

## Approach
- Keystone: rewrite `check-review-loop/SKILL.md` §1 to a role-based flow (resolve role via
  role-resolver → `harness review open` → spawn the role reviewer → `harness review record`) and
  update its Gate section to cover both `review-fix-gate` and `review-provenance-gate`.
- Add a short "run as a role" note to `check-code-review`, `check-security-review` (`--phase
  security`), `check-qa` (`--phase qa`), each pointing at role-resolver + phase-roles.md.
- Update `resources/agent-tool-mapping.md`: spawn-subagents row + a new subsection documenting the
  role + provenance flow and the degrade/fallback.
- Reference the role-based spawn in all four workflows (bootstrap Stage A design + Stage B review,
  feature §6, bugfix Phase 6, team step 3).
- Verification: `scripts/test-phase-role-spawn.sh` — a content lint asserting the required
  references exist in each file (drift-catching, like lint-expert-map).

## Files to touch
- `skills/check-review-loop/SKILL.md`, `skills/check-code-review/SKILL.md`,
  `skills/check-security-review/SKILL.md`, `skills/check-qa/SKILL.md`
- `resources/agent-tool-mapping.md`
- `skills/workflow-bootstrap|feature|bugfix|team/SKILL.md`
- `scripts/test-phase-role-spawn.sh` — NEW.

## Not in scope
- The CLI (H-M2), resolver (F52), gate (F53) themselves.
- The SubagentStop auto-record hook + final docs/install wiring (F55).

## Risks / unknowns
- Content-lint can assert references exist but not that a model obeys them — same honest limit as
  expert-inject (a hook/skill can name the obligation, not force the thought). The execution-grade
  enforcement is the F53 gate; this US ensures hosts are told how to satisfy it.

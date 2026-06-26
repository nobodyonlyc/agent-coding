# Evidence: M4 per-phase role spawn across workflows

## What was built
Wired the design-derived role + provenance flow into the skills and every workflow so a host is told
to spawn a **role** (not a faceless agent) at each judgment phase and to record provenance:

- `check-review-loop/SKILL.md` — §1 rewritten to a 4-step role-based flow: resolve role
  (`role-resolver.sh --phase review`) → `harness review open` → spawn the role reviewer → `harness
  review record`; Gate section now documents both `review-fix-gate` (checklist) and
  `review-provenance-gate` (CURRENT/STALE diff-hash binding).
- `check-code-review`, `check-security-review` (`--phase security`), `check-qa` (`--phase qa`) — each
  gained a "run as a design-derived role" note pointing at role-resolver + phase-roles.md, and the
  review skills cite `harness review open/record`.
- `resources/agent-tool-mapping.md` — `spawn-subagents` row updated; new "carry a design-derived
  role + record provenance" subsection (resolve role → open → spawn (not the author) → record →
  gate), with the degrade-never-block fallback.
- Workflows `workflow-bootstrap` (Stage A design review + Stage B ⑥ review), `workflow-feature` (§6),
  `workflow-bugfix` (Phase 6), `workflow-team` (step 3) — each now references the role-based reviewer
  (`role-resolver`) and provenance.
- `scripts/test-phase-role-spawn.sh` — the frozen F54 verification.

## How it was verified
Verification command: `bash .harness/skills-src/scripts/test-phase-role-spawn.sh` → **16 passed,
fail=0**. The content lint asserts: role-resolver.sh + phase-roles.md exist; check-review-loop names
role-resolver + `harness review open` + `harness review record` + `review-provenance-gate`;
check-code-review/security/qa carry the role (security uses `--phase security`, qa `--phase qa`);
agent-tool-mapping documents role + `harness review`; and all four workflows reference the role-based
spawn. Repo `scripts/validate.sh` → PASS (skills still well-formed).

## Key decisions made
- **Keystone in check-review-loop; pointers elsewhere.** The full open→spawn→record loop lives in
  one place; other skills/workflows reference it so the mechanism has a single source of truth and
  the prose stays DRY.
- **Role is resolved from the Stack block, not chosen by the model.** Reuses F52's role-resolver, so
  the reviewer's expertise is deterministic per the design (a Go review gets a Go tech lead chain).
- **Per-phase archetypes.** design→architect, review→techlead, security→security-reviewer,
  qa→qa-engineer — each phase spawns the right kind of role, satisfying "subagents at each phase".
- **Content-lint verification.** SKILL.md prose can't be unit-tested for behavior; asserting the
  required references exist is the durable, drift-catching check (same spirit as lint-expert-map).

## Review
- [x] Self-review of the diff. Checked: every edited SKILL.md still parses (validate.sh PASS); the
  added flow is internally consistent (open uses --role, record consumes the nonce, gate reads
  status); no contradictory instructions introduced; the lint needles match the prose actually
  written. No open findings.
- [x] This US is what makes the F53 gate meaningful — hosts now have explicit instructions to
  produce the provenance the gate enforces.

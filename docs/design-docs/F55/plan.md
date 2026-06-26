# Plan: M5 SubagentStop provenance hook + tests + docs

## Behavior to implement
On Claude Code, a `SubagentStop` hook nudges the main agent to record review provenance for the
in-progress feature after a reviewer subagent finishes. End-to-end shell test ties resolver → CLI →
gate together. Docs updated. (Cross-host fallback stays the documented CLI call.)

## Approach
- `hooks/review-record-reminder.sh` — SubagentStop hook. **Honest design:** a hook cannot know the
  reviewer's verdict, so it does NOT fabricate a record; it reads the in-progress feature
  (features.json), queries `harness review status <id> --json`, and — only when state is **not
  CURRENT** — injects a `system-reminder` (stderr + Claude additionalContext) telling the agent to
  `harness review record <id> --nonce <n> --verdict …` (or re-review if STALE). Always exits 0
  (advisory, never blocks). Stays silent when provenance is already CURRENT or no feature is active.
- Wire into `config-templates/claude.settings.json` under a new `SubagentStop` event (Claude-only;
  Antigravity has no SubagentStop — its fallback is the CLI call documented in the skills).
- `scripts/test-subagent-provenance.sh` (F55 verification): (a) the reminder hook stays silent with
  no in-progress feature and when provenance is CURRENT, and emits the record reminder when NONE;
  (b) end-to-end: `role-resolver --phase review` feeds `--role` into `harness review open`, `record`
  makes status CURRENT — proving the role→open→record→status chain works together.
- Docs: add a "Review enforcement (role + provenance)" section to `README.md`; write the epic design
  doc to `docs/review-provenance.md`.

## Files to touch
- `hooks/review-record-reminder.sh` — NEW.
- `config-templates/claude.settings.json` — add SubagentStop event.
- `scripts/test-subagent-provenance.sh` — NEW (the F55 verification).
- `README.md` — new section.
- `docs/review-provenance.md` — NEW (epic design record).

## Not in scope
- Auto-fabricating a verdict (unsound — a hook can't review). The reminder is the honest ceiling;
  the execution-grade enforcement is the F53 gate.
- Live activation (install.sh re-run + binary deploy to consumers) — done as the epic closeout after
  F55 verifies, to avoid the gate blocking this epic's own verifies.

## Risks / unknowns
- SubagentStop availability is Claude-specific; documented. Antigravity/Codex rely on the in-skill
  CLI instructions (F54) instead.
- The reminder reads the single in-progress feature (WIP=1); if WIP were >1 it nudges for the first.
  Acceptable under the harness WIP=1 rule.

# AGENTS.md

Universal operating rules for all agents in this repo (Claude Code, Codex, Antigravity).
Keep this file under 120 lines. Domain details live in `docs/`.

## What this repo is

A scaffolding platform for long-running agent work. The `harness` CLI tracks a feature backlog,
enforces WIP=1, runs verification commands, and manages session handoffs. State is stored in
SQLite (`.harness/harness.db`) and synced to git-tracked `.harness/features.json`.

## Quick start

```bash
./init.sh              # sync deps + baseline verification
./harness status       # view backlog
./harness resume       # active feature + next step
```

<!-- COMMON_RULES_START -->
## Entry point — ALWAYS FIRST

On **any** incoming prompt that asks to build, add, change, or fix something,
your **first action** is to run the **workflow-intake** skill — do not implement
directly. Read and follow its canonical definition, then do exactly what it routes you to:

    .harness/skills-src/skills/workflow-intake/SKILL.md

Intake classifies the request (new project / feature / bugfix / legacy onboarding)
and dispatches into the harness flow (BA → design → plan → backlog → code → verify).
This step is mandatory because not every host auto-selects skills by description —
Antigravity and Codex only run a workflow when it is explicitly invoked. Skipping
intake means bypassing the harness entirely (no backlog, no plan gate, no evidence).

Only pure questions / read-only inspection (no file changes) may skip intake.

**Skill reference convention:** anywhere a skill is named in backticks (e.g.
`workflow-bootstrap`, `plan-ba-analysis`, `dev-be`) or linked, it means *read and
follow* `.harness/skills-src/skills/<name>/SKILL.md`. Never infer behavior from the
name alone — open the file. This holds for every host (Claude Code, Antigravity, Codex).

## Hard rules (≤15)

1. **WIP = 1** — only one `in_progress` feature at a time. Use `./harness start <id>`.
2. **Verify before done** — a feature is not complete until `./harness verify <id>` passes.
3. **Session bookend** — begin with `./harness resume`; end with `./harness session stop`.
4. **English for the engineering record** — code, commits, comments, design docs, plan files, evidence, backlog entries, and inter-agent outputs are English, always. **User-facing material is the exception**: documentation written for end users, and direct replies to the user, use the user's language.
5. **Repo is the record** — never rely on chat history. State lives in `.harness/` and `docs/`.
6. **No silent completion** — do not mark a feature `passing` without evidence in `docs/design-docs/<id>/evidence.md`.
7. **Fix baseline first** — if `./init.sh` or smoke tests fail, fix before adding new work.
8. **Scope discipline** — stay inside the active feature. Cross-cutting fixes go into a separate feature.
9. **Outputs > 10 lines go to files** — write to `.harness/reports/` or `.harness/logs/`, not the chat.
10. **Comments explain Why, not What** — code is self-documenting; comments are for non-obvious constraints.
11. **Proximity docs required** — run `harness plan <id>` to scaffold `docs/design-docs/<id>/plan.md`, fill it in, then `harness start <id>`. Start is blocked until the plan placeholder is replaced. `harness verify` blocks without a non-trivial `evidence.md`.
12. **Verification commands are immutable after start** — define them at `harness add` time. Do not add or change them after `harness start <id>`. Immutability prevents self-evaluation bias.

## Session loop

```
start  → ./harness resume  → pick highest-priority not_started feature → ./harness start <id>
work   → implement → unit test → fix → repeat until green
verify → ./harness verify <id>  (must pass before moving on)
stop   → ./harness session stop → ./harness clean → commit
```

## CLI reference

| Command | Purpose |
|---|---|
| `harness init` | Initialize `.harness/` and seed backlog |
| `harness status` | Print backlog table |
| `harness resume` | Active feature, task-state, next step |
| `harness report` | Progress counts, last completed, next up, blocked, verify trend |
| `harness add <id> <title> ...` | Add feature or child-task |
| `harness plan <id>` | Scaffold `docs/design-docs/<id>/plan.md` and `evidence.md` templates |
| `harness start <id> [--force]` | Mark in-progress (WIP=1 + plan gate enforced; `--force` bypasses both) |
| `harness verify <id> [--override-snapshot]` | Run verifications, record evidence, mark passing |
| `harness block <id> --reason "..."` | Mark blocked with reason |
| `harness session start --goal "..." [--contract "..."]` | Session lifecycle + sprint contract |
| `harness session stop/status` | End session / show active (handoff includes task-state) |
| `harness clean` | Delete transient logs and reports |
| `harness trace --skill <n> --purpose "..." --result "..."` | Log tool/approach usage (warns on high context) |
| `harness config set context_warn_threshold <n>` | Adjust context warning threshold (default 150000) |

<!-- COMMON_RULES_END -->

## Topic docs

- `docs/design-docs/<id>/` — per-feature design notes and evidence

# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

Read `AGENTS.md` first — it contains the universal operating rules for this repo.

## Claude Code–specific notes

- Use `AskUserQuestion` when the next step requires a decision only the user can make (e.g. priority call, destructive action).
- After every completed feature, run `./harness report` and print the output in chat.
- Offer `./run.sh` for manual verification if it exists.

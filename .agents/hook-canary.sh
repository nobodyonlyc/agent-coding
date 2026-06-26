#!/usr/bin/env bash
# TEMPORARY diagnostic — delete after confirming Antigravity runs hooks.
# Appends a timestamped line every time Antigravity invokes a PreToolUse hook,
# then returns a visible allow-reason. Independent of CommandLine extraction and
# of the gate self-filtering, so it proves the file is loaded + executed at all.
printf '%s antigravity ran a PreToolUse hook\n' "$(date '+%Y-%m-%dT%H:%M:%S')" >> /tmp/antigravity-hook-canary.log
printf '{"decision":"allow","reason":"hook-canary fired — Antigravity IS executing .agents/hooks.json"}\n'

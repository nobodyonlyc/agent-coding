# Plan: Deep check-security-review + wiring
## Behavior to implement
check-security-review (deep, OWASP-style + references/) exists, referenced by check-test-strategy + check-code-review; passes lint-depth.
## Approach
New skills/check-security-review/SKILL.md to depth bar: One-Liner; Core Philosophy (deny-by-default,
defense-in-depth); phased review (surface map -> per-category checks -> findings as tracked checklist
-> verify); Bad/Good; references/threat-checklist.md (OWASP-ish categories). Wire: check-test-strategy
security row -> link this skill; re-link from check-code-review (forward ref deferred in F26).
## Files to touch
- New: skills/check-security-review/SKILL.md + references/threat-checklist.md
- Modify: skills/check-test-strategy/SKILL.md, skills/check-code-review/SKILL.md, CATEGORIES.md
- This repo: bump submodule; evidence.
## Not in scope
- Pentest tooling skills (nmap/burp/metasploit from the registry) — breadth, later.
## Risks / unknowns
- Findings reuse the same [ ]/[x] tracked format so review-fix-gate covers security too.

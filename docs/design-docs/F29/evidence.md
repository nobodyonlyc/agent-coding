# Evidence: deep check-security-review

## What was built
- skills/check-security-review/SKILL.md (deep bar): One-Liner; Core Philosophy (deny-by-default,
  trust boundaries); phases map-surface -> per-category audit -> tracked findings, each Gated; Bad/Good
  (horizontal privilege escalation); references/threat-checklist.md (authN/authZ, injection, secrets,
  data exposure, deserialization, SSRF, deps).
- Wired: check-test-strategy security row links it; check-code-review security dimension escalates to
  it (forward ref from F26 now resolved); CATEGORIES updated.

## Test
F29 verification passed:
```
test -f check-security-review && grep -qi security-review check-test-strategy && lint-depth check-security-review && validate -> VERIFY-CMD PASS
```
lint-depth: PASS. Link recheck on 3 edited skills: no broken links.

## Review
- [x] findings use the same [ ]/[x] tracked format so review-fix-gate enforces security findings too — yes.
- [x] forward ref deferred in F26 now resolves to a real skill — re-linked + audited.
- [x] fills the standalone-security-gate gap flagged earlier (weakness #3). — closed

## Key decisions made
- Security review reuses the tracked-finding format + review-fix-gate rather than a separate gate, so
  one mechanism enforces all review findings.
- Pentest tooling skills (nmap/burp/metasploit) left out — breadth, not the depth concern.

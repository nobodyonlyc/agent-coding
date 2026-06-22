# Plan: Skill depth standard + lint-depth + enrich review pair

## Behavior to implement
skill-depth-standard.md defines the deep-skill bar; lint-depth.sh checks a skill meets it; check-code-review enriched to the bar with references/ and passes lint-depth.

## Approach
Reference repo (nobodyonlyc/skills) shows the depth pattern weak models need: rich frontmatter with
"Use when" triggers, One-Liner, phases+Gates, Bad/Good examples, output templates, references/ for
on-demand detail. Encode that as an enforceable standard.
1. resources/skill-depth-standard.md — the deep-skill template + checklist.
2. scripts/lint-depth.sh <skill> — checks: description has "Use when"; has "One-Liner"; mentions
   "Gate"; has references/ dir OR a fenced example; (warn-only extras). Exit 1 on fail.
3. Enrich skills/check-code-review/ to the bar: restructure SKILL.md + add references/{review-checklist,
   common-issues,report-template}.md. Make it the canonical example.
Keep lint-depth OPT-IN (only run on named deep skills via verifications) so thin skills are not broken.

## Files to touch
- New: resources/skill-depth-standard.md, scripts/lint-depth.sh,
  skills/check-code-review/references/{review-checklist,common-issues,report-template}.md
- Modify: skills/check-code-review/SKILL.md, CATEGORIES.md (note the standard)
- This repo: bump submodule; docs/design-docs/F26/evidence.md.

## Not in scope
- Enriching the other backbone skills (F27-F30). Forcing the standard on ALL skills (opt-in only now).

## Risks / unknowns
- lint-depth must be lenient enough to not false-fail, strict enough to catch a thin skill -> check
  for the 4 core markers only.

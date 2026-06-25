# Plan: Suppress implicit skill auto-select for non-entry skills

## Behavior to implement
Codex and Antigravity auto-load skills by description semantic-match; surfacing all ~83 skills lets a
weak model pull craft/expert/component skills out-of-band, bypassing the spine + gates. Constrain
implicit selection to the entry-tier spine:
- (a) **Codex** → generate an `openai.yaml` implicit-invocation policy derived from each skill's
  frontmatter `metadata.tier` (F46): `tier: entry` → `allow_implicit_invocation: true`; everything
  else (judgment / mechanical / no tier) → `false`, reachable only by explicit name.
- (b) **Antigravity** → keep the spine in explicit Workflows (`/name` adapters that reference skills
  by name), minimizing reliance on implicit skill pickup. (Already produced by `wire_antigravity`.)
- **Only entry-tier skills are implicitly selectable on any host.**

## Establish the entry-tier set (precondition)
F46 introduced `tier` but tagged only the 14 skills it touched, leaving the entry set inconsistent
(`workflow-bugfix` = entry, but `workflow-intake/bootstrap/feature/team` carry no tier). The
legitimate front-doors are the 5 `workflow-*` orchestrators (intake is THE entry per AGENTS.md; the
others are top-level routes). So: add `metadata: {layer: workflow, tier: entry}` to the four
workflows that lack it. The **default-off** rule (no tier ⇒ false) safely covers the other 78 skills
without tagging each — only an explicit `tier: entry` grants implicit invocation.

## Approach
1. **Tag the entry set** — add `layer: workflow` + `tier: entry` to `workflow-intake`,
   `workflow-bootstrap`, `workflow-feature`, `workflow-team` (workflow-bugfix already has it). No
   `delegates` added (so the F46 map is unchanged).
2. **Generator** — `scripts/gen-implicit-policy.sh` (python3 embedded, same frontmatter reader as
   gen-expert-map): walk `skills/*/SKILL.md`, read `metadata.tier`, emit a deterministic (sorted)
   `openai.yaml`:
   ```
   # GENERATED ... do not edit
   skills:
     <name>:
       allow_implicit_invocation: <true if tier==entry else false>
   ```
   `--write <path>` writes the file; no-arg prints to stdout (for diff/test). Fails loud if a skill
   declares an unknown tier value.
3. **Wire into install.sh** — new `wire_codex_implicit_policy` writes `<PROJECT_ROOT>/.agents/openai.yaml`
   via the generator (alongside F50's `.agents/skills`). Add it to the install sequence and to the
   gitignore manifest (`.agents/openai.yaml`).
4. **Test (frozen verification)** — `scripts/test-implicit-policy.sh`:
   - **(a) Codex policy** (generator output): every `skills/*/` dir appears exactly once; each of the
     5 `workflow-*` → `true`; spot-checked craft/expert/component/design/review skills
     (`dev-be`, `python-pro`, `design-api`, `check-code-review`, `opt-caveman`, `react-expert`) → `false`;
     the COUNT of `true` equals the number of `tier: entry` skills (== count of `workflow-*`); the
     generator is deterministic (two runs identical).
   - **(b) install wiring** (hermetic, HARNESS_PROJECT_ROOT + GEMINI_CONFIG_DIR temp): running
     `install.sh` writes `.agents/openai.yaml` with that policy AND the explicit Antigravity spine
     `.agents/workflows/harness-workflow-*.md` adapters exist for the workflows (explicit `/name`).
   - **invariant**: no non-entry skill is ever `true` (scan the whole policy).
5. **Evidence** — record the policy excerpt, the entry/non-entry tally, the install wiring, and the
   determinism + invariant proof in `docs/design-docs/F51/evidence.md`.

## Files to touch
- `.harness/skills-src/skills/{workflow-intake,workflow-bootstrap,workflow-feature,workflow-team}/SKILL.md`
  — add `metadata` (layer: workflow, tier: entry)
- `.harness/skills-src/scripts/gen-implicit-policy.sh` — new, executable (python3)
- `.harness/skills-src/scripts/test-implicit-policy.sh` — new, executable (frozen verification)
- `.harness/skills-src/install.sh` — `wire_codex_implicit_policy` + sequence
- `install.sh` (top-level) — add `.agents/openai.yaml` to the gitignore manifest
- `.gitignore` — ignore `.agents/openai.yaml`
- `docs/design-docs/F51/evidence.md`

## Not in scope
- Per-skill `openai.yaml` sidecars inside the canonical skills dir — rejected: it would pollute the
  shared source. A single workspace manifest (`.agents/openai.yaml`) mirrors F50's `.agents/skills.json`
  and keeps the canonical dir pristine. (Noted in evidence; the generator could fan out later if a
  Codex build requires sidecars.)
- Changing the F46 expert map / delegates, or any gate logic.
- Live Codex/Antigravity run (unavailable) — the policy artifact is the deterministic, testable form.

## Risks / unknowns
- **Codex's exact openai.yaml shape.** I cannot consult a live Codex; I emit a clear, conventional
  `skills:<name>:allow_implicit_invocation` mapping (the field the behavior names) as a single
  workspace manifest. Documented as the chosen form; structure is simple YAML so it is easy to adapt.
- **Default-off correctness.** The safe default (no tier ⇒ implicit off) is exactly what we want;
  the only risk is a future legitimate entry skill missing `tier: entry` (it would just require
  explicit invocation — fail-safe, not fail-open).
- **Entry set scope.** Limiting entry to the 5 `workflow-*` orchestrators is the tightest defensible
  set; if a host needs another implicit front-door, tag it `tier: entry` and the policy follows.
- **Frozen-verification immutability** — finalize the test before `harness start`.

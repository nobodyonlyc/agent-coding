# Plan: Phase 3 UI Design

## Behavior to implement
UI skills produce mockups (generate-image, HTML/CSS fallback) and screen/UX flows.

## Approach
- design-ui: produce a mockup per screen via generate-image, fallback to static HTML/CSS; persona: non-tech approves visuals, dev confirms components/states/responsive.
- design-ux-flow: map screen-to-screen flows and states (empty/loading/error).
Link agent-tool-mapping (generate-image capability + fallback), persona-mode, step-gate.

## Files to touch
- New: skills/design-ui/SKILL.md, skills/design-ux-flow/SKILL.md
- This repo: bump submodule; docs/design-docs/F14/evidence.md.

## Not in scope
- Frontend implementation (dev-fe, F16); plan/test phases.

## Risks / unknowns
- generate-image may be unavailable -> must document the HTML/CSS mockup fallback (never block).

# BCDA Session Kickoff Prompt

Use this prompt at the start of a new Codex session.

```text
Use $bcda-sdd-steward for this BC Data Agent session.

Read:
- docs/sdd-index.md
- docs/project.md
- docs/code-generation-readiness.md
- docs/open-decisions.md
- docs/requirements.md
- docs/acceptance-criteria.md
- docs/traceability-matrix.md when reference coverage is useful

Then give me a compact status brief:
- Current implementation mode.
- Whether AL code generation is allowed.
- Blocking open decisions.
- Highest-risk areas.
- Best next action.

Do not generate AL code unless docs/code-generation-readiness.md says Ready and I explicitly ask for implementation.
```

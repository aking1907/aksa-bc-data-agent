# BCDA UX Design Review Prompt

Use this prompt for Business Central page and workflow design.

```text
Use $bcda-ux-design.

Design or review the BC Data Agent user experience for:
<describe the page/workflow/action>

Read:
- docs/app-design.md
- docs/project.md
- docs/domain-model.md
- docs/requirements.md
- docs/acceptance-criteria.md
- docs/admin-guide.md
- docs/operations-runbook.md
- docs/security-review.md

Apply Business Central-native UX:
- Task-focused pages.
- Correct page types.
- Clear action placement.
- Preview before execution.
- Visible risk, approval, rollback logging mode, retention period, and rollback availability.
- Clear states for rollback-disabled and snapshot-expired operations.
- Captions/tooltips/status fields suitable for SUPER users.

Return page layout, actions, states, warnings, acceptance coverage, and doc updates.
Do not generate AL code unless readiness is Ready and I ask for implementation.
```


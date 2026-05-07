---
name: bcda-ux-design
description: User experience and usability design for BC Data Agent. Use when designing Business Central pages, workflows, actions, captions, validation messages, approval flows, audit review, rollback UX, setup pages, admin guidance, or any SUPER-user-facing experience for controlled hidden or posted data correction.
---

# BCDA UX Design

## Purpose

Design Business Central experiences that make safe behavior the easiest path. The UI should support focused correction work without making high-risk editing feel casual.

## Required Reading

Read:

- `docs/project.md`
- `docs/domain-model.md`
- `docs/requirements.md`
- `docs/acceptance-criteria.md`
- `docs/admin-guide.md`
- `docs/operations-runbook.md`
- `docs/security-review.md`

## UX Principles

- Use Business Central-native page patterns.
- Prefer clear workflow states over clever interaction.
- Require reason and ticket before execution.
- Separate preview from execution.
- Show risk and approval state before dangerous actions.
- Make rollback availability visible after execution.
- Make rollback logging mode and retention period visible before execution.
- Show snapshot expiration and rollback-unavailable states plainly.
- Redact sensitive values unless the `SUPER` user and channel are authorized by policy.
- Keep audit review searchable and filterable.
- Avoid marketing-style screens; this is an operational tool.

## Core Screens

Plan or review:

- Setup page.
- Data policy list/card.
- Correction request list.
- Correction request card.
- Correction lines part.
- Preview/result page or factbox.
- Approval actions.
- Audit entries list/card.
- Rollback wizard.
- Retention status page or part.

## Workflow Checklist

For each page or action, verify:

- User knows current status.
- Next safe action is clear.
- Dangerous action requires confirmation and approval when needed.
- Failure state is recoverable and audit-visible.
- Rollback-disabled and snapshot-expired states are clear before dangerous actions.
- Sensitive values are redacted by policy and channel.
- Captions match domain language from `docs/domain-model.md`.

## Message Guidance

- State the blocked reason and next step.
- Do not expose sensitive values in errors.
- Prefer operational language: blocked, approval required, preview ready, rollback conflict.
- Avoid implying the app guarantees every Business Central table can be modified.

## Output Standard

Provide page/action recommendations, usability risks, required acceptance criteria, and doc updates.

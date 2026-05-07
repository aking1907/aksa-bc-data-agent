# Risk Register

| ID | Risk | Impact | Probability | Severity | Mitigation | Status |
| --- | --- | --- | --- | --- | --- | --- |
| RSK-001 | Editing posted financial data may violate business, audit, or legal rules. | High | Medium | Critical | Require approval, reason, ticket, policy allow-list, and human compliance review. | Open |
| RSK-002 | A correction may corrupt related BC invariants. | High | Medium | Critical | Dry-run, validation mode, sandbox testing, and rollback before production use. | Open |
| RSK-003 | Rollback may be incomplete if related records changed after correction. | High | Medium | High | Capture before-images and stop rollback on conflict by default. | Open |
| RSK-004 | Sensitive values may be exposed through audit, export, logs, or tests. | High | Medium | High | Policy and channel-based redaction; no sensitive values in telemetry or test fixtures. | Open |
| RSK-005 | `SUPER`-only access concentrates risk in highly privileged users. | High | Medium | High | Do not create broader app permissions; use deny-first policy, approval, audit, rollback, and sandbox validation. | Open |
| RSK-006 | The BC platform may block writes to some tables or field types. | Medium | High | High | Symbol discovery and sandbox proof before implementation claims support. | Open |
| RSK-007 | Generic "modify any data" scope may encourage misuse. | High | Medium | High | Position product as break-glass correction with policy and audit. | Open |
| RSK-008 | App-owned audit tables may grow large. | Medium | Medium | Medium | Retention policy, indexes, filters, and export/archive strategy. | Open |
| RSK-009 | Extension upgrade may break snapshot deserialization. | High | Low | High | Serialization version and upgrade tests. | Open |
| RSK-010 | Object ID range may be too small. | Medium | Medium | Medium | Foundation objects use 34 IDs in range 88100-88149; preserve remaining IDs for gated execution/export objects or request a larger range before expansion. | Watch |
| RSK-011 | Users may bypass standard BC correction flows unnecessarily. | Medium | Medium | Medium | Require reason, warnings, and policy guidance that normal flows are preferred. | Open |
| RSK-012 | Production deployment may occur before sandbox validation. | High | Low | High | Deployment gate requires sandbox validation evidence. | Open |
| RSK-013 | Rollback snapshots may be disabled for a correction where rollback is later needed. | High | Medium | High | Show rollback-unavailable state in preview and require confirmation; default posted/high-risk policies to require snapshots. | Open |
| RSK-014 | Retention cleanup may remove operation data needed for support, audit, or rollback. | High | Medium | High | Separate retention categories, conservative defaults, visible expiration dates, and retention cleanup tests. | Open |
| RSK-015 | Retention jobs may affect performance if they run too often or during business hours. | Medium | Medium | Medium | Prefer native retention policies, schedule outside business hours, and test with realistic data. | Open |
| RSK-016 | UI may make dangerous changes feel too easy. | High | Medium | High | Use task-focused pages, preview-first flow, confirmation dialogs, visible risk, and less prominent dangerous actions. | Open |
| RSK-017 | Self-approval or disabled approval may weaken dual-control oversight. | Medium | Medium | Medium | Keep approval with a separate approver as the safer default, make no-approval and self-approval explicit setup choices, show the setting on requests, and keep audit evidence. | Open |

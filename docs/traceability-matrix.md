# Traceability Matrix

| Requirement | Source | Architecture Component | Code Object Or Module | Acceptance/Test | Status |
| --- | --- | --- | --- | --- | --- |
| REQ-001 | `requirements.md` | Metadata Explorer | BCDA Metadata Explorer, BCDA Correction Line, BCDA Table Lookup, BCDA Field Lookup | AC-001 / TST-002 | Partial foundation table/field lookup; target record discovery pending |
| REQ-002 | `requirements.md` | Correction Orchestrator | BCDA Correction Request | AC-003 / TST-003 | Implemented foundation storage |
| REQ-003 | `requirements.md` | Request and Snapshot Store | BCDA Correction Request, BCDA Correction Line, BCDA Value Snapshot, BCDA Current Value Mgt. | AC-003, AC-004 / TST-003, TST-004, TST-030 | Partial foundation; selected-line current value preview implemented, full request preview pending |
| REQ-004 | `requirements.md` | Validation Runner | BCDA Validation Runner | AC-004 / TST-004 | Planned |
| REQ-005 | `requirements.md` | Policy Engine | BCDA Policy Guard, BCDA Data Policy | AC-005, AC-012 / TST-002, TST-005 | Partial foundation; execution enforcement pending |
| REQ-006 | `requirements.md` | Security and Approval | BCDA Policy Guard, approval workflow objects | AC-005, AC-007, AC-027 / TST-005, TST-007, TST-027 | Partial foundation approval fields/actions |
| REQ-007 | `requirements.md` | Record Access Layer | BCDA Correction Orchestrator | AC-006, AC-007 / TST-006, TST-007 | Blocked until mutation readiness |
| REQ-008 | `requirements.md` | Audit Writer | BCDA Audit Writer, BCDA Audit Entry | AC-008, AC-015 / TST-008 | Partial foundation audit |
| REQ-009 | `requirements.md` | Rollback Service | BCDA Rollback Service, BCDA Rollback Operation | AC-009, AC-010, AC-021, AC-023 / TST-009, TST-010, TST-017, TST-019 | Partial rollback state only |
| REQ-010 | `requirements.md` | Audit Writer | BCDA Audit Writer | AC-008, AC-009 / TST-009 | Partial foundation audit |
| REQ-011 | `requirements.md` | Audit Viewer | BCDA Audit Entries page, export report if needed | AC-011 / TST-011 | Partial audit page; export pending |
| REQ-012 | `requirements.md` | Policy Engine | BCDA Policy Guard | AC-012 / TST-002 | Partial policy shell |
| REQ-013 | `requirements.md` | Security | Existing `SUPER` access gate; no BCDA permission set objects | AC-002, AC-005 / TST-001, TST-005 | Partial runtime check; sandbox proof pending |
| REQ-014 | `requirements.md` | Redaction and Snapshot Store | BCDA Value Serializer, audit/export objects | AC-011, AC-016 / TST-011 | Partial serializer/redaction helper |
| REQ-015 | `requirements.md` | Audit Writer | BCDA Audit Entry | AC-008 / TST-008 | Implemented foundation metadata |
| REQ-016 | `requirements.md` | AI Governance and Repo Rules | `.gitignore`, review process | AC-016 / TST-011 | Planned |
| REQ-017 | `requirements.md` | Data Model and Upgrade | BCDA Audit Entry, BCDA Value Snapshot | AC-014 / TST-012 | Partial foundation tables |
| REQ-018 | `requirements.md` | Error Flow | BCDA Correction Orchestrator, BCDA Audit Writer | AC-015, AC-016 / TST-008 | Partial sanitized blocked execution |
| REQ-019 | `requirements.md` | SDD Gate | `code-generation-readiness.md` | AC-013 / TST-013 | Active |
| REQ-020 | `requirements.md` | Traceability | `traceability-matrix.md` | AC-017 / TST-013 | Active |
| REQ-021 | `requirements.md` | Symbol Discovery | `symbol-discovery.md` | AC-018 / TST-014 | Active |
| REQ-022 | `requirements.md` | Release Validation | `test-plan.md`, `deployment.md` | AC-019 / TST-015 | Planned |
| REQ-023 | `requirements.md` | User Experience | BC Data Agent profile, BCDA Role Center, BCDA Setup, BCDA Correction Requests, BCDA Correction Request Card, BCDA Correction Assistant, BCDA Rollback Wizard | AC-020 / TST-016 | Partial foundation pages and profile navigation |
| REQ-024 | `requirements.md` | Policy Engine and Setup | BCDA Setup, BCDA Data Policy, BCDA Policy Guard | AC-021, AC-022 / TST-017, TST-018 | Partial setup/policy fields |
| REQ-025 | `requirements.md` | Rollback Service and UX | BCDA Rollback Service, BCDA Rollback Wizard, BCDA Retention Status | AC-021, AC-023 / TST-017, TST-019 | Partial rollback availability storage |
| REQ-026 | `requirements.md` | Retention | BCDA Retention Manager, BCDA Retention Log | AC-024, AC-025 / TST-020, TST-021 | Partial retention registration/log storage |
| REQ-027 | `requirements.md` | Audit Writer | BCDA Audit Writer, BCDA Audit Entry | AC-008, AC-021 / TST-008, TST-017 | Partial foundation audit |
| REQ-028 | `requirements.md` | Development Standards | Code analyzers, ruleset, build validation | AC-026 / TST-022 | Implemented for foundation compile/analyzer pass |
| REQ-029 | `requirements.md` | Security and Approval | BCDA Setup, BCDA Correction Request, BCDA Correction Orchestrator | AC-027 / TST-027 | Implemented foundation configurable approval requirement and separation |
| REQ-030 | `requirements.md` | User Experience and Request Store | BCDA Batch Line Buffer, BCDA Batch Line Builder, BCDA Batch Line Mgt., BCDA Correction Line | AC-028 / TST-028 | Paused until batch RecordId selection or target matrix entry is implemented |
| REQ-031 | `requirements.md` | Metadata Explorer and User Experience | BCDA Target Record Buffer, BCDA Target Record Lookup, BCDA Correction Line; planned BCDA Target Record Matrix and BCDA Record Identity Mgt. | AC-029 / TST-029 | Partial foundation line-action lookup; richer matrix remains blocked until sandbox evidence is recorded |

# Open Decisions

| ID | Decision | Options | Current Lean | Needed By | Status |
| --- | --- | --- | --- | --- | --- |
| OD-001 | Final object ID allocation | Use 88100-88149, request a larger range, split into app modules | Use current `app.json` range 88100-88149 for Phase 1 | Before AL code | Decided |
| OD-002 | Target BC version | Target 28.0 only, support older BC, support latest only | Target Business Central 2026 release wave 1 / version 28.0 with runtime 17.0 | Before symbol download | Decided |
| OD-003 | Default posted table policy | Deny all, allow selected posted tables, allow by approval | Deny all until explicitly allow-listed | Before policy code | Open |
| OD-004 | Approval model among `SUPER` users | No approval, same `SUPER` user confirmation, second `SUPER` user approval, dual control, external workflow | Second `SUPER` user approval for high-risk changes when feasible | Before workflow code | Open |
| OD-005 | Validation mode | Always validate field triggers, allow raw assignment, per-policy mode | Per-policy mode with safe default | Before execution code | Open |
| OD-006 | Field type support | Text/numeric/date only, broad scalar support, include BLOB/media | Start with scalar fields; defer BLOB/media | Before value serializer | Open |
| OD-007 | Rollback conflict policy | Stop on conflict, allow override, auto-merge | Stop on conflict by default | Before rollback code | Open |
| OD-008 | Audit metadata retention | Permanent, configurable years, external archive | User-configurable with conservative default and optional never-delete mode | Before data model code | Open |
| OD-009 | Export format | Excel, CSV, API, report layout | Excel/CSV for `SUPER` reviewer export | Before audit export | Open |
| OD-010 | Environment safety | Same behavior everywhere, sandbox-only first, production gated | Sandbox-only until release gate passes | Before deployment | Open |
| OD-011 | Sensitive value display | Full values to `SUPER` users, channel-based redaction, never show values | `SUPER`-only UI with export/log redaction | Before UI code | Open |
| OD-013 | `SUPER` access enforcement | Runtime check, object access through `SUPER` only, both runtime and object access | Use both runtime check and object access behavior if platform supports it | Before AL code | Open |
| OD-012 | External API | No API, admin API, integration API | No API in Phase 1 | Before API code | Open |
| OD-014 | Default rollback snapshot logging | Enabled for all, enabled only for high-risk, disabled by default, policy controlled | Policy controlled; required by default for posted/high-risk data | Before setup/policy code | Open |
| OD-015 | Operation retention implementation | Business Central retention policies, custom cleanup, both | Prefer Business Central retention policies for BCDA-owned tables | Before retention code | Open |
| OD-016 | Minimum retention periods | No minimum, 30/90/365-day defaults, customer-defined minimums | Customer-defined minimums with safe warnings | Before setup code | Open |

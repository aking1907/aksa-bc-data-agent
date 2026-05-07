# Symbol Discovery

This file records Business Central platform facts that implementation may depend on.

## Verified Locally

| Fact | Evidence |
| --- | --- |
| Repository is an AL project skeleton | `app.json` exists and `.vscode/launch.json` uses AL launch type. |
| Current app target | `app.json` sets `platform` and `application` to `28.0.0.0`. |
| Current runtime target | `app.json` sets `runtime` to `17.0`, which Microsoft maps to Business Central 2026 release wave 1 / internal version 28.0. |
| Symbol packages | `.alpackages/` exists but no symbol package files were listed during initial documentation. |

## External Reference Evidence

| Fact | Source |
| --- | --- |
| Runtime `17.0` ships with Business Central 2026 release wave 1 / internal version `28.0`. | Microsoft Learn: Choose runtime version in AL. |
| Business Central `28.0` is listed as the April 2026 update for 2026 release wave 1. | Microsoft Learn: What's new and planned in Business Central. |

## Not Yet Verified

| Needed Fact | Why It Matters |
| --- | --- |
| Available BC 28 symbols | Required before referencing system tables, RecordRef behavior, or `SUPER` access behavior. |
| Record modification behavior through AL runtime | Determines what "any hidden or posted data" can technically support. |
| Field type behavior for unsupported or complex types | Required for value serialization and rollback. |
| `SUPER` access and table behavior for posted and protected tables | Required for security and policy enforcement. |
| Availability of export mechanisms | Required for audit export design. |
| Upgrade behavior for app-owned audit tables | Required for release strategy. |
| Business Central retention policy APIs for extension-owned tables | Required before implementing native operation retention. |
| Code analysis/analyzer behavior for target build pipeline | Required before marking AL implementation standards as enforceable. |

## Implementation Rule

Do not implement behavior that depends on unverified Business Central symbols or runtime behavior until this file is updated with local evidence.

## Discovery Checklist

- Download symbols for the target Business Central 28.0 environment.
- Record exact base application/system application package versions.
- Verify whether planned object names conflict with existing app objects.
- Verify record read/write behavior for representative normal, hidden, and posted tables in sandbox using `SUPER` and non-`SUPER` users.
- Verify field type read/write behavior for Text, Code, Decimal, Date, DateTime, Boolean, Option/Enum, GUID, BLOB, Media, and FlowField.
- Verify how the target BC version exposes or enforces `SUPER` access from AL.
- Verify Business Central retention policy support for BCDA-owned audit, snapshot, and technical log tables.
- Verify CodeCop/UICop and target deployment cop behavior in the local build pipeline.
- Verify which tables or fields must be permanently blocked.

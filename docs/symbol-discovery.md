# Symbol Discovery

This file records Business Central platform facts that implementation may depend on.

## Verified Locally

| Fact | Evidence |
| --- | --- |
| Repository is an AL project skeleton | `app.json` exists and `.vscode/launch.json` uses AL launch type. |
| Current app target | `app.json` sets `platform` and `application` to `28.0.0.0`. |
| Current runtime target | `app.json` sets `runtime` to `17.0`, which Microsoft maps to Business Central 2026 release wave 1 / internal version 28.0. |
| BC 28 symbol packages | `.alpackages/` contains `Microsoft_Application_28.0.46665.50128.app`, `Microsoft_Base Application_28.0.46665.50128.app`, `Microsoft_Business Foundation_28.0.46665.50128.app`, `Microsoft_System Application_28.0.46665.50128.app`, and `Microsoft_System_28.0.50078.0.app` as of 2026-05-07. |
| SUPER detection API | System Application exposes public codeunit `User Permissions` (ID 152) in namespace `System.Security.User`, including method `IsSuper(UserSecurityId: Guid): Boolean`. |
| Retention allowed-table API | System Application exposes public codeunit `Reten. Pol. Allowed Tables` (ID 3905) in namespace `System.DataAdministration`, including overloads of `AddAllowedTable`, `IsAllowedTable`, and retention metadata helpers. |
| Reflection metadata tables | System symbols include cloud-scoped virtual tables `AllObj` (2000000038), `AllObjWithCaption` (2000000058), `Field` (2000000041), and `Key` (2000000063), supporting future metadata exploration after behavior is verified. |
| Object ID conflict check | Local symbol scan found no Microsoft symbol objects in object range 88100..88149. |
| Foundation compile and analyzer baseline | Foundation AL source compiles with AL compiler 17.0.34.45391 against BC 28 symbols, and CodeCop, UICop, and PerTenantExtensionCop pass with `ruleset.json`. |

## External Reference Evidence

| Fact | Source |
| --- | --- |
| Runtime `17.0` ships with Business Central 2026 release wave 1 / internal version `28.0`. | Microsoft Learn: Choose runtime version in AL. |
| Business Central `28.0` is listed as the April 2026 update for 2026 release wave 1. | Microsoft Learn: What's new and planned in Business Central. |

## Not Yet Verified

| Needed Fact | Why It Matters |
| --- | --- |
| Record modification behavior through AL runtime | Determines what "any hidden or posted data" can technically support. |
| Field type behavior for unsupported or complex types | Required for value serialization and rollback. |
| Runtime proof of non-`SUPER` access blocking | Compile-time API evidence exists, but sandbox validation must prove non-`SUPER` users cannot use BCDA pages/actions. |
| Table behavior for posted and protected tables | Required for execution policy and mutation safety. |
| Availability of export mechanisms | Required for audit export design. |
| Upgrade behavior for app-owned audit tables | Required for release strategy. |

## Implementation Rule

Do not implement behavior that depends on unverified Business Central symbols or runtime behavior until this file is updated with local evidence.

Downloaded symbol packages prove that the target application/system symbols are available locally. They also provide enough evidence for foundation SUPER gating and BCDA-owned retention registration shells, and local analyzer execution proves the foundation analyzer baseline. They do not, by themselves, prove that posted/protected table mutation, field serialization, rollback execution, or production deployment is safe to release.

## Discovery Checklist

- Record exact base application/system application package versions. Initial package list is now captured above; inspect symbols before referencing specific APIs or objects.
- Verify whether planned object names conflict with existing app objects.
- Verify record read/write behavior for representative normal, hidden, and posted tables in sandbox using `SUPER` and non-`SUPER` users.
- Verify field type read/write behavior for Text, Code, Decimal, Date, DateTime, Boolean, Option/Enum, GUID, BLOB, Media, and FlowField.
- Verify how the target BC version exposes or enforces `SUPER` access from AL.
- Verify Business Central retention policy support for BCDA-owned audit, snapshot, and technical log tables.
- Re-run CodeCop, UICop, and target deployment cop behavior in the local build pipeline after each AL change.
- Verify which tables or fields must be permanently blocked.

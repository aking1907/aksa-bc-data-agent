# AL Development Standards

No AL code exists yet. When implementation begins, use this as the development quality bar.

## Microsoft Guidance Alignment

Use current Business Central AL tooling and guidance:

- Enable code analysis and keep CodeCop and UICop active.
- Enable PerTenantExtensionCop or AppSourceCop based on the final deployment target, not both.
- Use rulesets intentionally; do not suppress all diagnostics.
- Use the stable AL Language extension for production work unless the user explicitly chooses preview tooling.
- Use ALTool or the AL extension build command for validation once implementation starts.
- Apply robust coding practices: model likely failures, provide self-explanatory errors, and fail early when needed.
- Design data access and locking for performance; keep transactions small and lock as late as practical.
- Use Business Central retention policy APIs for app-owned log/operation tables when symbol discovery confirms support.

References:

- https://learn.microsoft.com/en-us/dynamics365/business-central/dev-itpro/developer/analyzers/codecop
- https://learn.microsoft.com/en-us/dynamics365/business-central/dev-itpro/developer/analyzers/uicop
- https://learn.microsoft.com/en-us/dynamics365/business-central/dev-itpro/developer/devenv-code-spaces-al
- https://learn.microsoft.com/en-us/dynamics365/business-central/dev-itpro/developer/devenv-rule-set-syntax-for-code-analysis-tools
- https://learn.microsoft.com/en-us/dynamics365/business-central/dev-itpro/developer/devenv-robust-coding-practices
- https://learn.microsoft.com/en-us/dynamics365/business-central/dev-itpro/performance/performance-developer
- https://learn.microsoft.com/en-gb/dynamics365/business-central/admin-data-retention-policies
- https://learn.microsoft.com/en-us/dynamics365/business-central/application/system-application/codeunit/system.dataadministration.reten.-pol.-allowed-tables

## Code Standards

- Use namespaces after symbol discovery confirms project target support.
- Keep service codeunits small and cohesive.
- Keep page triggers thin; call service codeunits.
- Use labels for user-facing messages.
- Use tooltips and captions for page controls.
- Avoid broad diagnostic suppression.
- Use `ErrorInfo` or clear errors where they improve supportability and redaction.
- Do not expose UI pages as external web service endpoints in Phase 1.
- Avoid large transactions; split execution lines when safe.
- Defer target-record locking until immediately before mutation.

## Analyzer Standard

Expected analyzer baseline:

- CodeCop: required.
- UICop: required.
- PerTenantExtensionCop: expected for per-tenant deployment.
- AppSourceCop: only if the app target changes to AppSource.

Analyzer warnings that affect security, UI clarity, data classification, permissions, or runtime behavior are release blockers unless a documented exception exists.

## Retention Policy Standard

When implementing operation retention:

- Register only BCDA-owned tables with Business Central retention policies.
- Prefer retention policy setup over a custom cleanup engine when feasible.
- Use separate policies or filters for audit metadata, rollback snapshots, and technical logs.
- Respect any minimum retention days decided by business/compliance owners.
- Record cleanup evidence in retention status or log views.

## Safety Standard

- Mandatory audit metadata cannot be bypassed.
- Rollback snapshots may be disabled only through explicit setup/policy and must be visible before execution.
- Posted/high-risk data defaults to rollback snapshots required.
- If rollback snapshots are disabled or expired, rollback actions must be unavailable.
- Retention cleanup must never delete active in-progress requests.


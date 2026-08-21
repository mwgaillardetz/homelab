# Docker Homelab

Declarative documentation and, over time, Compose definitions for the Docker
homelab running locally on Docker Desktop.

The repository is intentionally safe to publish: runtime inventory contains no
container environment values, secret files, bind-mount contents, or Docker
inspect payloads.

## Current state

- Docker host: local Docker Desktop
- 48 containers across 27 Compose projects
- 45 containers currently running
- Existing definitions: `C:\docker-projects`
- Migration status: inventory first; stacks remain managed from their original
  directories until individually sanitized and moved

See [the service inventory](docs/inventory.md) and
[architecture](docs/architecture.md).

## Repository layout

```text
apps/                   Sanitized Compose projects (added stack by stack)
docs/                   Inventory, architecture, and operating notes
scripts/                Read-only discovery and validation helpers
.github/workflows/      Automated validation and security scanning
```

## Refresh the inventory

```powershell
./scripts/Export-Inventory.ps1
```

The script reads Docker metadata only. It never exports environment variables,
secret values, container logs, or mounted file contents.

## Validate migrated stacks

```powershell
./scripts/Test-Compose.ps1
```

## Migration rule

Never copy a live Compose file directly into Git. Replace sensitive literals
with variable references, provide only an `.env.example`, and validate the
rendered model before committing.

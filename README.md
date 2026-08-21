# Docker Homelab

<div align="center">

### Homelab infrastructure as code

[![Docker](https://img.shields.io/badge/Docker-Compose-2496ED?style=flat-square&logo=docker&logoColor=white)](https://docs.docker.com/compose/)
[![Validate](https://github.com/mwgaillardetz/homelab/actions/workflows/validate.yml/badge.svg)](https://github.com/mwgaillardetz/homelab/actions/workflows/validate.yml)

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="docs/status-dark.svg?v=3">
  <img alt="Live Docker homelab status" src="docs/status.svg?v=3" width="840">
</picture>

</div>

Declarative documentation Compose definitions for my Docker
homelab running locally on Docker Desktop.

The committed Compose definitions use environment placeholders instead of
secret values. Secret files, bind-mount contents, and Docker inspect payloads
remain local.
## Current state

- Docker host: local Docker Desktop
- 48 containers across 27 Compose projects
- 45 containers currently running
- Existing definitions: `C:\docker-projects`
- Sanitized Compose definitions: 27 files across 26 public projects

See [the service inventory](docs/inventory.md) and
[architecture](docs/architecture.md).

## Repository layout

```text
apps/                   Sanitized Compose projects
docs/                   Inventory, architecture, and generated status cards
scripts/                Discovery, import, dashboard, and validation helpers
.github/workflows/      Automated validation and security scanning
```

## Refresh sanitized Compose files

```powershell
./scripts/Import-Compose.ps1
```

The importer discovers active Compose projects from Docker labels, replaces secret-shaped literal assignments with `${VARIABLE}` references, and creates safe `.env.example` files.

## Validate Compose files

```powershell
./scripts/Test-Compose.ps1
```

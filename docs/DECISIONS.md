# Architecture Decisions

Record significant design decisions here.

## 2026-02-05: Adopt Firefly III + MariaDB via Docker Compose

**Context**: Need self-hosted, double-entry bookkeeping with data sovereignty.

**Decision**: Use Firefly III core app and MariaDB with Docker Compose.

**Consequences**:
- Requires Docker host maintenance.
- Enables full control over data and backups.

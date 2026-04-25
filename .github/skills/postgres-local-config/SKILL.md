---
name: postgres-local-config
description: 'Use when working with local Postgres development configuration in scripts/postgres/pg_hba.conf, especially pg_hba auth errors, Docker Compose database access, or host-to-container connection issues.'
user-invocable: true
argument-hint: 'Describe the Postgres auth or local database access change you need.'
---

# Local Postgres Config

Use this skill when you need to inspect or update the repository's local Postgres authentication configuration.

## What It Covers
- `scripts/postgres/pg_hba.conf`
- Local Docker Compose database auth behavior
- Host-to-container development connectivity issues
- `pg_hba.conf` failures such as rejected connections from bridge or WSL addresses

## Repo Facts
- The project keeps a repo-local `pg_hba.conf` at `scripts/postgres/pg_hba.conf`.
- This config exists to stabilize local development auth instead of relying on one-time container initialization behavior.
- The Phoenix app often runs on the host or WSL while Postgres runs in Docker, so source IPs may not be container hostnames.

## Procedure
1. Read `scripts/postgres/pg_hba.conf` before proposing auth changes.
2. Confirm whether the requested change is for local development only or intended for production.
3. Keep the file focused on local dev access rules; do not generalize it into a production security model.
4. If auth rules change, verify that the related Docker setup still mounts or references this file correctly before editing other surfaces.
5. Prefer minimal rule changes that explain exactly which client paths are being allowed.
6. If documentation mentions database bootstrap or reset flow, update it only when behavior actually changes.

## Validation
- Validate syntax indirectly by checking the mounted file path and restarting the relevant container setup only when required.
- Prefer the smallest behavior check that reproduces the connection path in question.

## Notes
- `POSTGRES_HOST_AUTH_METHOD` only affects initial container initialization; it is not a reliable fix for already-initialized local volumes.
- Distinguish host-side addresses like `127.0.0.1` from container-network names and bridge IPs.

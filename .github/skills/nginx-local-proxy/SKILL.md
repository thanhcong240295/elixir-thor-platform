---
name: nginx-local-proxy
description: 'Use when working with the local Nginx reverse proxy config in scripts/nginx/nginx.conf, including api.localhost routing, proxying /v1 or /dev paths, and host.docker.internal forwarding to Phoenix.'
user-invocable: true
argument-hint: 'Describe the proxy route or local Nginx behavior you want to change.'
---

# Local Nginx Proxy

Use this skill when you need to inspect, explain, or update the repository's local Nginx reverse proxy setup.

## What It Covers
- `scripts/nginx/nginx.conf`
- Local `api.localhost` proxy behavior
- Proxying Phoenix routes such as `/v1/` and `/dev/`
- Host-to-container forwarding via `host.docker.internal`

## Repo Facts
- The local Nginx config lives at `scripts/nginx/nginx.conf`.
- It is intended for local proxying in Docker-based development, not as a production ingress template.
- Phoenix runs outside the Nginx container, so upstream resolution depends on `host.docker.internal` rather than service-to-service container DNS.

## Procedure
1. Read `scripts/nginx/nginx.conf` before editing route behavior.
2. Confirm which public host and path prefixes should be proxied.
3. Keep changes narrow: adjust server blocks, locations, and upstream targets only where needed.
4. Preserve the distinction between allowed proxied paths and everything else.
5. If proxy behavior changes, verify the matching backend route exists before editing docs or compose settings.
6. Avoid broad Nginx rewrites when a simple `location` change is sufficient.

## Validation
- Validate config with the narrowest possible Nginx syntax or runtime check when available.
- For route behavior, test only the affected proxied path instead of restarting the entire stack unnecessarily.

## Notes
- `api.localhost` routing depends on local host resolution and the Docker service exposing the configured Nginx port.
- Keep local proxy assumptions explicit; do not silently repurpose this config as a general deployment template.

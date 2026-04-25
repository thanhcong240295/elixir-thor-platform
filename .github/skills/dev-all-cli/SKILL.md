---
name: dev-all-cli
description: 'Use when working with scripts/dev-all.sh commands for local development, setup, reset-db, test, precommit, build, infra-up, infra-down, prod, release-build, or prod-release in this repo.'
user-invocable: true
argument-hint: 'Describe the dev-all.sh mode you want to run or update.'
---

# Dev All CLI

Use this skill when you need to run, explain, update, or troubleshoot the unified project runner at `scripts/dev-all.sh`.

## What It Covers
- Local development startup with `dev`
- Production-style startup with `prod` and `prod-release`
- Release building with `release-build`
- Dependency and database setup with `get`, `setup`, and `reset-db`
- Validation commands like `check`, `format`, `test`, and `precommit`
- Local infrastructure control with `infra-up` and `infra-down`
- SonarQube scanning with `sonar`

## Repo Facts
- Entry point: `scripts/dev-all.sh`
- Shared shell helpers: `scripts/dev-all/common.sh`
- Core tasks: `scripts/dev-all/tasks/core.sh`
- Runtime tasks: `scripts/dev-all/tasks/runtime.sh`
- Sonar task: `scripts/dev-all/tasks/sonar.sh`
- The script auto-loads environment variables from `.env`

## Procedure
1. Read `scripts/dev-all.sh` first to identify the supported mode and argument handling.
2. If the mode delegates to a task function, inspect the corresponding file under `scripts/dev-all/tasks/`.
3. Preserve the existing command naming pattern: root script mode dispatch plus `run_*` task functions.
4. Keep environment validation in task functions by reusing `check_env_vars` and `check_command` from `scripts/dev-all/common.sh`.
5. When adding a new mode, update both the case statement and the usage string.
6. If the command is user-facing, update README examples so the documented CLI stays in sync.
7. Validate with a shell syntax check before finishing.

## Validation
- Preferred syntax check:
  - `bash -n scripts/dev-all.sh scripts/dev-all/tasks/core.sh scripts/dev-all/tasks/runtime.sh scripts/dev-all/tasks/sonar.sh`
- For behavior checks, run the narrowest relevant mode instead of broad end-to-end startup.

## Notes
- `test` forwards additional `mix test` arguments after the mode.
- `reset-db` is destructive and should not be run automatically unless explicitly requested.
- `dev` and `prod` are long-running modes, so prefer focused validation when editing the CLI.

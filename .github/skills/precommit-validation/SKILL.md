---
name: precommit-validation
description: 'Use when running or updating precommit validation in this repo: check code format, compile with warnings as errors, verify unused dependencies, and run tests with mix precommit or bash scripts/dev-all.sh precommit.'
user-invocable: true
argument-hint: 'Describe whether you want to run, troubleshoot, or update the precommit checks.'
---

# Precommit Validation

Use this skill when you need to run, explain, troubleshoot, or update the repository's precommit validation flow.

## What It Covers
- `mix precommit` in `apps/ai_api`
- `bash scripts/dev-all.sh precommit` from the repo root
- code format validation
- compile or build-style validation with warnings as errors
- unused dependency checks
- backend test execution

## Repo Facts
- The `precommit` alias is defined in `apps/ai_api/mix.exs`.
- In this repo, `mix precommit` runs:
  - `compile --warnings-as-errors`
  - `deps.unlock --unused`
  - `format`
  - `test`
- The root script wrapper is `scripts/dev-all.sh precommit`.
- The root shell task implementation is in `scripts/dev-all/tasks/core.sh`.
- The root wrapper loads `.env`, so missing environment variables can break the test portion.

## Procedure
1. Decide whether you are validating the backend alias directly or the root wrapper command.
2. If you need the repo-standard path, use `bash scripts/dev-all.sh precommit`.
3. If you are working only inside the API app, use `mix precommit` from `apps/ai_api`.
4. When troubleshooting failures, split the flow into narrower checks in this order:
   - `mix format --check-formatted`
   - `mix compile --warnings-as-errors`
   - `mix deps.unlock --unused --check` or the alias's dependency step
   - `MIX_ENV=test mix test`
5. If the failure is test-related, confirm the required test database and Redis environment variables are present.
6. If the precommit flow changes, keep `apps/ai_api/mix.exs` and `scripts/dev-all/tasks/core.sh` aligned.

## Validation
- Preferred repo command:
  - `bash scripts/dev-all.sh precommit`
- Narrow debugging commands:
  - `bash scripts/dev-all.sh check`
  - `bash scripts/dev-all.sh test`
  - `cd apps/ai_api && mix precommit`

## Notes
- `mix precommit` is backend-focused; it does not build the frontend apps.
- In this repo, the closest build-equivalent check inside precommit is `mix compile --warnings-as-errors`.
- Use the smallest failing command first when debugging instead of rerunning the full precommit flow repeatedly.

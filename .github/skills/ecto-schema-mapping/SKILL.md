---
name: ecto-schema-mapping
description: 'Use when creating a migration file and matching Ecto repo schema mapping for apps/ai_api, including mix ecto.gen.migration, schema fields, changesets, indexes, and keeping migration and schema names aligned.'
user-invocable: true
argument-hint: 'Describe the table or domain model you want migrated and mapped.'
---

# Ecto Schema Mapping

Use this skill when you need to add or update a database table together with its Ecto schema mapping in the AI API app.

## What It Covers
- creating migration files under `apps/ai_api/priv/repo/migrations/`
- updating or creating Ecto schemas under `apps/ai_api/lib/ai_api/`
- aligning table columns with schema fields and changesets
- indexes, constraints, and timestamp conventions
- repo-specific patterns such as encrypted fields and explicit source mappings

## Repo Facts
- The primary repo is `AiApi.Repo`.
- Migrations use `utc_datetime` timestamps and standard integer ids in this repo.
- Seed and migration workflows are driven from `apps/ai_api` and wrapped by `scripts/dev-all.sh` commands like `setup` and `reset-db`.
- Some schemas use explicit `source:` mapping and custom Ecto types, so do not assume raw string columns map 1:1 to public schema field names.

## Procedure
1. Read the nearest existing schema and migration before creating a new pair.
2. Create the migration with `mix ecto.gen.migration <name>` from `apps/ai_api` when a new migration file is needed.
3. Define the table changes, indexes, nullability, and constraints in the migration first.
4. Create or update the Ecto schema so field names, `source:` mappings, and custom types match the database design.
5. Add or update changeset validation and constraints to reflect the migration rules.
6. If the model participates in seeds, update `apps/ai_api/priv/repo/seeds.exs` or the files under `apps/ai_api/priv/repo/seeds/`.
7. Run the narrowest migration or compile validation after edits.

## Validation
- Prefer `mix ecto.migrate --repo AiApi.Repo` for migration validation.
- Then run a narrow compile or targeted test for the changed schema slice.
- If inserts fail, verify the live table defaults and constraints match what the migration declares.

## Notes
- Avoid editing unrelated tables in the same migration.
- Keep migration names behavior-oriented and specific.
- When fields are encrypted or normalized at the application layer, model both the persisted columns and the public schema API explicitly.
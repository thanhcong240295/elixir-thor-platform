---
name: api-scaffold
description: 'Use when generating a new API endpoint scaffold in apps/ai_api with controller, OpenApi request/response schema validation, and a service module via scripts/gen-api.sh.'
user-invocable: true
argument-hint: 'Describe the namespace, resource, action, and HTTP method you want scaffolded.'
---

# API Scaffold

Use this skill when you need to scaffold a new API endpoint in the Phoenix app with the repository's current API shape.

## What It Covers
- `scripts/gen-api.sh`
- `AiApiWeb` API controllers using `:api_controller`
- `OpenApiSpex.ControllerSpecs` operations
- request casting via `OpenApiSpex.Plug.CastAndValidate`
- response validation via the existing OpenAPI response validation plug
- paired domain service modules under `apps/ai_api/lib/ai_api/`

## Repo Facts
- API controllers should use `use AiApiWeb, :api_controller` so request validation runs automatically.
- Response envelopes are expected to follow the repo pattern with `success`, `message`, `timestamp`, and `data`.
- Shared response schemas live behind `AiApiWeb.ApiSchemas.success_response_schema/1`.
- Route wiring and `api_spec.ex` updates are still explicit follow-up steps after generation.

## Procedure
1. Decide the namespace path shared by web and domain modules, for example `gateway/admin`.
2. Choose a snake_case resource name, action name, and HTTP method.
3. Run `bash scripts/gen-api.sh <namespace-path> <resource-name> <action> <http-method>`.
4. Review the generated controller, schema module, and service module before wiring routes.
5. Add the matching route in `apps/ai_api/lib/ai_api_web/router.ex`.
6. Update `apps/ai_api/lib/ai_api_web/api_spec.ex` if the route needs explicit OpenAPI path registration.
7. Replace placeholder schema properties and service logic with real domain behavior.

## Validation
- First validate the generator itself with `bash -n scripts/gen-api.sh` after edits.
- After generating files, prefer a narrow compile or targeted test for the touched slice.
- If the endpoint accepts a body, verify the generated `request_body` contract matches the actual payload shape you implement.

## Notes
- The generator refuses to overwrite existing files.
- It scaffolds files only; it does not mutate router or spec files automatically.
- Generated schema modules include both `request_schema/0` and `data_schema/0` so request and response validation can be filled in incrementally.
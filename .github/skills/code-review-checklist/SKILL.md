---
name: code-review-checklist
description: 'Use when reviewing code in this repo for code convention, unused code, comments, bugs, regressions, risk issues, and possible secret exposure before commit or merge.'
user-invocable: true
argument-hint: 'Describe the changed files or area you want reviewed.'
---

# Code Review Checklist

Use this skill when you need a review-style pass over changes in this repository.

## What It Covers
- code convention drift
- unused code or stale scaffolding
- low-value or misleading comments
- likely bugs or behavioral regressions
- operational or security risks
- accidental secret exposure

## Repo Facts
- Deterministic pre-commit checks live in `.githooks/pre-commit` and `scripts/review-staged.sh`.
- The repo already runs `bash scripts/dev-all.sh precommit` for compile, dependency, format, and test validation.
- Not all review concerns can be enforced by shell hooks; architectural risk and bug review still need human or agent judgment.

## Review Procedure
1. Start with a code review mindset, not a changelog mindset.
2. Look for behavior regressions first, then security and operational risks, then maintainability issues.
3. Check whether new code follows existing repo patterns for Phoenix controllers, OpenAPI schemas, Ecto schemas, scripts, and frontend app structure.
4. Flag stale generated boilerplate, dead files, unused modules, placeholder text, and comments that add no value.
5. Check for secrets or credentials in tracked files, especially `.env`-style content, tokens, passwords, key material, and copied local config.
6. Prefer findings with concrete file references and why the issue matters.

## Deterministic Complements
- `bash scripts/review-staged.sh`
- `bash scripts/dev-all.sh precommit`

## Notes
- Treat `.env`, private keys, and crash dumps as commit blockers.
- Treat TODO/FIXME markers and generated boilerplate as review warnings unless the task explicitly intends them.
- For frontend work, check whether generated defaults were left in place instead of being adapted to the actual product.
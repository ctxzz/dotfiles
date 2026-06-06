---
name: review
description: Review staged changes for quality, security, and best practices. Use when the user asks for a code review of their staged or pending changes.
---

# Code Review

## Context
- Staged diff: !`git diff --staged --stat`

## Task
1. Inspect `git diff --staged` for changes.
2. Identify issues: security vulnerabilities, code-quality problems, best-practice violations, syntax errors.
3. Run relevant linters if available.
4. Provide actionable feedback.

## Output
- Issues grouped by severity (critical / warning / suggestion).
- Specific file + line references with explanations.
- Suggested fixes.
- Overall recommendation.

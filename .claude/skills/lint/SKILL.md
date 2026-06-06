---
name: lint
description: Run the appropriate linters for the files in the repository and report issues. Use when the user wants to lint code or check style.
argument-hint: "[file-or-glob?]"
---

# Lint Code

Run appropriate linters on files based on their type.

## Task
1. Detect file types in scope ($ARGUMENTS if provided, otherwise git-modified files, otherwise all relevant files).
2. Run relevant linters:
   - Shell: `shellcheck`
   - Python: `ruff` / `flake8` / `mypy`
   - JS/TS: `eslint`
   - YAML: `yamllint`
   - Markdown: `markdownlint`
3. Report issues with line numbers.
4. Suggest fixes where possible.

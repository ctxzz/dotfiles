# Lint Code

Run appropriate linters on files based on their type.

## Task

1. Detect file types in the repository
2. Run relevant linters:
   - Shell scripts: `shellcheck`
   - Python: `pylint`, `flake8`, `mypy`
   - JavaScript/TypeScript: `eslint`
   - YAML: `yamllint`
   - Markdown: `markdownlint`
3. Report issues with line numbers
4. Suggest fixes where possible

## Usage

- On all files: Run linters on all relevant files
- On changed files: Focus on git modified files
- On specific files: Lint files matching a pattern

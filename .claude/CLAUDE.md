# Global CLAUDE.md

## Language / Communication
- Use English for all user-agent communication by default.
- Respond in other languages only if explicitly requested by the user.

## Coding Style & Conventions
- Always format code using 2-space indent.
- Stick to project's own lint / formatting commands (e.g. run `black .`, `eslint --fix`) when applicable.
- When suggesting changes: include diff-like output, clearly annotated.

## Development Philosophy
- Prefer Test-Driven Development (TDD): tests first, then implementation.
- Suggest writing and running tests before implementation when starting new feature.
- Encourage small, incremental commits with clear commit messages.

## Common Commands / Workflows
- Build: `npm run build` (or project-specific build command — override per project).
- Run tests: `pytest tests/` (or project-specific command).
- Run formatting: `black .` / `eslint --fix` etc.
- When offering a PR: include test results + lint/format check.

## Communication Guidelines with Claude
- Ask clarifying questions if specification is ambiguous, before implementing.
- Confirm with user before performing operations that may alter many files (e.g. mass refactor, delete).
- If you propose modifications: wrap them in code-blocks, provide short rationale.

## Notes
- Do not include any sensitive information (credentials, API keys, secrets).
- Keep instructions concise — avoid long narrative descriptions; use bullet lists.

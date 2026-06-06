---
name: write-a-skill
description: Scaffold a new Claude Code skill (SKILL.md) with correct frontmatter and a concise body. Use when the user wants to create or formalize a repeated workflow as a skill.
argument-hint: "[skill-name]"
---

# Write a skill

Create `.claude/skills/<name>/SKILL.md` for the requested workflow ($ARGUMENTS).

## Frontmatter rules
- `name`: lowercase-with-hyphens, matches the directory.
- `description`: REQUIRED quality. State *what it does and when to use it*, key use case first — this is how Claude decides to auto-load it. Keep under ~1,536 chars.
- `argument-hint`: add when the skill takes input (e.g. `[file]`).
- `disable-model-invocation: true`: add for destructive or intentional-only actions (deploy, delete, commit) so Claude does not trigger them automatically.

## Body rules
- Keep it concise — once loaded, the body stays in context every turn.
- State *what to do*, not narration. Use short steps and a Guidelines section.
- Use `!`shell`` for dynamic context and `$ARGUMENTS` / `$1` for inputs when helpful.

## Process
1. Confirm the skill's purpose, trigger, and whether it should be manual-only.
2. Check for overlap: if a built-in agent or bundled skill (`/code-review`, `/security-review`, etc.) already covers it, recommend that instead of a duplicate.
3. Write the SKILL.md following the rules above.
4. Verify the frontmatter parses and the skill appears in the skill list.

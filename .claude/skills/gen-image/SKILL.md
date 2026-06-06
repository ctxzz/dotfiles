---
name: gen-image
description: Generate or edit an image from a text prompt using the Gemini API or OpenRouter (Nano Banana / gemini-2.5-flash-image, FLUX, etc.). Use when the user wants to create, generate, or modify an image.
argument-hint: "[prompt]"
disable-model-invocation: true
---

# Generate an image

Uses the bundled `gen_image.py` (no dependencies; Python 3 + stdlib).

## Setup (one-time)
- Keys live in 1Password; the repo only holds `op://` references. Copy the
  template and edit the references: `cp .claude/ai.env.example .claude/ai.env`
  (`.claude/ai.env` is gitignored). See that file for how to find references.
- Sign in once per session: `op signin` (or use the 1Password desktop app CLI
  integration for biometric unlock).
- If sandbox is on, `generativelanguage.googleapis.com` / `openrouter.ai` must be in `settings.json` → `sandbox.network.allowedDomains` (already added).

## Run
Prefix the command with `op run` so the key is injected only at runtime (never
written to disk). The script itself just reads `GEMINI_API_KEY` /
`OPENROUTER_API_KEY` from the env, so plain `python3 ...` also works if those are
already exported by other means.

```bash
# generate (auto-picks backend from whichever key is set)
op run --env-file=.claude/ai.env -- \
  python3 .claude/skills/gen-image/gen_image.py "$ARGUMENTS" -o /tmp/out.png

# edit an existing image
op run --env-file=.claude/ai.env -- \
  python3 .claude/skills/gen-image/gen_image.py "make the sky purple" -i input.png -o /tmp/out.png

# force backend / model
op run --env-file=.claude/ai.env -- \
  python3 .claude/skills/gen-image/gen_image.py "..." --backend openrouter -m black-forest-labs/flux.2-pro
```

## Task
1. Confirm the prompt; ask for output path and whether it edits an existing image if unclear.
2. Choose the backend: explicit `--backend`, else `$GEN_IMAGE_BACKEND`, else the key that is set (Gemini preferred).
3. Run the script; it prints the saved path.
4. Surface the result to the user with the SendUserFile tool so they can see it.

## Notes
- Defaults: Gemini `gemini-2.5-flash-image`, OpenRouter `google/gemini-2.5-flash-image`. Override with `-m` or `GEMINI_IMAGE_MODEL` / `OPENROUTER_IMAGE_MODEL`.
- These are paid API calls — only run when the user asks (skill is manual-only).
- For the latest image models, check the provider docs; model names are env-overridable so this skill does not go stale.

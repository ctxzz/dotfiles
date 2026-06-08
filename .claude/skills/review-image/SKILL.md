---
name: review-image
description: Describe, analyze, or critique an image (screenshot, design, photo, diagram) and iterate on it conversationally. Uses your own vision by default, or routes to an LLM via Gemini API / OpenRouter on request. Use when the user shares an image to review or ask about.
argument-hint: "[image-path] [question?]"
---

# Review an image

## Path A — your own vision (default, free, no API)
1. Load the image with the Read tool (it renders images visually).
2. Answer the user's goal: describe it, critique a UI/design, extract text, compare against intent, or suggest changes.
3. Iterate: keep the image in context and refine across follow-up turns.

Prefer this path unless the user wants a specific external model or a second opinion.

## Path B — external LLM (Gemini / OpenRouter)
Use the bundled `describe_image.py` when the user wants Gemini/OpenRouter to do the analysis.

```bash
op run --env-file=$HOME/.claude/ai.env -- \
  python3 $HOME/.claude/skills/review-image/describe_image.py image.png \
  -p "Critique this UI's accessibility and visual hierarchy"

# force backend / model
op run --env-file=$HOME/.claude/ai.env -- \
  python3 $HOME/.claude/skills/review-image/describe_image.py image.png \
  --backend openrouter -m anthropic/claude-sonnet-4.5
```

- Auth: keys come from 1Password via `op run --env-file=$HOME/.claude/ai.env` (the
  committed `.claude/ai.env` holds only `op://` references — edit it to match
  your vault/item/field); the script just reads `GEMINI_API_KEY` /
  `OPENROUTER_API_KEY` from the env, so plain `python3 ...` also works if they
  are already exported. Backend: `--backend`, else `$IMAGE_LLM_BACKEND`, else whichever key is set.
- Defaults: Gemini `gemini-2.5-flash`, OpenRouter `google/gemini-2.5-flash` (override with `-m` or `GEMINI_VISION_MODEL` / `OPENROUTER_VISION_MODEL`).
- Sandbox: requires `generativelanguage.googleapis.com` / `openrouter.ai` in `allowedDomains` (already added).

## Task
1. Identify the image path ($ARGUMENTS) and what the user wants done with it.
2. Pick Path A (default) or Path B (external model requested).
3. Deliver the analysis, then continue the conversation — refine, compare, or feed the result into the next step (e.g. hand off to `/gen-image`).

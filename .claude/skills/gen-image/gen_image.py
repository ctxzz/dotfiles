#!/usr/bin/env python3
"""Generate or edit an image via the Gemini API or OpenRouter.

Usage:
  gen_image.py "a red bicycle on a beach" -o out.png
  gen_image.py "make the sky purple" -i in.png -o out.png      # edit
  gen_image.py "..." --backend openrouter -m black-forest-labs/flux.2-pro

Auth (env): GEMINI_API_KEY (gemini) or OPENROUTER_API_KEY (openrouter).
Backend: --backend, else $GEN_IMAGE_BACKEND, else whichever key is set.
Models:  -m, else $GEMINI_IMAGE_MODEL / $OPENROUTER_IMAGE_MODEL, else sane defaults.
Prints the saved file path on success.
"""
import argparse
import base64
import json
import mimetypes
import os
import sys
import urllib.error
import urllib.request


def _post(url, headers, body):
  req = urllib.request.Request(
    url, data=json.dumps(body).encode(),
    headers={"Content-Type": "application/json", **headers})
  try:
    with urllib.request.urlopen(req) as r:
      return json.loads(r.read())
  except urllib.error.HTTPError as e:
    sys.exit(f"HTTP {e.code}: {e.read().decode()[:2000]}")
  except urllib.error.URLError as e:
    sys.exit(f"network error: {e.reason}")


def _read_b64(path):
  with open(path, "rb") as f:
    return base64.b64encode(f.read()).decode(), (mimetypes.guess_type(path)[0] or "image/png")


def _need(var):
  v = os.environ.get(var)
  if not v:
    sys.exit(f"error: set {var}")
  return v


def _save(out, b64):
  with open(out, "wb") as f:
    f.write(base64.b64decode(b64))


def gen_gemini(prompt, inputs, model, out):
  model = model or os.environ.get("GEMINI_IMAGE_MODEL", "gemini-2.5-flash-image")
  parts = [{"text": prompt}]
  for p in inputs:
    data, mime = _read_b64(p)
    parts.append({"inline_data": {"mime_type": mime, "data": data}})
  payload = _post(
    f"https://generativelanguage.googleapis.com/v1beta/models/{model}:generateContent",
    {"x-goog-api-key": _need("GEMINI_API_KEY")},
    {"contents": [{"parts": parts}],
     "generationConfig": {"responseModalities": ["IMAGE"]}})
  for cand in payload.get("candidates", []):
    for part in cand.get("content", {}).get("parts", []):
      inline = part.get("inlineData") or part.get("inline_data")
      if inline and inline.get("data"):
        _save(out, inline["data"])
        return out
  sys.exit("no image in response:\n" + json.dumps(payload)[:2000])


def gen_openrouter(prompt, inputs, model, out):
  model = model or os.environ.get("OPENROUTER_IMAGE_MODEL", "google/gemini-2.5-flash-image")
  content = [{"type": "text", "text": prompt}]
  for p in inputs:
    data, mime = _read_b64(p)
    content.append({"type": "image_url", "image_url": {"url": f"data:{mime};base64,{data}"}})
  payload = _post(
    "https://openrouter.ai/api/v1/chat/completions",
    {"Authorization": f"Bearer {_need('OPENROUTER_API_KEY')}"},
    {"model": model, "modalities": ["image", "text"],
     "messages": [{"role": "user", "content": content}]})
  for choice in payload.get("choices", []):
    for img in choice.get("message", {}).get("images", []) or []:
      url = (img.get("image_url") or {}).get("url", "")
      if url.startswith("data:"):
        _save(out, url.split(",", 1)[1])
        return out
  sys.exit("no image in response:\n" + json.dumps(payload)[:2000])


def main():
  ap = argparse.ArgumentParser(description="Generate or edit an image (Gemini / OpenRouter).")
  ap.add_argument("prompt")
  ap.add_argument("-o", "--out", default="generated.png")
  ap.add_argument("-i", "--input", action="append", default=[],
                  help="input image to edit (repeatable)")
  ap.add_argument("--backend", choices=["gemini", "openrouter"])
  ap.add_argument("-m", "--model")
  a = ap.parse_args()

  backend = a.backend or os.environ.get("GEN_IMAGE_BACKEND") or (
    "gemini" if os.environ.get("GEMINI_API_KEY")
    else "openrouter" if os.environ.get("OPENROUTER_API_KEY")
    else None)
  if not backend:
    sys.exit("error: set GEMINI_API_KEY or OPENROUTER_API_KEY (or pass --backend)")

  fn = gen_gemini if backend == "gemini" else gen_openrouter
  print(fn(a.prompt, a.input, a.model, a.out))


if __name__ == "__main__":
  main()

#!/usr/bin/env python3
"""Describe / analyze an image with an LLM via the Gemini API or OpenRouter.

Usage:
  describe_image.py shot.png
  describe_image.py ui.png -p "Critique this UI's accessibility and layout"
  describe_image.py x.png --backend openrouter -m anthropic/claude-sonnet-4.5

Auth (env): GEMINI_API_KEY (gemini) or OPENROUTER_API_KEY (openrouter).
Backend: --backend, else $IMAGE_LLM_BACKEND, else whichever key is set.
Prints the model's text answer to stdout.
"""
import argparse
import base64
import json
import mimetypes
import os
import sys
import urllib.error
import urllib.request

DEFAULT_PROMPT = ("Describe this image in detail: key elements, any text, "
                  "layout, style, and anything notable or unusual.")


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


def gemini(path, prompt, model):
  model = model or os.environ.get("GEMINI_VISION_MODEL", "gemini-2.5-flash")
  data, mime = _read_b64(path)
  payload = _post(
    f"https://generativelanguage.googleapis.com/v1beta/models/{model}:generateContent",
    {"x-goog-api-key": _need("GEMINI_API_KEY")},
    {"contents": [{"parts": [
      {"text": prompt},
      {"inline_data": {"mime_type": mime, "data": data}}]}]})
  out = [part["text"]
         for cand in payload.get("candidates", [])
         for part in cand.get("content", {}).get("parts", [])
         if part.get("text")]
  return "\n".join(out) or json.dumps(payload)[:2000]


def openrouter(path, prompt, model):
  model = model or os.environ.get("OPENROUTER_VISION_MODEL", "google/gemini-2.5-flash")
  data, mime = _read_b64(path)
  payload = _post(
    "https://openrouter.ai/api/v1/chat/completions",
    {"Authorization": f"Bearer {_need('OPENROUTER_API_KEY')}"},
    {"model": model, "messages": [{"role": "user", "content": [
      {"type": "text", "text": prompt},
      {"type": "image_url", "image_url": {"url": f"data:{mime};base64,{data}"}}]}]})
  msg = payload.get("choices", [{}])[0].get("message", {})
  return msg.get("content") or json.dumps(payload)[:2000]


def main():
  ap = argparse.ArgumentParser(description="Describe an image with an LLM (Gemini / OpenRouter).")
  ap.add_argument("image")
  ap.add_argument("-p", "--prompt", default=DEFAULT_PROMPT)
  ap.add_argument("--backend", choices=["gemini", "openrouter"])
  ap.add_argument("-m", "--model")
  a = ap.parse_args()

  backend = a.backend or os.environ.get("IMAGE_LLM_BACKEND") or (
    "gemini" if os.environ.get("GEMINI_API_KEY")
    else "openrouter" if os.environ.get("OPENROUTER_API_KEY")
    else None)
  if not backend:
    sys.exit("error: set GEMINI_API_KEY or OPENROUTER_API_KEY (or pass --backend)")

  fn = gemini if backend == "gemini" else openrouter
  print(fn(a.image, a.prompt, a.model))


if __name__ == "__main__":
  main()

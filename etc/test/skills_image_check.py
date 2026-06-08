#!/usr/bin/env python3
"""Network-free smoke tests for the image skills.

Loads gen_image.py / describe_image.py by path (their dirs contain a hyphen so
they are not importable as packages), stubs out the HTTP layer (`_post`), and
checks response parsing, the missing-key guard, and backend auto-selection.
Exits non-zero if any check fails.
"""
import base64
import importlib.util
import io
import os
import sys
import tempfile

ROOT = os.environ["DOTPATH"]
PNG = base64.b64encode(b"\x89PNG\r\n\x1a\nFAKE").decode()
fails = []


def load(path, name):
  spec = importlib.util.spec_from_file_location(name, path)
  mod = importlib.util.module_from_spec(spec)
  spec.loader.exec_module(mod)
  return mod


def check(name, cond):
  print(("ok   " if cond else "FAIL ") + name)
  if not cond:
    fails.append(name)


def clear_keys():
  for k in ("GEMINI_API_KEY", "OPENROUTER_API_KEY",
            "GEN_IMAGE_BACKEND", "IMAGE_LLM_BACKEND"):
    os.environ.pop(k, None)


gi = load(f"{ROOT}/.claude/skills/gen-image/gen_image.py", "gen_image")
di = load(f"{ROOT}/.claude/skills/review-image/describe_image.py", "describe_image")

# --- gen_image: response parsing saves decoded bytes ---
clear_keys()
os.environ["GEMINI_API_KEY"] = "x"
gi._post = lambda *a, **k: {
  "candidates": [{"content": {"parts": [{"inlineData": {"data": PNG}}]}}]}
with tempfile.TemporaryDirectory() as d:
  out = f"{d}/o.png"
  gi.gen_gemini("prompt", [], None, out)
  with open(out, "rb") as f:
    check("gen_image.gemini saves decoded image", f.read() == base64.b64decode(PNG))

gi._post = lambda *a, **k: {
  "choices": [{"message": {"images": [
    {"image_url": {"url": "data:image/png;base64," + PNG}}]}}]}
os.environ["OPENROUTER_API_KEY"] = "x"
with tempfile.TemporaryDirectory() as d:
  out = f"{d}/o.png"
  gi.gen_openrouter("prompt", [], None, out)
  check("gen_image.openrouter saves image", os.path.exists(out))

# --- missing-key guard ---
clear_keys()
try:
  gi._need("GEMINI_API_KEY")
  check("gen_image._need exits on missing key", False)
except SystemExit:
  check("gen_image._need exits on missing key", True)

# --- backend auto-selection (no network: stub gen_* to sentinels) ---
clear_keys()
os.environ["OPENROUTER_API_KEY"] = "x"
gi.gen_gemini = lambda *a: "GEMINI"
gi.gen_openrouter = lambda *a: "OPENROUTER"
sys.argv = ["gen_image.py", "prompt", "-o", "/tmp/x.png"]
buf, old = io.StringIO(), sys.stdout
sys.stdout = buf
gi.main()
sys.stdout = old
check("gen_image picks openrouter when only OR key set",
      buf.getvalue().strip() == "OPENROUTER")

clear_keys()
sys.argv = ["gen_image.py", "prompt"]
try:
  gi.main()
  check("gen_image exits when no key/backend", False)
except SystemExit:
  check("gen_image exits when no key/backend", True)

# --- describe_image: text extraction for both backends ---
with tempfile.TemporaryDirectory() as d:
  img = f"{d}/in.png"
  with open(img, "wb") as f:
    f.write(b"\x89PNGdata")
  clear_keys()
  os.environ["GEMINI_API_KEY"] = "x"
  di._post = lambda *a, **k: {
    "candidates": [{"content": {"parts": [{"text": "hello"}]}}]}
  check("describe_image.gemini returns text", di.gemini(img, "p", None) == "hello")

  os.environ["OPENROUTER_API_KEY"] = "x"
  di._post = lambda *a, **k: {"choices": [{"message": {"content": "world"}}]}
  check("describe_image.openrouter returns text",
        di.openrouter(img, "p", None) == "world")

if fails:
  print(f"\n{len(fails)} check(s) failed: {', '.join(fails)}")
  sys.exit(1)
print("\nall image-skill checks passed")

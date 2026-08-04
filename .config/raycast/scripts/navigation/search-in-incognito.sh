#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Search in Incognito
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🕵️
# @raycast.argument1 { "type": "text", "placeholder": "検索ワード or URL" }
# @raycast.packageName Navigation

# Documentation:
# @raycast.description 検索ワードまたはURLをChromeのシークレットモードで開く
# @raycast.author ctxzz
# @raycast.authorURL https://raycast.com/ctxzz

query=$1

if [ -z "$query" ]; then
  echo "❌ Empty query is not allowed"
  exit 1
fi

case "$query" in
  http://* | https://*)
    url=$query
    ;;
  *)
    # 日本語などのマルチバイト文字も正しくエンコードするためJXAを使用
    encoded=$(osascript -l JavaScript -e 'function run(argv) { return encodeURIComponent(argv[0]) }' "$query")
    url="https://www.google.com/search?q=$encoded"
    ;;
esac

open -na "Google Chrome" --args --incognito "$url"

echo "🕵️ Opened in incognito: $query"

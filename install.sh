#!/bin/bash

for f in .??*
do
    [[ "$f" == ".git" ]] && continue
    [[ "$f" == ".DS_Store" ]] && continue

    ln -sfnv $(cd "$(dirname "$f")" && pwd)/$(basename "$f") $HOME/"$f";
done

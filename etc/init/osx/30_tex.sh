#!/bin/bash

# Stop script if errors occur
trap 'echo Error: $0:$LINENO stopped; exit 1' ERR INT
set -eu

# Load vital library that is most important and
# constructed with many minimal functions
# For more information, see etc/README.md
. "$DOTPATH"/etc/lib/vital.sh

# This script is only supported with OS X
if ! is_osx; then
    log_fail "error: this script is only supported with osx"
    exit 1
fi

if ! has "tlmgr"; then
    log_fail "error: require: add path to tlmgr"
	echo "hint: sudo /usr/local/texlive/2018/bin/x86_64-darwin/tlmgr path add"
    exit 1
fi

sudo tlmgr update --self --all
sudo tlmgr install uplatex latexmk collection-langjapanese

log_pass "tex: installed successfully"

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
	echo "hint: sudo /usr/local/texlive/2021basic/bin/universal-darwin/tlmgr path add"
    exit 1
fi

if ! has "perl"; then
    log_fail "error: require: perl"
    exit 1
fi

sudo tlmgr update --self --all

if ! has "latexmk"; then
    sudo tlmgr repository add http://contrib.texlive.info/current tlcontrib # comment out if error
    sudo tlmgr pinning add tlcontrib '*'  # comment out if error
    sudo tlmgr install uplatex latexmk japanese-otf-nonfree japanese-otf-uptex-nonfree ptex-fontmaps-macos cjk-gs-integrate-macos
    sudo tlmgr install cjk-gs-integrate adobemapping
    sudo tlmgr path add
    sudo cjk-gs-integrate --link-texmf --cleanup
    sudo cjk-gs-integrate-macos --link-texmf
    sudo perl ~/.dotfiles/etc/init/osx/tmp_tex_patch.pl --link-texmf
    sudo mktexlsr
    sudo kanji-config-updmap-sys --jis2004 hiragino-highsierra-pron
fi

#if [[ -d /usr/local/texlive/2018/texmf-dist/scripts/cjk-gs-integrate ]]; then
#    cd /usr/local/texlive/2018/texmf-dist/scripts/cjk-gs-integrate
#    sudo perl cjk-gs-integrate.pl --link-texmf --force
#    sudo mktexlsr
#    sudo kanji-config-updmap-sys hiragino-highsierra-pron
#fi

log_pass "tex: installed successfully"

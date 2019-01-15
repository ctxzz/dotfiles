#!/bin/bash

# -- START sh test
#
trap 'echo Error: $0: stopped; exit 1' ERR INT

. "$DOTPATH"/etc/lib/vital.sh

ERR=0
export ERR
#
# -- END

unit1() {
    curl -fsSL dot.omata.me >/dev/null 2>&1
    if [ $? -ne 0 ]; then
        e_failure "$0: $LINENO: $FUNCNAME"
    fi

    diff -qs \
        <(wget -qO - dot.omata.me) \
        <(wget -qO - raw.githubusercontent.com/ctxzz/dotfiles/master/etc/install) | \
        grep -q "identical"
    
    if [ $? -eq 0 ]; then
        e_done "redirecting dot.omata.me to github.com"
    else
        e_failure "$0: $LINENO: $FUNCNAME"
    fi
}

unit1

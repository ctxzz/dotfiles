umask 022
limit coredumpsize 0
bindkey -d

# Return if zsh is called from Vim
if [[ -n $VIMRUNTIME ]]; then
    return 0
fi

# tmux_automatically_attach attachs tmux session
# automatically when your are in zsh
echo "weiweiwei"
if [[ -x ~/bin/tmuxx ]]; then
    echo "gogogog ogo"
    ~/bin/tmuxx
fi

if [[ ! -d ~/.zplug ]]; then
	git clone https://github.com/zplug/zplug ~/.zplug
    source ~/.zplug/zplug
    zplug update --self
fi

if [[ -f ~/.zplug/init.zsh ]]; then
    export ZPLUG_LOADFILE=~/.zsh/zplug.zsh
    source ~/.zplug/init.zsh

    if ! zplug check --verbose; then
        printf "Install? [y/N]: "
        if read -q; then
            echo; zplug install
        fi
        echo
    fi
    zplug load
fi

if [[ -f ~/.zshrc.local ]]; then
    source ~/.zshrc.local
fi


if [[ -d ~/.zsh ]]; then
    for f in ~/.zsh/[0-9]*.(sh|zsh)
    do
        # not excute files
        if [[ ! -x $f ]]; then
            source "$f" && echo "loading $f"
        fi
    done

	printf "\n"
	printf "$fg_bold[cyan] This is ZSH $fg_bold[red]$ZSH_VERSION"
	printf "$fg_bold[cyan] - DISPLAY on $fg_bold[red]$DISPLAY$reset_color\n\n"
fi

#local f
#local -a lpath
#[[ -d ~/.zsh ]]     && lpath=(~/.zsh/[0-9]*.(sh|zsh)   $lpath)
#
#for f in $lpath[@]
#do
#	# not execute files
#   if [[ ! -x $f ]]; then
#      	source "$f" && echo "loading $f"
#    fi
#done

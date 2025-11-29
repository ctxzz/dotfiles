# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# Skip if running from Vim
[ -n "$VIMRUNTIME" ] && return

# Basic settings
export EDITOR=vim
export LANG=en_US.UTF-8
export PAGER=less
export LESS='-i -N -w -z-4 -g -e -M -X -F -R -P%t?f%f :stdin .?pb%pb\%:?lbLine %lb:?bbByte %bb:-...'
export LESSCHARSET='utf-8'

# History settings
export HISTCONTROL=ignoreboth:erasedups
export HISTTIMEFORMAT="%Y/%m/%d %H:%M:%S:   "
export HISTSIZE=50000
export HISTFILESIZE=50000

# Basic aliases
alias ls='ls -G'
alias ll='ls -l'
alias la='ls -A'
alias lla='ls -lA'
alias l='ls -CF'
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias mkdir='mkdir -p'
alias df='df -h'
alias du='du -h'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias diff='diff -u'
alias vi='vim'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ~='cd ~'
alias -- -='cd -'

# Git aliases
alias g='git'
alias gst='git status'
alias gd='git diff'
alias gc='git commit'
alias gco='git checkout'
alias gp='git push'
alias gpl='git pull'
alias gl='git log'
alias glo='git log --oneline'
alias glg='git log --graph'

# Quick directory navigation
alias c='clear'
alias h='history'
alias j='jobs -l'
alias path='echo -e ${PATH//:/\\n}'
alias now='date +"%T"'
alias nowtime=now
alias nowdate='date +"%d-%m-%Y"'

# System aliases
alias sudo='sudo '
alias su='su -'
alias reboot='sudo reboot'
alias shutdown='sudo shutdown -h now'
alias poweroff='sudo poweroff'

# Network aliases
alias ip='ip -color'
alias ipconfig='ifconfig'
alias netstat='netstat -tulanp'
alias ports='netstat -tulanp'
alias listen='lsof -i'

# Development aliases
alias py='python'
alias py3='python3'
alias pip='pip3'
alias venv='python3 -m venv'
alias activate='source venv/bin/activate'

# Docker aliases
alias d='docker'
alias dc='docker-compose'
alias dps='docker ps'
alias di='docker images'
alias dex='docker exec -it'

# Kubernetes aliases
alias k='kubectl'
alias kg='kubectl get'
alias kd='kubectl describe'
alias kl='kubectl logs'
alias ka='kubectl apply -f'
alias kx='kubectl exec -it'

# Exit aliases
alias q='exit'
alias :q='exit'
alias bye='exit'
alias quit='exit'
alias x='exit'

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# miseの初期化（推奨: nvm, bun, nodebrewなどを統一管理）
if command -v mise >/dev/null 2>&1; then
    eval "$(mise activate bash)"
fi

# Bun（miseで管理する場合は不要になります）
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
[ -s "$BUN_INSTALL/_bun" ] && source "$BUN_INSTALL/_bun"

# NVM（miseで管理する場合は不要になります）
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

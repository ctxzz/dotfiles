# System-wide .bashrc file for interactive bash(1) shells.
if [ -z "$PS1" ]; then
   return
fi

PS1='\h:\W \u\$ '
# Make bash check its window size after a process completes
shopt -s checkwinsize

[ -r "/etc/bashrc_$TERM_PROGRAM" ] && . "/etc/bashrc_$TERM_PROGRAM"

alias atomemo="atom ~/Dropbox/200Document/Markdown"
alias arec="osascript ~/Dropbox/999Other/config/QTRecord.scpt"

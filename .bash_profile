if [ -f ~/.bashrc ]; then
	source ~/.bashrc
fi
export PATH="/usr/local/bin:$HOME/bin:$PATH"
# added by Anaconda3 2019.10 installer
# >>> conda init >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$(CONDA_REPORT_ERRORS=false '~/opt/anaconda3/bin/conda' shell.bash hook 2> /dev/null)"
if [ $? -eq 0 ]; then
    \eval "$__conda_setup"
else
    if [ -f "~/opt/anaconda3/etc/profile.d/conda.sh" ]; then
# . "~/opt/anaconda3/etc/profile.d/conda.sh"  # commented out by conda initialize
        CONDA_CHANGEPS1=false conda activate base
    else
        \export PATH="~/opt/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda init <<<

export WMSJAVA_HOME="/Library/WowzaStreamingEngine-4.7.8/java"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('~/opt/anaconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "~/opt/anaconda3/etc/profile.d/conda.sh" ]; then
        . "~/opt/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="~/opt/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<


DISABLE_AUTO_UPDATE="true"
DISABLE_MAGIC_FUNCTIONS="true"
DISABLE_COMPFIX="true"

ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE="20"
ZSH_AUTOSUGGEST_USE_ASYNC=1

export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"

autoload -Uz compinit
if [ "$(date +'%j')" != "$(stat -f '%Sm' -t '%j' ~/.zcompdump 2>/dev/null)" ]; then
    compinit
else
    compinit -C
fi

plugins=(
    git
    zsh-autosuggestions
    nvm
    zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/keyring/ssh"

export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/miniconda3/bin:$PATH"


# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/simon/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/simon/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/simon/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/simon/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<
#


alias vim=nvim
alias vi=nvim
alias record=wf-recorder


# Dotfiles path
typeset -g DOTFILES_DIR=$HOME/.dotfiles


# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh


# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

### End of Zinit's installer chunk

zinit pack for fzf

# zinit load unixorn/git-extra-commands

# Plugin history-search-multi-word loaded with investigating.
zinit load zdharma-continuum/history-search-multi-word

# Two regular plugins loaded without investigating.
zinit light zsh-users/zsh-autosuggestions
zinit light zdharma-continuum/fast-syntax-highlighting



autoload -Uz compinit
compinit
skip_global_compinit=1

# history setup
setopt APPEND_HISTORY
setopt SHARE_HISTORY
HISTFILE=$HOME/.zhistory
SAVEHIST=10000
HISTSIZE=999
setopt HIST_EXPIRE_DUPS_FIRST
setopt EXTENDED_HISTORY

# autocompletion using arrow keys (based on history)
bindkey '\e[A' history-search-backward
bindkey '\e[B' history-search-forward

zi for \
    atload"zicompinit; zicdreplay" \
    blockf \
    lucid \
    wait \
  zsh-users/zsh-completions

# Load powerlevel10k theme
zinit ice depth"1" # git clone depth
zinit light romkatv/powerlevel10k


# Exa
zinit light ptavares/zsh-exa

# You Should Use 
zinit light MichaelAquilina/zsh-you-should-use


# Git
zi as'null' lucid sbin wait'1' for \
  Fakerr/git-recall \
  davidosomething/git-my \
  iwata/git-now \
  paulirish/git-open \
  paulirish/git-recent \
    atload'export _MENU_THEME=legacy' \
  arzzen/git-quick-stats \
    make'install' \
  tj/git-extras \
    make'GITURL_NO_CGITURL=1' \
    sbin'git-url;git-guclone' \
  zdharma-continuum/git-url

# zinit load djui/alias-tips

# zinit load wfxr/forgit

# Volta
# zinit light "ri7nz/zsh-volta"

# PyEnv
# zinit light "se-jaeger/zsh-activate-py-environment"


typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
  status                  
  command_execution_time  
  background_jobs         
  anaconda
  pyenv               
  node_version     
  go_version 
  python_version      
  load
  time
)

typeset -g POWERLEVEL9K_ICON_PADDING=moderate


function prompt_python_version() {
    local has_python_files=`find ./ -maxdepth 1 -name "*.py"`
    if [ ${#has_python_files[@]} -gt 0 ]; then
        p10k segment -f "blue" -i '' -t "${${$(python3 -V)#* }//\%/%%}"
    fi
}

function prompt_bun_version() {
    if [ -f $PWD/bun.lockb ]; then
        p10k segment -f "blue" -i '' -t "${${$(bun --version)#* }//\%/%%}"
    fi
}


######################### Load ZSH ###########################################

source $DOTFILES_DIR/zsh/aliases.zsh

source $DOTFILES_DIR/zsh/functions/*.zsh


## Paths

# MiniConda
# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/st/.miniconda/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/st/.miniconda/etc/profile.d/conda.sh" ]; then
        . "/home/st/.miniconda/etc/profile.d/conda.sh"
    else
        export PATH="/home/st/.miniconda/bin:$PATH"
    fi
fi
unset __conda_setup


# Conda Auto Activate
if [[ -n "$CONDA_SHLVL" ]]; then
    export CONDACONFIGDIR=""
    cd() { builtin cd "$@" && 
    if [ -f $PWD/.conda_name ]; then
        export CONDACONFIGDIR=$PWD
        conda activate $(cat .conda_name)
    elif [ "$CONDACONFIGDIR" ]; then
        if [[ $PWD != *"$CONDACONFIGDIR"* ]]; then
            export CONDACONFIGDIR=""
            conda deactivate
        fi
    fi }
fi
# <<< conda initialize <<<

# Local bin
export PATH="$PATH:~/.local/bin"

# GoEnv
export PATH="$HOME/.goenv/shims:"$PATH

# Go
export PATH="$HOME/go/bin:$PATH"

# Pyenv
# export PYENV_ROOT="$HOME/.pyenv"
# [[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
# eval "$(pyenv init -)"
# eval "$(pyenv virtualenv-init -)"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH=$BUN_INSTALL/bin:$PATH

# Pixi 
export PATH=/home/st/.pixi/bin:$PATH

# Volta
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"

# Rust
. "$HOME/.cargo/env"

# Wasmer
export WASMER_DIR="/home/st/.wasmer"
[ -s "$WASMER_DIR/wasmer.sh" ] && source "$WASMER_DIR/wasmer.sh"

# ZED 
export PATH=$HOME/.local/bin:$PATH

############################# ZSH Alias ########################################


# Tlds 
tldr-command-line() {
    # if there is no command typed, use the last command
    [[ -z "$BUFFER" ]] && zle up-history

    # if typed command begins with tldr, do nothing
    [[ "$BUFFER" = tldr\ * ]] && return

    # get command and possible subcommand
    # http://zsh.sourceforge.net/Doc/Release/Expansion.html#Parameter-Expansion-Flags
    local -a args
    args=(${${(Az)BUFFER}[1]} ${${(Az)BUFFER}[2]})

    BUFFER="tldr ${args[1]}"
}

zle -N tldr-command-line
# Defined shortcut keys: [Esc]tldr
bindkey "\e"tldr tldr-command-line

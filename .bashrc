#!/usr/bin/env bash

# ------------------------------------------------------
# Init
# ------------------------------------------------------
iatest=$(expr index "$-" i)

[ -f /usr/bin/fastfetch ] && fastfetch
[ -f /etc/bashrc ] && . /etc/bashrc
[ -f /usr/share/bash-completion/bash_completion ] && . /usr/share/bash-completion/bash_completion
[ -f /etc/bash_completion ] && . /etc/bash_completion
[ -f ~/.bash_imports ] && . ~/.bash_imports

# ------------------------------------------------------
# Shell behavior and completion
# ------------------------------------------------------
[[ $iatest -gt 0 ]] && bind "set completion-ignore-case on"
[[ $iatest -gt 0 ]] && bind "set show-all-if-ambiguous On"
[[ $iatest -gt 0 ]] && bind "set bell-style visible"
[[ $- == *i* ]] && stty -ixon

# Better history navigation (arrow up/down filters by prefix)
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

# ------------------------------------------------------
# Environment Variables
# ------------------------------------------------------
export HISTFILESIZE=10000
export HISTSIZE=500
export HISTTIMEFORMAT="%F %T"
export HISTCONTROL=erasedups:ignoredups:ignorespace
shopt -s checkwinsize
shopt -s histappend
PROMPT_COMMAND='history -a'

export EDITOR=nvim
export VISUAL=nvim
alias vim='nvim'

# XDG base directories
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CACHE_HOME="$HOME/.cache"

# LS Colors (Rose Pine inspired)
export CLICOLOR=1
export LS_COLORS='di=1;35:ln=1;36:so=1;33:pi=1;33:ex=1;32:bd=1;33:cd=1;33:or=1;31:mi=1;31:su=1;31:sg=1;33:tw=1;34:ow=1;34:st=1;34:*.tar=1;31:*.zip=1;31:*.gz=1;31:*.bz2=1;31:*.7z=1;31:*.rar=1:*.jpg=1;35:*.jpeg=1;35:*.png=1;35:*.gif=1;35:*.mp3=1;36:*.wav=1;36:*.mp4=1;36:*.mkv=1;36:*.pdf=1;34:*.xml=1;31'

# Less colors for man pages
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

# ------------------------------------------------------
# PATH and Development Tools
# ------------------------------------------------------

# Android
export ANDROID_SDK_ROOT="$HOME/Android/Sdk"
export JAVA_HOME="$HOME/.jdks/jbr-21.0.6"
export PATH="$JAVA_HOME/bin:$ANDROID_SDK_ROOT/tools/bin:$ANDROID_SDK_ROOT/platform-tools:$ANDROID_SDK_ROOT/emulator:$PATH"

# .NET
export DOTNET_ROOT=/usr/share/dotnet
export PATH="$PATH:$DOTNET_ROOT:$DOTNET_ROOT/tools"
export HANGFIRE_LOGIN=ASPiSolutions
export HANGFIRE_PASSWORD=YSTjzJfweWfSJ89x

# PyEnv
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - bash)"

# Node (NVM)
export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Cargo and flatpak
export PATH="$PATH:$HOME/.local/bin:$HOME/.cargo/bin:/var/lib/flatpak/exports/bin:$HOME/.local/share/flatpak/exports/bin"
. "$HOME/.cargo/env"

# User local bin
# Create this directory if it doesn't exist
if [ ! -d "$HOME/bin" ]; then
  mkdir -p "$HOME/bin"
fi
export PATH="$HOME/bin:$PATH"

# Neovim- Mason
export PATH="$HOME/.local/share/nvim/mason/bin:$PATH"

# Starship and Zoxide
eval "$(starship init bash)"
eval "$(zoxide init bash)"

# ------------------------------------------------------
# Aliases
# ------------------------------------------------------

# Bash management
alias ebrc='nvim ~/.bashrc'
alias reload='source ~/.bashrc && echo ".bashrc reloaded"'
alias edf='nvim ~/tools/dotfiles/'

# Safer core utils
alias cp='cp -i'
alias copy='cp'
alias mv='mv -i'
alias rm='trash -v'
alias mkdir='mkdir -p'
alias ps='ps auxf'
alias ping='ping -c 10'
alias less='less -R'
alias apt-get='sudo apt-get'
alias aptu='sudo apt update && sudo apt upgrade'
alias multitail='multitail --no-repeat -c'

# Listing
alias ls='ls -aFh --color=always'
alias ll='ls -Fls'
alias lw='ls -xAh'
alias lf="ls -l | egrep -v '^d'"
alias ldir="ls -l | egrep '^d'"
alias lla='ls -Al'

# System utils
alias da='date "+%Y-%m-%d %A %T %Z"'
alias h='history | grep '
alias p='ps aux | grep '
alias f='find . | grep '
alias checkcommand='type -t'
alias which='type -a'
alias openports='netstat -nape --inet'
alias rebootsafe='sudo shutdown -r now'
alias rebootforce='sudo shutdown -r -n now'

# Archives
alias mktar='tar -cvf'
alias mkbz2='tar -cvjf'
alias mkgz='tar -cvzf'
alias untar='tar -xvf'
alias unbz2='tar -xvjf'
alias ungz='tar -xvzf'

# Logs
alias logs="sudo find /var/log -type f -exec file {} \; | grep 'text' | cut -d' ' -f1 | sed -e's/:$//g' | grep -v '[0-9]$' | xargs tail -f"

# Git
alias ga='git add'
alias gaa='git add .'
alias gb='git branch'
alias gbr='git branch -r'
alias gca='git commit -a'
alias gcm='git commit -m'
alias gcam='git commit -am'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gf='git fetch'
alias gl='git log --oneline --graph --decorate --all'
alias gs='git status -sb'
alias gp='git push'
alias gpl='git pull'

# Grep fallback
if command -v rg &>/dev/null; then
  alias grep='rg'
else
  alias grep='/usr/bin/grep $GREP_OPTIONS'
fi
unset GREP_OPTIONS

# Top usage
alias topcpu='/bin/ps -eo pcpu,pid,user,args | sort -k 1 -r | head -10'
alias topmem='/bin/ps -eo pmem,pid,user,args | sort -k 1 -r | head -10'

# Development
alias tmuxs='tmux new-session -s ${PWD##*/}'
alias rmq='docker run -it --rm --name rabbitmq -p 5672:5672 -p 15672:15672 rabbitmq:4-management'
alias boundvpn='openvpn3 session-start --config bnd-dev'
alias pullmaster='pull_all_master.sh'
alias restoremaster='restore_states.sh'

# Dotnet
alias dnbuild='dotnet build --os linux -p:WarningLevel=0'
alias dnclean='dotnet clean'
alias dnrun='dotnet run --os linux -p:WarningLevel=0'
alias dnrestore='dotnet restore'

# Keepass
alias kp='keepassxc-cli'
alias kpopen='kp open ~/Dropbox/KeePass/Passwords-DrewS-Desktop.kdbx -k ~/.keypass/KeePass.keyx'

# ------------------------------------------------------
# Functions
# ------------------------------------------------------

extract() {
  for archive in "$@"; do
    if [ -f "$archive" ]; then
      case $archive in
      *.tar.bz2) tar xvjf $archive ;;
      *.tar.gz) tar xvzf $archive ;;
      *.bz2) bunzip2 $archive ;;
      *.rar) rar x $archive ;;
      *.gz) gunzip $archive ;;
      *.tar) tar xvf $archive ;;
      *.tbz2) tar xvjf $archive ;;
      *.tgz) tar xvzf $archive ;;
      *.zip) unzip $archive ;;
      *.Z) uncompress $archive ;;
      *.7z) 7z x $archive ;;
      *) echo "don't know how to extract '$archive'..." ;;
      esac
    else
      echo "'$archive' is not a valid file!"
    fi
  done
}

up() {
  local d=""
  limit=$1
  for ((i = 1; i <= limit; i++)); do
    d=$d/..
  done
  d=$(echo $d | sed 's/^\///')
  [ -z "$d" ] && d=..
  cd $d
}

cd() {
  if [ -n "$1" ]; then
    builtin cd "$@" && ls
  else
    builtin cd ~ && ls
  fi
}

source ~/.bash_completion/alacritty

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

alias l='ls -lAh'
alias ll='ls -lh'
alias la='ls -A'

alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'
alias mkdir='mkdir -p'

alias v='nvim'
alias vim='nvim'
alias c='clear'
alias reload='exec zsh'

alias g='git'
alias gs='git status -sb'
alias ga='git add'
alias gaa='git add --all'
alias gc='git commit'
alias gca='git commit --amend'
alias gco='git checkout'
alias gsw='git switch'
alias gd='git diff'
alias gds='git diff --staged'
alias gl='git log --oneline --graph --decorate -20'
alias gp='git push'
alias gpl='git pull --rebase'
alias gst='git stash'
alias gstp='git stash pop'

if (( $+commands[eza] )); then
  alias ls='eza --group-directories-first'
  alias l='eza -la --git --group-directories-first'
  alias ll='eza -l --git --group-directories-first'
  alias lt='eza --tree --level=2 --git-ignore'
fi

if (( $+commands[bat] )); then
  alias cat='bat --paging=never'
  export MANPAGER="sh -c 'col -bx | bat -l man -p'"
fi

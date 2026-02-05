if (( $+commands[fzf] )); then
  source <(fzf --zsh)
  if (( $+commands[fd] )); then
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_ALT_C_COMMAND='fd --type d --hidden --exclude .git'
  fi
  export FZF_DEFAULT_OPTS='--height 40% --layout reverse --border'
fi

if (( $+commands[zoxide] )); then
  eval "$(zoxide init zsh)"
fi

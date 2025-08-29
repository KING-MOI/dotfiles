autoload -Uz vcs_info add-zsh-hook
setopt PROMPT_SUBST

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' unstagedstr '%F{yellow}*%f'
zstyle ':vcs_info:git:*' stagedstr '%F{green}+%f'
zstyle ':vcs_info:git:*' formats ' %F{magenta}%b%f%u%c'
zstyle ':vcs_info:git:*' actionformats ' %F{magenta}%b%f%u%c %F{red}(%a)%f'

_prompt_vcs() {
  vcs_info
}
add-zsh-hook precmd _prompt_vcs

typeset -g _prompt_cmd_start
typeset -g _prompt_elapsed

_prompt_preexec() {
  _prompt_cmd_start=$EPOCHSECONDS
}

_prompt_duration() {
  _prompt_elapsed=
  [[ -n $_prompt_cmd_start ]] || return
  local secs=$(( EPOCHSECONDS - _prompt_cmd_start ))
  _prompt_cmd_start=
  (( secs >= 3 )) || return
  if (( secs >= 60 )); then
    _prompt_elapsed=" %F{yellow}$(( secs / 60 ))m$(( secs % 60 ))s%f"
  else
    _prompt_elapsed=" %F{yellow}${secs}s%f"
  fi
}

zmodload zsh/datetime
add-zsh-hook preexec _prompt_preexec
add-zsh-hook precmd _prompt_duration

typeset -g _prompt_host=
[[ -n $SSH_CONNECTION ]] && _prompt_host='%F{cyan}%n@%m%f '

PROMPT='${_prompt_host}%F{blue}%~%f${vcs_info_msg_0_}${_prompt_elapsed} %(?.%F{green}.%F{red})%#%f '

ZSH_PLUGIN_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/zsh/plugins"

plug() {
  local repo=$1 name=${1:t}
  local dir="$ZSH_PLUGIN_DIR/$name"
  if [[ ! -d $dir ]]; then
    command -v git >/dev/null || return 1
    echo "plug: installing $repo"
    git clone --depth 1 --quiet "https://github.com/$repo.git" "$dir" || return 1
  fi
  local init
  for init in "$dir/$name.plugin.zsh" "$dir/$name.zsh"; do
    if [[ -f $init ]]; then
      source "$init"
      return
    fi
  done
  echo "plug: no init file found for $repo" >&2
  return 1
}

if [[ -z $DOTFILES_NO_PLUGINS ]]; then
  plug zsh-users/zsh-autosuggestions
  plug zsh-users/zsh-syntax-highlighting
fi

plug-update() {
  local dir
  for dir in "$ZSH_PLUGIN_DIR"/*(N/); do
    echo "updating ${dir:t}"
    git -C "$dir" pull --ff-only --quiet
  done
}

ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
bindkey '^ ' autosuggest-accept

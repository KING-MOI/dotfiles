typeset -U path PATH

path_prepend() {
  [[ -d "$1" ]] && path=("$1" $path)
}

path_prepend /opt/homebrew/bin
path_prepend "$HOME/.local/bin"
path_prepend "$HOME/.cargo/bin"

export PATH

typeset -U path PATH

path_prepend() {
  [[ -d "$1" ]] && path=("$1" $path)
}

for brew_bin in /opt/homebrew/bin/brew /usr/local/bin/brew /home/linuxbrew/.linuxbrew/bin/brew; do
  if [[ -x $brew_bin ]]; then
    eval "$("$brew_bin" shellenv)"
    break
  fi
done
unset brew_bin

path_prepend "$HOME/.local/bin"
path_prepend "$HOME/.cargo/bin"

export PATH

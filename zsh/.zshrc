# ~/.zshrc

export DOTFILES="${DOTFILES:-$HOME/.dotfiles}"
ZSH_CONFIG="$DOTFILES/zsh"

for module in exports path history completion keybinds aliases functions prompt plugins; do
  [[ -f "$ZSH_CONFIG/$module.zsh" ]] && source "$ZSH_CONFIG/$module.zsh"
done
unset module

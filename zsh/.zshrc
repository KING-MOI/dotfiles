# ~/.zshrc

export DOTFILES="${${(%):-%x}:A:h:h}"
ZSH_CONFIG="$DOTFILES/zsh"

for module in exports path history completion keybinds aliases functions prompt plugins; do
  [[ -f "$ZSH_CONFIG/$module.zsh" ]] && source "$ZSH_CONFIG/$module.zsh"
done
unset module

[[ -f "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"

# ~/.zshrc

export DOTFILES="${DOTFILES:-$HOME/.dotfiles}"
ZSH_CONFIG="$DOTFILES/zsh"

for file in "$ZSH_CONFIG"/*.zsh(N); do
  source "$file"
done
unset file

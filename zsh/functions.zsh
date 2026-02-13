mkcd() {
  mkdir -p -- "$1" && cd -- "$1"
}

extract() {
  if [[ ! -f "$1" ]]; then
    echo "extract: '$1' is not a file" >&2
    return 1
  fi
  case "$1" in
    *.tar.bz2|*.tbz2) tar xjf "$1" ;;
    *.tar.gz|*.tgz)   tar xzf "$1" ;;
    *.tar.xz)         tar xJf "$1" ;;
    *.tar)            tar xf "$1" ;;
    *.bz2)            bunzip2 "$1" ;;
    *.gz)             gunzip "$1" ;;
    *.zip)            unzip "$1" ;;
    *.7z)             7z x "$1" ;;
    *) echo "extract: unknown archive '$1'" >&2; return 1 ;;
  esac
}

port() {
  if [[ -z $1 ]]; then
    echo "usage: port <number>" >&2
    return 1
  fi
  lsof -nP -iTCP:"$1" -sTCP:LISTEN
}

fbr() {
  local branch
  branch=$(git branch --all --sort=-committerdate --format='%(refname:short)' |
    grep -v HEAD | fzf --prompt 'branch> ') || return
  git switch "${branch#origin/}"
}

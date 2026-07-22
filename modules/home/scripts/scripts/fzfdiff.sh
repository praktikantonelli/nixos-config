printf -v diff_args '%q ' "$@"

git diff "$@" --name-only |
  fzf -m --ansi --preview "git diff ${diff_args}--color=always -- {-1}"

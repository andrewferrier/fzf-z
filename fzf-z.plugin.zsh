#!/usr/bin/env zsh
#
# Based on https://github.com/junegunn/fzf/blob/master/shell/key-bindings.zsh
# (MIT licensed, as of 2016-05-05).

__fzfz() {
  local cmd="z -l | tail -r | sed 's/^[[:digit:].]*[[:space:]]*//'"
  eval "$cmd" | fzf -m --preview="ls -1 {} | head -$LINES" | while read item; do
    printf 'cd %q ' "$item"
  done
  echo
}

fzfz-file-widget() {
  LBUFFER="${LBUFFER}$(__fzfz)"
  zle redisplay
}

zle     -N   fzfz-file-widget
bindkey '^G' fzfz-file-widget

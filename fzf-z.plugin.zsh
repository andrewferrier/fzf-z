#!/usr/bin/env zsh
#
# Based on https://github.com/junegunn/fzf/blob/master/shell/key-bindings.zsh
# (MIT licensed, as of 2016-05-05).

__fzfz() {
    if (($+FZFZ_EXTRA_DIRS)); then
        FZFZ_EXTRA_DIRS="{ find $FZFZ_EXTRA_DIRS -type d 2> /dev/null }"
    else
        FZFZ_EXTRA_DIRS="{ true }"
    fi
    local cmd="{ { z -l | tail -r | sed 's/^[[:digit:].]*[[:space:]]*//' }; $FZFZ_EXTRA_DIRS; }"
    eval "$cmd" | fzf --tiebreak=index -m --preview="ls -1 {} | head -$LINES" | while read item; do
    printf '%q ' "$item"
  done
  echo
}

fzfz-file-widget() {
  LBUFFER="${LBUFFER}$(__fzfz)"
  zle redisplay
}

zle     -N   fzfz-file-widget
bindkey '^G' fzfz-file-widget

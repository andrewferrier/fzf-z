#!/usr/bin/env zsh
#
# Based on https://github.com/junegunn/fzf/blob/master/shell/key-bindings.zsh
# (MIT licensed, as of 2016-05-05).

FZFZ_SCRIPT_PATH=${0:a:h}

__fzfz() {
    $FZFZ_SCRIPT_PATH/fzfz | while read item; do
        printf '%q ' "$item"
    done
    echo
}

fzfz-dir-widget() {
    local shouldAccept=$(should-accept-line)
    LBUFFER="${LBUFFER}$(__fzfz)"
    local ret=$?
    zle redisplay
    typeset -f zle-line-init >/dev/null && zle zle-line-init
    if [[ $ret -eq 0 && -n "$BUFFER" && -n "$shouldAccept" ]]; then
        zle .accept-line
    fi
    return $ret
}

# Accept the line if the buffer was empty before invoking the file widget, and
# the `auto_cd` option is set.
should-accept-line() {
    if [[ ${#${(z)BUFFER}} -eq 0 && -o auto_cd ]]; then
        echo "true";
    fi
}

zle -N fzfz-dir-widget
bindkey -M viins -r '^G'
bindkey -M vicmd -r '^G'
bindkey -M emacs -r '^G'

bindkey -M viins '^G' fzfz-dir-widget
bindkey -M vicmd '^G' fzfz-dir-widget
bindkey -M emacs '^G' fzfz-dir-widget

#!/usr/bin/env zsh
#
# Based on https://github.com/junegunn/fzf/blob/master/shell/key-bindings.zsh
# (MIT licensed, as of 2016-05-05).

if [[ $OSTYPE == darwin* ]]; then
    REVERSER='tail -r'
else
    REVERSER='tac'
fi

command -v tree >/dev/null 2>&1
if [ $? -eq 0 ]; then
    PREVIEW_COMMAND='tree -L 2 -x --noreport --dirsfirst {}'
else
    PREVIEW_COMMAND='ls -1 -R {}'
fi

FZFZ_EXCLUDE_PATTERN=${FZFZ_EXCLUDE_PATTERN:="\/.git"}
FZFZ_EXTRA_OPTS=${FZFZ_EXTRA_OPTS:=""}
FZFZ_UNIQUIFIER="awk '!seen[\$0]++'"

__fzfz() {
    if (($+FZFZ_EXCLUDE_PATTERN)); then
        EXCLUDER="egrep -v '$FZFZ_EXCLUDE_PATTERN'"
    else
        EXCLUDER="cat"
    fi

    # EXCLUDER is applied directly only to searches that need it (i.e. not
    # `z`). That improvements performance, and makes sure that the
    # FZFZ_SUBDIR_LIMIT is applied on the post-excluded list.

    if (($+FZFZ_EXTRA_DIRS)); then
        EXTRA_DIRS="{ find $FZFZ_EXTRA_DIRS -type d 2> /dev/null | $EXCLUDER }"
    else
        EXTRA_DIRS="{ true }"
    fi

    FZFZ_SUBDIR_LIMIT=${FZFZ_SUBDIR_LIMIT:=50}

    REMOVE_FIRST="tail -n +2"
    LIMIT_LENGTH="head -n $(($FZFZ_SUBDIR_LIMIT+1))"

    SUBDIRS="{ find '$PWD' -type d | $EXCLUDER | $LIMIT_LENGTH | $REMOVE_FIRST }"
    RECENTLY_USED_DIRS="{ z -l | $REVERSER | sed 's/^[[:digit:].]*[[:space:]]*//' }"

    FZF_COMMAND="fzf --height ${FZF_TMUX_HEIGHT:-40%} ${FZFZ_EXTRA_OPTS} --tiebreak=end,index -m --preview='$PREVIEW_COMMAND | head -\$LINES'"

    local COMMAND="{ $SUBDIRS ; $RECENTLY_USED_DIRS ; $EXTRA_DIRS; } | $FZFZ_UNIQUIFIER | $FZF_COMMAND"

    eval "$COMMAND" | while read item; do
        printf '%q ' "$item"
    done
    echo
}

fzfz-file-widget() {
    LBUFFER="${LBUFFER}$(__fzfz)"
    local ret=$?
    zle redisplay
    typeset -f zle-line-init >/dev/null && zle zle-line-init
    return $ret
}

zle     -N   fzfz-file-widget
bindkey '^G' fzfz-file-widget

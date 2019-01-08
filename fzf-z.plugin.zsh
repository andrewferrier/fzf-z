#!/usr/bin/env zsh
#
# Based on https://github.com/junegunn/fzf/blob/master/shell/key-bindings.zsh
# (MIT licensed, as of 2016-05-05).

# These options are intended to be user-customizable if needed; you can
# override them by exporting them from your ~/.zshrc. See README for more
# details.

FZFZ_EXCLUDE_PATTERN=${FZFZ_EXCLUDE_PATTERN:="\/.git"}
FZFZ_EXTRA_OPTS=${FZFZ_EXTRA_OPTS:=""}
FZFZ_UNIQUIFIER=${FZFZ_UNIQUIFIER:="awk '!seen[\$0]++'"}
FZFZ_SUBDIR_LIMIT=${FZFZ_SUBDIR_LIMIT:=50}

# *****

if [[ $OSTYPE == darwin* ]]; then
    FZFZ_REVERSER='tail -r'
else
    FZFZ_REVERSER='tac'
fi

command -v tree >/dev/null 2>&1
if [ $? -eq 0 ]; then
    FZFZ_PREVIEW_COMMAND='tree -L 2 -x --noreport --dirsfirst {}'
else
    FZFZ_PREVIEW_COMMAND='ls -1 -R {}'
fi


if type fd &>/dev/null; then
    FZFZ_FIND_PREFIX="fd --color=never --hidden . "
    FZFZ_FIND_POSTFIX=" --type directory"
else
    FZFZ_FIND_PREFIX="find "
    FZFZ_FIND_POSTFIX=" -type d"
fi

__fzfz() {
    if (($+FZFZ_EXCLUDE_PATTERN)); then
        local EXCLUDER="egrep -v '$FZFZ_EXCLUDE_PATTERN'"
    else
        local EXCLUDER="cat"
    fi

    # EXCLUDER is applied directly only to searches that need it (i.e. not
    # `z`). That improvements performance, and makes sure that the
    # FZFZ_SUBDIR_LIMIT is applied on the post-excluded list.

    if (($+FZFZ_EXTRA_DIRS)); then
        local EXTRA_DIRS="{ $FZFZ_FIND_PREFIX $FZFZ_EXTRA_DIRS $FZFZ_FIND_POSTFIX 2> /dev/null | $EXCLUDER }"
    else
        local EXTRA_DIRS="{ true }"
    fi

    local REMOVE_FIRST="tail -n +2"
    local LIMIT_LENGTH="head -n $(($FZFZ_SUBDIR_LIMIT+1))"

    local SUBDIRS="{ $FZFZ_FIND_PREFIX $PWD $FZFZ_FIND_POSTFIX | $EXCLUDER | $LIMIT_LENGTH | $REMOVE_FIRST }"
    local RECENTLY_USED_DIRS="{ z -l | $FZFZ_REVERSER | sed 's/^[[:digit:].]*[[:space:]]*//' }"

    local FZF_COMMAND="fzf --height ${FZF_TMUX_HEIGHT:-40%} ${FZFZ_EXTRA_OPTS} --tiebreak=end,index -m --preview='$FZFZ_PREVIEW_COMMAND | head -\$LINES'"

    local COMMAND="{ $SUBDIRS ; $RECENTLY_USED_DIRS ; $EXTRA_DIRS; } | $FZFZ_UNIQUIFIER | $FZF_COMMAND"

    eval "$COMMAND" | while read item; do
        printf '%q ' "$item"
    done
    echo
}

fzfz-file-widget() {
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

zle -N fzfz-file-widget
bindkey -M viins -r '^G'
bindkey -M vicmd -r '^G'
bindkey -M emacs -r '^G'

bindkey -M viins '^G' fzfz-file-widget
bindkey -M vicmd '^G' fzfz-file-widget
bindkey -M emacs '^G' fzfz-file-widget

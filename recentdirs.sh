#!/usr/bin/env bash

set -o errexit
set -o pipefail

FZFZ_RECENT_DIRS_TOOL=${FZFZ_RECENT_DIRS_TOOL:="z"}

SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

if [[ $FZFZ_RECENT_DIRS_TOOL == "z" ]]; then
    if [ ! -f "$SCRIPT_PATH/z.sh" ]; then
        >&2 echo "Locally-cached copy of z.sh not found, downloading..."
        curl --silent https://raw.githubusercontent.com/rupa/z/master/z.sh > "$SCRIPT_PATH/z.sh"
    fi

    source "$SCRIPT_PATH/z.sh"
    _z -l 2>&1 && exit 0 || exit 0
elif [[ $FZFZ_RECENT_DIRS_TOOL == "autojump" ]]; then
    if [[ $OSTYPE == darwin* && -z $(whence tac) ]]; then
        REVERSER='tail -r'
    else
        REVERSER='tac'
    fi
    autojump -s | $REVERSER | tail +8 | $REVERSER | awk '{print $2}'
elif [[ $FZFZ_RECENT_DIRS_TOOL == "fasd" ]]; then
    fasd -dl 2>&1 && exit 0 || exit 0
else
    echo "Unrecognized recent dirs tool '$FZFZ_RECENT_DIRS_TOOL', please set \$FZFZ_RECENT_DIRS_TOOL correctly."
    exit 1
fi

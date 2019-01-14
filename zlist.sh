#!/bin/bash

set -o errexit
set -o pipefail

SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

if [ ! -f "$SCRIPT_PATH/z.sh" ]; then
    curl https://raw.githubusercontent.com/rupa/z/master/z.sh > "$SCRIPT_PATH/z.sh"
fi

source "$SCRIPT_PATH/z.sh"
_z -l 2>&1 && exit 0 || exit 0

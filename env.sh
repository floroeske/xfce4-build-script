#!/usr/bin/env bash

set -e

MODULES=""

message ()
{
    local GREEN="\e[32m"
    local NC="\e[0m"
    echo -e "${GREEN}$@${NC}"
}

read_modules ()
{
    while IFS= read -r LINE; do
        if [[ $LINE =~ ^#.* ]]
        then
            :
        else
            MODULES+=" $LINE"
        fi
    done < modules.txt

    echo $MODULES
}

MODULES=$(read_modules)
PREFIX=/usr/local
XFCE4_SOURCE_DIR=$HOME/xfce4-build/src

export PKG_CONFIG_PATH="${PREFIX}/lib/pkgconfig:$PKG_CONFIG_PATH"
export CFLAGS="-O2 -pipe"

pushd $XFCE4_SOURCE_DIR

echo PWD $PWD

#!/bin/bash

set -e

MODULES=""
while IFS= read -r LINE; do
    if [[ $LINE =~ ^#.* ]]
    then
        echo Skipping $LINE
    else
        MODULES+=" $LINE"
    fi
done < modules.txt

PREFIX=/usr/local
export PKG_CONFIG_PATH="${PREFIX}/lib/pkgconfig:$PKG_CONFIG_PATH"
export CFLAGS="-O2 -pipe"
DIR=$HOME/xfce4-build/src
pushd $DIR

for MODULE in ${MODULES};
do
    IFS=';';
    set -- $MODULE
    unset IFS

    GROUP=$1
    REPO=$2
    BUILDSYSTEM=$3

    echo MODULE ${MODULE}
    echo GROUP $GROUP
    echo REPO $REPO
    echo BUILDSYSTEM $BUILDSYSTEM

    if [[ "$BUILDSYSTEM" == "make" ]]
    then
        pushd ${REPO}
        if [ ! -f "configure" ]; then
            echo running autogen.sh
            sh autogen.sh  # &> /dev/null
        fi
        echo running configure
        ./configure --prefix=${PREFIX} --enable-maintainer-mode  # &> /dev/null
        popd
    elif [[ "$BUILDSYSTEM" == "cmake" ]]
    then
        pushd ${REPO}
        cmake -DCMAKE_INSTALL_PREFIX=${PREFIX} .
        popd
    fi
done

echo
echo "Success"

#!/bin/bash

source env.sh

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

    pushd ${REPO}
    make -j `nproc`
    sudo make install
    popd
done

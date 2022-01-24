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

DIR=$HOME/xfce4-build/src
mkdir -p $DIR
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

    if [ -d "${REPO}" ]
    then
        pushd ${REPO}
        git pull
        popd
    else
        git clone https://gitlab.xfce.org/$GROUP/$REPO.git
    fi
done

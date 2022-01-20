#!/bin/bash

set -e

PREFIX=$HOME/local
export PKG_CONFIG_PATH="${PREFIX}/lib/pkgconfig:$PKG_CONFIG_PATH"
export CFLAGS="-O2 -pipe"


usage() { echo "xfce-build.sh [-s]" 1>&2; exit 1; }

while getopts "s" OPTION; do
    case $OPTION in
        s)
            SKIP=1
            ;;
        *)
            usage
            ;;
    esac
done

mkdir -p ./xfce
pushd ./xfce

MODULES="  xfce/xfce4-dev-tools"
MODULES+=" xfce/libxfce4util"
MODULES+=" xfce/xfconf"
MODULES+=" xfce/libxfce4ui"
MODULES+=" xfce/garcon"
MODULES+=" xfce/exo"
MODULES+=" xfce/thunar"
MODULES+=" xfce/xfce4-panel"
MODULES+=" xfce/xfce4-settings"
# MODULES+=" xfce/xfce4-session"
MODULES+=" xfce/xfdesktop"
MODULES+=" xfce/xfwm4"
MODULES+=" xfce/xfce4-appfinder"
MODULES+=" xfce/tumbler"
MODULES+=" xfce/thunar-volman"
MODULES+=" xfce/xfce4-power-manager"

MODULES+=" apps/gigolo"
# MODULES+=" apps/xfce4-mixer"
MODULES+=" apps/xfce4-notifyd"
MODULES+=" apps/xfce4-screensaver"
MODULES+=" apps/xfce4-screenshooter"
MODULES+=" apps/xfce4-taskmanager"
MODULES+=" apps/xfce4-terminal"
MODULES+=" apps/xfce4-volumed-pulse"


if [ -z "${SKIP}" ];
then
    for MODULE in ${MODULES};
    do
        IFS='/';
        set -- $MODULE
        unset IFS

        GROUP=$1
        REPO=$2

        echo MODULE ${MODULE}
        echo GROUP $GROUP
        echo REPO $REPO

        if [ -d "${REPO}" ]
        then
            pushd ${REPO}
            git pull
            popd
        else
            git clone https://gitlab.xfce.org/$GROUP/$REPO.git
        fi
    done
fi

for MODULE in ${MODULES};
do
    IFS='/';
    set -- $MODULE
    unset IFS

    GROUP=$1
    REPO=$2

    echo MODULE ${MODULE}
    echo GROUP $GROUP
    echo REPO $REPO

    pushd ${REPO}

    if [ -f "SUCCESS" ]; then
        :
    else
        if [ ! -f "configure" ]; then
            sh autogen.sh
        fi

        ./configure --prefix=${PREFIX} --enable-maintainer-mode
        make -j `nproc`
        make install
        touch SUCCESS
    fi
    popd
done

echo
echo "Success"

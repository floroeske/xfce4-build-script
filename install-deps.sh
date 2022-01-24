#!/bin/bash

set -e

sudo apt-get install libsoup2.4-dev libxmu-dev libpulse-dev libkeybinder-3.0-dev libindicator3-dev

sudo apt-get build-dep xfce4-dev-tools xfce4-panel xfce4-terminal thunar xfce4-screensaver xfce4-power-manager xfce4-power-manager xfce4-indicator-plugin

# whisker
sudo apt-get install libaccountsservice-dev

# xfce4-xkb-plugin
sudo apt-get install librsvg2-dev

#!/bin/sh

set -eu

ARCH=$(uname -m)
VERSION=$(pacman -Q qterminal | awk '{print $2; exit}') # example command to get version of application here
export ARCH VERSION
export OUTPATH=./dist
export ADD_HOOKS="self-updater.bg.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export ICON=/usr/share/icons/hicolor/64x64/apps/qterminal.png
export DESKTOP=/usr/share/applications/qterminal.desktop
export ANYLINUX_LIB=1
# libqtermwidget is hardcoded to look into /usr/share
export PATH_MAPPING='/usr/share/qtermwidget*:${SHARUN_DIR}/share/qtermwidget*'

# Deploy dependencies
quick-sharun /usr/bin/qterminal /usr/share/qterminal /usr/share/qtermwidget*

# Additional changes can be done in between here

# Turn AppDir into AppImage
quick-sharun --make-appimage

# Test the app for 12 seconds, if the test fails due to the app
# having issues running in the CI use --simple-test instead
quick-sharun --test ./dist/*.AppImage

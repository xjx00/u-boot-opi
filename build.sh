#!/bin/bash
sudo apt-get update && sudo apt-get install -y bc build-essential curl git-core libncurses5-dev module-init-tools swig libpython-dev

# Install crosscompile toolchain for ARM
mkdir -p /opt/linaro
curl -sSL http://releases.linaro.org/components/toolchain/binaries/5.3-2016.02/arm-linux-gnueabihf/gcc-linaro-5.3-2016.02-x86_64_arm-linux-gnueabihf.tar.xz | tar xfJ - -C /opt/linaro
export CROSS_COMPILE=/opt/linaro/gcc-linaro-5.3-2016.02-x86_64_arm-linux-gnueabihf/bin/arm-linux-gnueabihf-

git clone git://git.denx.de/u-boot.git
cd u-boot
make orangepi_zero_defconfig
make V=s -j8 ARCH=arm CROSS_COMPILE=$CROSS_COMPILE
ls -l
mkdir builds
cp u-boot-sunxi-with-spl.bin builds/
export BUILD_NR="$(date '+%Y%m%d-%H%M%S')"
# deploy to GitHub releases
export GIT_TAG=v$BUILD_NR
export GIT_RELTEXT="Auto-released by [Travis-CI build #$TRAVIS_BUILD_NUMBER](https://travis-ci.org/$TRAVIS_REPO_SLUG/builds/$TRAVIS_BUILD_ID)"
curl -sSL https://github.com/tcnksm/ghr/releases/download/v0.5.4/ghr_v0.5.4_linux_amd64.zip > ghr.zip
unzip ghr.zip
./ghr --version
./ghr --debug -u xjx00 -r u-boot-opi-b "$GIT_RELTEXT" $GIT_TAG builds/

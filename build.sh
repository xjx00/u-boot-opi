#!/bin/bash
sudo apt-get update && sudo apt-get install -y bc build-essential curl git-core libncurses5-dev module-init-tools

# Install crosscompile toolchain for ARM
mkdir -p /opt/linaro
curl -sSL http://releases.linaro.org/components/toolchain/binaries/5.3-2016.02/arm-linux-gnueabihf/gcc-linaro-5.3-2016.02-x86_64_arm-linux-gnueabihf.tar.xz | tar xfJ - -C /opt/linaro
export CROSS_COMPILE=/opt/linaro/gcc-linaro-5.3-2016.02-x86_64_arm-linux-gnueabihf/bin/arm-linux-gnueabihf-

git clone git://git.denx.de/u-boot.git
cd u-boot
make orangepi_zero_defconfig
make V=s -j8 ARCH=arm CROSS_COMPILE=$CROSS_COMPILE

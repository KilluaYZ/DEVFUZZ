#!/bin/bash

apt update

# QEMU 编译
apt install -y build-essential libglib2.0-dev pkg-config libpixman-1-dev libpcap-dev libcap-ng-dev libattr1-dev libnfs-dev libseccomp-dev libxkbcommon-dev libiscsi-dev libzstd-dev  libcurl4-openssl-dev libudev-dev libncursesw5-dev  libsdl2-dev libpng-dev libjpeg-dev libgcrypt20-dev  libgtk-3-dev libusb-1.0-0-dev ninja-build

# 内核编译
apt install -y flex bison libelf-dev bc libssl-dev

# python
apt install -y python3 python3-pip

pip3 install wllvm distro
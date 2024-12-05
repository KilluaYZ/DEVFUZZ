#!/bin/bash

set -euo pipefail

if [ -d build-qemu-exp ]; then
    rm -r build-qemu-exp;
fi

echo "---------- Build Qemu ----------"
./build_qemu_afl.sh

echo "---------- Build AFL ----------"
make -C ./AFL

echo "---------- Build AFL Proxy ----------"
make -C afl-proxy

echo "---------- Build S2E ----------"
cd s2e;
./build.sh 
cd ..;

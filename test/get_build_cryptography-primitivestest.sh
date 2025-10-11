#!/bin/bash

: >> "$filelist"

if [ -d cryptography-primitives/.git ]; then
    cd cryptography-primitives
    git reset --hard
    xargs -r rm -f < "$filelist"
    CC=gcc CXX=g++ cmake CMakeLists.txt -B_build -DARCH=intel64 -DCMAKE_ASM_NASM_COMPILER=nasm
    cd _build
    make clean
else
    git clone https://github.com/intel/cryptography-primitives.git cryptography-primitives
    cd cryptography-primitives
    CC=gcc CXX=g++ cmake CMakeLists.txt -B_build -DARCH=intel64 -DCMAKE_ASM_NASM_COMPILER=nasm
    cd _build
fi
: > "$filelist"
make all -j4

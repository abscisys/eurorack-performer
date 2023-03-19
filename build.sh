#!/bin/bash

CURRDIR=$(pwd)

echo "***************"
echo "* STM32 build *"
echo "***************"
cd ${CURRDIR}

echo ">>> Installing tools ..."
make tools_install
echo "<<< Tools installed"

echo ""

echo ">>> Setting up STM32 ..."
make setup_stm32
echo "<<< Setup STM32 completed"

echo ""

echo ">>> STM32 building ..."
cd build/stm32/release
make -j
echo "<<< STM32 build completed"

echo ""
echo ""

echo "*******************"
echo "* Simulator build *"
echo "*******************"
cd ${CURRDIR}

echo ">>> Install Ubuntu dependencies ..."
sudo apt install -y libsdl2-dev libasound2-dev mesa-common-dev python3.11 python3.11-dev
echo "<<< Ubuntu dependencies installed"

echo ""

echo ">>> Setting up simulator ..."
make setup_sim
echo "<<< Setup simulator completed"

echo ">>> Building simulator ..."
cd build/sim/release
make -j
make test
echo "<<< Build simulator completed"

echo ""
echo ""

echo "*****************************"
echo "* Simulation platform build *"
echo "*****************************"
cd ${CURRDIR}

echo ">>> Setting up simulation platform ..."
if [[ ! -e ${CURRDIR}/emsdk ]]; then
    git submodule add https://github.com/emscripten-core/emsdk.git
fi
git submodule update --init --recursive emsdk
./emsdk/emsdk install latest
./emsdk/emsdk activate latest
source ./emsdk/emsdk_env.sh
make setup_www
echo "<<< Setup simulation platform completed"

echo ""

echo ">>> Building simulation platform ..."
cd build/sim/www
make -j all
echo "<<< Build simulation platform completed"

echo ""
echo ""

echo "*************"
echo "* COMPLETED *"
echo "*************"

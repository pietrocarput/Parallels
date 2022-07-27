#!/bin/bash

CUR_PATH=$(cd "$(dirname $(readlink -f "$0"))" && pwd)
ROOT_PATH=$(cd "${CUR_PATH}/../" && pwd)

export CC
export CXX
export PATH

if [ -f /usr/local/opt/llvm/bin/clang ]; then
	CC=/usr/local/opt/llvm/bin/clang
	CXX=/usr/local/opt/llvm/bin/clang++
	PATH="/usr/local/opt/llvm/bin:$PATH"
fi

cmake -S "${ROOT_PATH}" -B "${ROOT_PATH}/build" \
	-DCMAKE_BUILD_TYPE=Release \
	-DCMAKE_OSX_ARCHITECTURES="x86_64;arm64" \
	-DCMAKE_OSX_DEPLOYMENT_TARGET="11.0" \
	-DLOGGING_DISABLE=1 \
&& \
cmake --build "${ROOT_PATH}/build" --target Configurer64 -j8

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
else
	echo '[*] not found llvm homebrew version, you can install with "brew install llvm".'
fi

cmake -S "${ROOT_PATH}" -B "${ROOT_PATH}/build" \
	-DCMAKE_BUILD_TYPE=Release \
	-DCMAKE_OSX_ARCHITECTURES="x86_64;arm64" \
	-DCMAKE_OSX_DEPLOYMENT_TARGET="11.0" \
&& \
cmake --build "${ROOT_PATH}/build" --target UIWarp -j8 \
&& echo "[*] Build Success"

#!/bin/bash

CUR_PATH=$(cd "$(dirname $(readlink -f "$0"))" && pwd)
ROOT_PATH=$(cd "${CUR_PATH}/../" && pwd)

if [ -d "${ROOT_PATH}/build" ]; then
	rm -rf "${ROOT_PATH}/build" > /dev/null
fi

exec "${CUR_PATH}/build.sh"

#!/bin/bash

CUR_PATH=$(cd "$(dirname $(readlink -f "$0"))" && pwd)
ROOT_PATH=$(cd "${CUR_PATH}/../" && pwd)
PTFM_APP_DIR="/Applications/Parallels Toolbox.app"
PDFM_APP_DIR="/Applications/Parallels Desktop.app"
CODESIGN_CERT=-

function sign_cmd() {
	codesign -f -s ${CODESIGN_CERT} --timestamp=none --all-architectures --deep "$@"
}

function kill_ptfm_app() {
	killall -9 "Parallels Toolbox" 2> /dev/null
}

function kill_pdfm_app() {
	killall -9 prl_client_app 2> /dev/null
}

function apply_pdfm_crack() {
	echo "[*] Apply patch"

	SRC="${ROOT_PATH}/crack/pdfm-18.0.1.53056/prl_client_app"
	DST="${PDFM_TMP_DIR}/Parallels Desktop.app/Contents/MacOS/prl_client_app"
	echo "[*] Copy \"${SRC}\" to \"${DST}\""
	cp -f -X "${SRC}" "${DST}" > /dev/null

	SRC="${ROOT_PATH}/crack/pdfm-18.0.1.53056/prl_disp_service"
	DST="${PDFM_TMP_DIR}/Parallels Desktop.app/Contents/MacOS/Parallels Service.app/Contents/MacOS/prl_disp_service"
	echo "[*] Copy \"${SRC}\" to \"${DST}\""
	cp -f -X "${SRC}" "${DST}" > /dev/null
}

function sign_pdfm() {
	echo "[*] Sign Parallels Desktop App"
	sign_cmd --entitlements "${ROOT_PATH}/entitlements/ParallelsDesktop/ParallelsService.entitlements" "${PDFM_APP_DIR}/Contents/MacOS/Parallels Service.app/Contents/MacOS/prl_disp_service"
}

if [ -d "${PDFM_APP_DIR}" ]; then
	echo "[*] Install Parallels Desktop patch"
	kill_pdfm_app
	apply_pdfm_crack
	sign_pdfm
else
	echo "[*] not found ${PDFM_APP_DIR}, skip."
fi

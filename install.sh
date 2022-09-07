#!/bin/sh

CUR_PATH=$(cd "$(dirname $(readlink -f "$0"))" && pwd)

PDFM_DISP_CRACK="${CUR_PATH}/prl_disp_service"
PDFM_DISP_DST="/Applications/Parallels Desktop.app/Contents/MacOS/Parallels Service.app/Contents/MacOS/prl_disp_service"
PDFM_DISP_ENT="${CUR_PATH}/ParallelsService.entitlements"

LICENSE_FILE="${CUR_PATH}/licenses.json"
LICENSE_DST="/Library/Preferences/Parallels/licenses.json"

echo "[*] Kill Parallels Desktop"

killall -9 -q prl_client_app > /dev/null
killall -9 -q prl_disp_service > /dev/null

echo "[*] Copy prl_disp_service"

sudo cp -f ${PDFM_DISP_CRACK} "${PDFM_DISP_DST}"

echo "[*] Sign prl_disp_service"

sudo codesign -f -s - --timestamp=none --all-architectures --entitlements ${PDFM_DISP_ENT} "${PDFM_DISP_DST}"

echo "[*] Copy licenses.json"

sudo rm -f "${LICENSE_DST}" > /dev/null

sudo cp "${LICENSE_FILE}" "${LICENSE_DST}"

sudo chown root:wheel "${LICENSE_DST}"

sudo chmod 444 "${LICENSE_DST}"

echo "[*] Crack over"

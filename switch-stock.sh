#!/usr/bin/env bash

COLOR_INFO='\033[0;34m'
COLOR_ERR='\033[0;35m'
COLOR_WARN='\033[0;93m'
NOCOLOR='\033[0m'

PDFM_DIR="/Applications/Parallels Desktop.app"

PDFM_DISP_DST="${PDFM_DIR}/Contents/MacOS/Parallels Service.app/Contents/MacOS/prl_disp_service"
PDFM_DISP_BCUP="${PDFM_DIR}/Contents/MacOS/Parallels Service.app/Contents/MacOS/prl_disp_service_bcup"

# check root permission
if [ "$EUID" -ne 0 ]; then
  echo -e "${COLOR_ERR}[-] Not have root permission, run sudo.${NOCOLOR}"
  exec sudo "$0" "$@"
  exit 5
fi

cp -f "${PDFM_DISP_BCUP}" "${PDFM_DISP_DST}"

echo -e "${COLOR_WARN}Remember to run use-patched.sh, after closing the Parallels launcher, before starting the launcher again${NOCOLOR}"

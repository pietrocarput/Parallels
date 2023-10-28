#!/usr/bin/env bash

COLOR_INFO='\033[0;34m'
COLOR_ERR='\033[0;35m'
COLOR_WARN='\033[0;93m'
NOCOLOR='\033[0m'

BASE_PATH=$(
  cd $(dirname "$0");
  pwd
)

PDFM_VER="19.1.0-54729"
PDFM_DIR="/Applications/Parallels Desktop.app"

LICENSE_FILE="${BASE_PATH}/licenses.json"
LICENSE_DST="/Library/Preferences/Parallels/licenses.json"

PDFM_DISP_DIR="${PDFM_DIR}/Contents/MacOS/Parallels Service.app/Contents/MacOS"
PDFM_DISP_DST="${PDFM_DISP_DIR}/prl_disp_service"
PDFM_DISP_BCUP="${PDFM_DISP_DST}_bcup"
PDFM_DISP_PATCH="${PDFM_DISP_DST}_patched"
PDFM_DISP_ENT="${BASE_PATH}/ParallelsService.entitlements"

TMP_DIR="${BASE_PATH}/tmp"

ARM64_RET_1="${TMP_DIR}/arm64_ret_1"
ARM64_B_0xC="${TMP_DIR}/arm64_b_0xC"
ARM64_B_0x10="${TMP_DIR}/arm64_b_0x10"

X86_64_JMP_0x17="${TMP_DIR}/x86_64_jmp_0x17"
X86_64_JMP_0xA="${TMP_DIR}/x86_64_jmp_0xa"
X86_64_RET_1="${TMP_DIR}/x86_64_ret_1"

SUBM_DIR="${BASE_PATH}/submodules"

INSERT_DYLIB_DIR="${SUBM_DIR}/insert_dylib"
INSERT_DYLIB_PRJ="${INSERT_DYLIB_DIR}/insert_dylib.xcodeproj"
INSERT_DYLIB_BIN="${INSERT_DYLIB_DIR}/build/Release/insert_dylib"

HOOK_PARALLELS_DIR="${SUBM_DIR}/hook_parallels"
HOOK_PARALLELS_PRJ="${HOOK_PARALLELS_DIR}/HookParallels.xcodeproj"
HOOK_PARALLELS_DYLIB="${HOOK_PARALLELS_DIR}/build/Release/libHookParallels.dylib"
HOOK_PARALLELS_DYLIB_DST="${PDFM_DISP_DIR}/libHookParallels.dylib"

# check parallels desktop version
VERSION_1=$(defaults read "${PDFM_DIR}/Contents/Info.plist" CFBundleShortVersionString)
VERSION_2=$(defaults read "${PDFM_DIR}/Contents/Info.plist" CFBundleVersion)
INSTALL_VER="${VERSION_1}-${VERSION_2}"
if [ "${PDFM_VER}" != "${VERSION_1}-${VERSION_2}" ]; then
  echo -e "${COLOR_ERR}[-] This script is for ${PDFM_VER}, but your's is ${INSTALL_VER}.${NOCOLOR}"
  exit 2
fi

# check root permission
if [ "$EUID" -ne 0 ]; then
  echo -e "${COLOR_ERR}[-] Missing root permission, run sudo.${NOCOLOR}"
  exec sudo "$0" "$@"
  exit 5
fi

if [ ! -d "$INSERT_DYLIB_PRJ" ] || [ ! -d "$HOOK_PARALLELS_PRJ" ]; then
  echo -e "${COLOR_ERR}[-] Missing submodule files, perhaps you forgot to execute \"git submodule update --init --recursive\"${NOCOLOR}"
  exit 2
fi

echo -e "${COLOR_INFO}[*] Compiling...${NOCOLOR}"

# compile insert_dylib
if [ ! -f "$INSERT_DYLIB_BIN" ]; then
  xcodebuild -project "$INSERT_DYLIB_PRJ"
  if [ ! -f "$INSERT_DYLIB_BIN" ]; then
    echo -e "${COLOR_ERR}[-] Compiled insert_dylib binary not found.${NOCOLOR}"
    exit 2
  fi
fi

# compile HookParallels
if [ ! -f "$HOOK_PARALLELS_DYLIB" ]; then
  xcodebuild -project "$HOOK_PARALLELS_PRJ"
  if [ ! -f "$HOOK_PARALLELS_DYLIB" ]; then
    echo -e "${COLOR_ERR}[-] Compiled HookMac.dylib not found.${NOCOLOR}"
    exit 2
  fi
fi

# stop prl_disp_service
if pgrep -x "prl_disp_service" &> /dev/null; then
  echo -e "${COLOR_INFO}[*] Stopping Parallels Desktop${NOCOLOR}"
  pkill -9 prl_client_app &>/dev/null
  # ensure prl_disp_service has stopped
  "${PDFM_DIR}/Contents/MacOS/Parallels Service" service_stop &>/dev/null
  sleep 1
  launchctl stop /Library/LaunchDaemons/com.parallels.desktop.launchdaemon.plist &>/dev/null
  sleep 1
  pkill -9 prl_disp_service &>/dev/null
  sleep 1
  rm -f "/var/run/prl_*"
fi

echo -e "${COLOR_INFO}[*] Installing...${NOCOLOR}"

# prepare temp folder and files
if [ ! -d "${TMP_DIR}" ]; then
    mkdir "${TMP_DIR}"
fi

echo -n -e '\x20\x00\x80\xd2\xc0\x03\x5f\xd6' > "${ARM64_RET_1}"
echo -n -e '\x04\x00\x00\x14' > "${ARM64_B_0x10}"
echo -n -e '\x03\x00\x00\x14' > "${ARM64_B_0xC}"

echo -n -e '\xeb\x15' > "${X86_64_JMP_0x17}"
echo -n -e '\xeb\x08' > "${X86_64_JMP_0xA}"
echo -n -e '\x6a\x01\x58\xc3' > "${X86_64_RET_1}"

# patch prl_disp_service
if [ ! -f "${PDFM_DISP_BCUP}" ]; then
    cp "${PDFM_DISP_DST}" "${PDFM_DISP_BCUP}"
fi

chflags -R 0 "${PDFM_DISP_DST}"

# [ ARM64 ]

# arm64 bypass public key loading errors
# 0xDF6928
dd if="${ARM64_B_0x10}" of="${PDFM_DISP_DST}" obs=1 seek=14641448 conv=notrunc

# arm64 partly bypass license info loading errors
# 0xDF696C
dd if="${ARM64_B_0xC}" of="${PDFM_DISP_DST}" obs=1 seek=14641516 conv=notrunc

# arm64 bypass license signature check
# 0x1066D84
dd if="${ARM64_RET_1}" of="${PDFM_DISP_DST}" obs=1 seek=17198468 conv=notrunc

# arm64 bypass binary codesign check
# 0x12366D4
dd if="${ARM64_RET_1}" of="${PDFM_DISP_DST}" obs=1 seek=19097300 conv=notrunc

# [ x86_64 ]

# x86_64 bypass public key loading errors
# 0x33AB95
dd if="${X86_64_JMP_0x17}" of="${PDFM_DISP_DST}" obs=1 seek=3386261 conv=notrunc

# arm64 partly bypass license info loading errors
# 0x33ABDE
dd if="${X86_64_JMP_0xA}" of="${PDFM_DISP_DST}" obs=1 seek=3386334 conv=notrunc

# X86_64 bypass license signature check
# 0x59AF00
dd if="${X86_64_RET_1}" of="${PDFM_DISP_DST}" obs=1 seek=5877504 conv=notrunc

# X86_64 bypass binary codesign check
# 0x7ABE20
dd if="${X86_64_RET_1}" of="${PDFM_DISP_DST}" obs=1 seek=8044064 conv=notrunc

# insert HookParallels dylib
cp "$HOOK_PARALLELS_DYLIB" "$HOOK_PARALLELS_DYLIB_DST"
"$INSERT_DYLIB_BIN" --no-strip-codesig --inplace "$HOOK_PARALLELS_DYLIB_DST" "$PDFM_DISP_DST"

chown root:wheel "${PDFM_DISP_DST}"
chmod 755 "${PDFM_DISP_DST}"
codesign -f -s - --timestamp=none --all-architectures --entitlements "${PDFM_DISP_ENT}" "${PDFM_DISP_DST}"
cp "${PDFM_DISP_DST}" "${PDFM_DISP_PATCH}"

# delete temp folder
rm -rf "${TMP_DIR}"

# install fake license
if [ -f "${LICENSE_DST}" ]; then
  chflags -R 0 "${LICENSE_DST}"
  rm -f "${LICENSE_DST}" > /dev/null
fi
cp -f "${LICENSE_FILE}" "${LICENSE_DST}"
chown root:wheel "${LICENSE_DST}"
chmod 444 "${LICENSE_DST}"
chflags -R 0 "${LICENSE_DST}"
chflags uchg "${LICENSE_DST}"
chflags schg "${LICENSE_DST}"

# start prl_disp_service
if ! pgrep -x "prl_disp_service" &>/dev/null; then
  echo -e "${COLOR_INFO}[*] Starting Parallels Service${NOCOLOR}"
  "${PDFM_DIR}/Contents/MacOS/Parallels Service" service_restart &>/dev/null
  for (( i=0; i < 10; ++i ))
  do
    if pgrep -x "prl_disp_service" &>/dev/null; then
      break
    fi
    sleep 1
  done
  if ! pgrep -x "prl_disp_service" &>/dev/null; then
    echo -e "${COLOR_ERR}[x] Starting Service fail.${NOCOLOR}"
  fi
fi

"${PDFM_DIR}/Contents/MacOS/prlsrvctl" web-portal signout &>/dev/null
"${PDFM_DIR}/Contents/MacOS/prlsrvctl" set --cep off &>/dev/null
"${PDFM_DIR}/Contents/MacOS/prlsrvctl" set --allow-attach-screenshots off &>/dev/null

chown -R "$(id -un)":admin "${PDFM_DISP_DIR}"

echo -e "${COLOR_WARN}⚠ Don't fully quit and reopen Parallels very quickly. It's automatically resetting the crack using hooked functions but this may break it ⚠${NOCOLOR}"
echo -e "${COLOR_WARN}🔧 In case you're crack stops working, reset it using \"reset.command\" 🔧${NOCOLOR}"

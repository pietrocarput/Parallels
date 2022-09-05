#!/bin/bash

CUR_PATH=$(cd "$(dirname $(readlink -f "$0"))" && pwd)
ROOT_PATH=$(cd "${CUR_PATH}/../" && pwd)
PTFM_APP_DIR="/Applications/Parallels Toolbox.app"
PDFM_APP_DIR="/Applications/Parallels Desktop.app"
CRACK_LIB="${ROOT_PATH}/build/libUIWarp.dylib"
CRACK_LIB_DST_NAME="libUIWarp"

CODESIGN_CERT=-

if [ -n "$(security find-identity -v -p codesigning | grep 6E7BDDB56DD3D9C35A1EAFC787040ADF426EE7F2)" ]; then
	CODESIGN_CERT=6E7BDDB56DD3D9C35A1EAFC787040ADF426EE7F2
fi

function sign_cmd() {
	codesign -f -s ${CODESIGN_CERT} --all-architectures --deep "$@"
}

function kill_ptfm_app() {
	killall -9 "Parallels Toolbox" 2> /dev/null
}

function kill_pdfm_app() {
	killall -9 prl_client_app 2> /dev/null
}

function apply_ptfm_crack() {
	echo "[*] Apply patch"

	if [ -f /usr/local/opt/llvm/bin/llvm-strip ]; then
		/usr/local/opt/llvm/bin/llvm-strip -s "${CRACK_LIB}" > /dev/null
	fi

	RPATH="@rpath/${CRACK_LIB_DST_NAME}.dylib"
	DST="${PTFM_APP_DIR}/Contents/Frameworks/${CRACK_LIB_DST_NAME}.dylib"
	LOADER="${PTFM_APP_DIR}/Contents/Frameworks/libLogging.dylib"

	if ! grep -q "${RPATH}" "${LOADER}"; then
		echo "[*] insert_dylib \"${LOADER}\""
		"${CUR_PATH}/insert_dylib" --inplace --overwrite --no-strip-codesig --all-yes \
			"${RPATH}" "${LOADER}" > /dev/null
	fi
	echo "[*] Copy \"${CRACK_LIB}\" to \"${DST}\""
	cp -f -X "${CRACK_LIB}" "${DST}" > /dev/null
}

function apply_pdfm_crack() {
	echo "[*] Apply patch"

	if [ -f /usr/local/opt/llvm/bin/llvm-strip ]; then
		/usr/local/opt/llvm/bin/llvm-strip -s "${CRACK_LIB}" > /dev/null
	fi

	RPATH="@rpath/${CRACK_LIB_DST_NAME}.dylib"
	DST="${PDFM_APP_DIR}/Contents/Frameworks/${CRACK_LIB_DST_NAME}.dylib"
	LOADER="${PDFM_APP_DIR}/Contents/Frameworks/QtXml.framework/Versions/5/QtXml"

	if ! grep -q "${RPATH}" "${LOADER}"; then
		echo "[*] insert_dylib \"${LOADER}\""
		"${CUR_PATH}/insert_dylib" --inplace --overwrite --no-strip-codesig --all-yes \
			"${RPATH}" "${LOADER}" > /dev/null
	fi
	echo "[*] Copy \"${CRACK_LIB}\" to \"${DST}\""
	cp -f -X "${CRACK_LIB}" "${DST}" > /dev/null
}

function sign_ptfm() {
	echo "[*] Sign Parallels Toolbox App"
	sign_cmd "${PTFM_APP_DIR}/Contents/Applications/Airplane Mode.app"
	sign_cmd "${PTFM_APP_DIR}/Contents/Applications/Alarm.app"
	sign_cmd "${PTFM_APP_DIR}/Contents/Applications/Archive.app"
	sign_cmd "${PTFM_APP_DIR}/Contents/Applications/Barcode Generator.app"
	sign_cmd "${PTFM_APP_DIR}/Contents/Applications/Barcode Reader.app"
	sign_cmd "${PTFM_APP_DIR}/Contents/Applications/Break Time.app"
	sign_cmd "${PTFM_APP_DIR}/Contents/Applications/CPU Temperature.app"
	sign_cmd "${PTFM_APP_DIR}/Contents/Applications/Capture Area.app"
	sign_cmd "${PTFM_APP_DIR}/Contents/Applications/Capture Screen.app"
	sign_cmd "${PTFM_APP_DIR}/Contents/Applications/Capture Window.app"
	sign_cmd "${PTFM_APP_DIR}/Contents/Applications/Clean Drive.app"
	sign_cmd "${PTFM_APP_DIR}/Contents/Applications/Clipboard History.app"
	sign_cmd "${PTFM_APP_DIR}/Contents/Applications/Convert Video.app"
	sign_cmd "${PTFM_APP_DIR}/Contents/Applications/Date Countdown.app"
	sign_cmd "${PTFM_APP_DIR}/Contents/Applications/Do Not Disturb.app"
	sign_cmd "${PTFM_APP_DIR}/Contents/Applications/Do Not Sleep.app"
	sign_cmd "${PTFM_APP_DIR}/Contents/Applications/Download Audio.app"
	sign_cmd "${PTFM_APP_DIR}/Contents/Applications/Download Video.app"
	sign_cmd "${PTFM_APP_DIR}/Contents/Applications/Eject Volumes.app"
	sign_cmd "${PTFM_APP_DIR}/Contents/Applications/Encrypt Files.app"
	sign_cmd "${PTFM_APP_DIR}/Contents/Applications/Energy Saver.app"
	sign_cmd "${PTFM_APP_DIR}/Contents/Applications/Find Duplicates.app"
	sign_cmd "${PTFM_APP_DIR}/Contents/Applications/Focus on Window.app"
	sign_cmd "${PTFM_APP_DIR}/Contents/Applications/Free Memory.app"
	sign_cmd "${PTFM_APP_DIR}/Contents/Applications/Hidden Files.app"
	sign_cmd "${PTFM_APP_DIR}/Contents/Applications/Hide Desktop Files.app"
	sign_cmd "${PTFM_APP_DIR}/Contents/Applications/Hide Menu Icons.app"
	sign_cmd "${PTFM_APP_DIR}/Contents/Applications/Launch.app"
	sign_cmd "${PTFM_APP_DIR}/Contents/Applications/Lock Screen.app"
	sign_cmd "${PTFM_APP_DIR}/Contents/Applications/Make GIF.app"
	sign_cmd "${PTFM_APP_DIR}/Contents/Applications/Mute Microphone.app"
	sign_cmd "${PTFM_APP_DIR}/Contents/Applications/Parallels Tool Launcher.app"
	sign_cmd "${PTFM_APP_DIR}/Contents/Applications/Presentation Mode.app"
	sign_cmd "${PTFM_APP_DIR}/Contents/Applications/Recognize Text.app"
	sign_cmd "${PTFM_APP_DIR}/Contents/Applications/Record Area.app"
	sign_cmd "${PTFM_APP_DIR}/Contents/Applications/Record Audio.app"
	sign_cmd "${PTFM_APP_DIR}/Contents/Applications/Record Screen.app"
	sign_cmd "${PTFM_APP_DIR}/Contents/Applications/Record Window.app"
	sign_cmd "${PTFM_APP_DIR}/Contents/Applications/Resize Images.app"
	sign_cmd "${PTFM_APP_DIR}/Contents/Applications/Screenshot Page.app"
	sign_cmd "${PTFM_APP_DIR}/Contents/Applications/Show Desktop.app"
	sign_cmd "${PTFM_APP_DIR}/Contents/Applications/Sleep Timer.app"
	sign_cmd "${PTFM_APP_DIR}/Contents/Applications/Stopwatch.app"
	sign_cmd "${PTFM_APP_DIR}/Contents/Applications/Switch Resolution.app"
	sign_cmd "${PTFM_APP_DIR}/Contents/Applications/Take Photo.app"
	sign_cmd "${PTFM_APP_DIR}/Contents/Applications/Take Video.app"
	sign_cmd "${PTFM_APP_DIR}/Contents/Applications/Timer.app"
	sign_cmd "${PTFM_APP_DIR}/Contents/Applications/Transform Text.app"
	sign_cmd "${PTFM_APP_DIR}/Contents/Applications/Unarchive.app"
	sign_cmd "${PTFM_APP_DIR}/Contents/Applications/Uninstall Apps.app"
	sign_cmd "${PTFM_APP_DIR}/Contents/Applications/Unit Converter.app"
	sign_cmd "${PTFM_APP_DIR}/Contents/Applications/Verify Checksum.app"
	sign_cmd "${PTFM_APP_DIR}/Contents/Applications/Window Manager.app"
	sign_cmd "${PTFM_APP_DIR}/Contents/Applications/World Time.app"
	sign_cmd "${PTFM_APP_DIR}/Parallels Toolbox.app"
}

function sign_pdfm() {
	echo "[*] Sign Parallels Desktop App"
	sign_cmd "${PDFM_APP_DIR}/Contents/Library/QuickLook/ExeQL.qlgenerator"
	sign_cmd "${PDFM_APP_DIR}/Contents/Library/QuickLook/ParallelsQL.qlgenerator"
	sign_cmd "${PDFM_APP_DIR}/Contents/Resources/launchd_wrapper"
	sign_cmd "${PDFM_APP_DIR}/Contents/Resources/libprl_shared_apps.dylib"
	sign_cmd "${PDFM_APP_DIR}/Contents/Resources/lua/ssl.so"
	sign_cmd "${PDFM_APP_DIR}/Contents/Resources/lua/mime/core.so"
	sign_cmd "${PDFM_APP_DIR}/Contents/Resources/lua/socket/core.so"
	sign_cmd "${PDFM_APP_DIR}/Contents/Resources/lua/socket/serial.so"
	sign_cmd "${PDFM_APP_DIR}/Contents/Resources/lua/socket/unix.so"
	sign_cmd "${PDFM_APP_DIR}/Contents/Applications/Parallels Link.app"
	sign_cmd "${PDFM_APP_DIR}/Contents/Applications/Parallels Mounter.app"
	sign_cmd "${PDFM_APP_DIR}/Contents/Applications/Parallels Technical Data Reporter.app"
	sign_cmd --entitlements "${ROOT_PATH}/entitlements/ParallelsDesktop/ParallelsMacVM.entitlements"   "${PDFM_APP_DIR}/Contents/MacOS/Parallels Mac VM.app"
	sign_cmd --entitlements "${ROOT_PATH}/entitlements/ParallelsDesktop/ParallelsService.entitlements" "${PDFM_APP_DIR}/Contents/MacOS/Parallels Service.app"
	sign_cmd --entitlements "${ROOT_PATH}/entitlements/ParallelsDesktop/ParallelsVM1014.entitlements"  "${PDFM_APP_DIR}/Contents/MacOS/Parallels VM 10.14.app"
	sign_cmd --entitlements "${ROOT_PATH}/entitlements/ParallelsDesktop/ParallelsVM.entitlements"      "${PDFM_APP_DIR}/Contents/MacOS/Parallels VM.app"
	sign_cmd --entitlements "${ROOT_PATH}/entitlements/ParallelsDesktop/ParallelsDesktop.entitlements" "${PDFM_APP_DIR}"
}

if [ -d "${PTFM_APP_DIR}" ]; then
	echo "[*] Install Parallels Toolbox patch"
	kill_ptfm_app
	apply_ptfm_crack
	sign_ptfm
else
	echo "[*] not found ${PTFM_APP_DIR}, skip."
fi

if [ -d "${PDFM_APP_DIR}" ]; then
	echo "[*] Install Parallels Desktop patch"
	kill_pdfm_app
	apply_pdfm_crack
	sign_pdfm
else
	echo "[*] not found ${PDFM_APP_DIR}, skip."
fi

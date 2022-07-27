#!/bin/bash

CUR_PATH=$(cd "$(dirname $(readlink -f "$0"))" && pwd)
PT_ROOT_DIR="/Applications/Parallels Toolbox.app"
PD_ROOT_DIR="/Applications/Parallels Desktop.app"
CRACK_LIB="${CUR_DIR}/../build/libConfigurer64.dylib"
# CODESIGN_CERT=B8474E27C322DFB3D4A0168127EB02DB877C3F81
CODESIGN_CERT=-

function sign_cmd() {
	codesign -f -s ${CODESIGN_CERT} --all-architectures --deep "$1"
}

function kill_pt_app() {
	killall -9 "Parallels Toolbox"
}

function kill_pd_app() {
	killall -9 prl_client_app
}

function apply_pt_crack() {

	if [ -f /usr/local/opt/llvm/bin/llvm-strip ]; then
		/usr/local/opt/llvm/bin/llvm-strip -s "${CRACK_LIB}"
	fi

	cp "${CRACK_LIB}" "${PT_ROOT_DIR}/Contents/Frameworks/libConfigurer64.dylib"
	if [ ! -f "${PT_ROOT_DIR}/Contents/Frameworks/libLogging.dylib.bak" ]; then

		cp "${PT_ROOT_DIR}/Contents/Frameworks/libLogging.dylib" "${PT_ROOT_DIR}/Contents/Frameworks/libLogging.dylib.bak"
		"${CUR_DIR}/insert_dylib" --inplace --all-yes \
			"@rpath/libConfigurer64.dylib" \
			"${PT_ROOT_DIR}/Contents/Frameworks/libLogging.dylib"

	fi
}

function apply_pd_crack() {

	if [ -f /usr/local/opt/llvm/bin/llvm-strip ]; then
		/usr/local/opt/llvm/bin/llvm-strip -s "${CRACK_LIB}"
	fi

	cp "${CRACK_LIB}" "${PD_ROOT_DIR}/Contents/Frameworks/libConfigurer64.dylib"
	if [ ! -f "${PD_ROOT_DIR}/Contents/Frameworks/QtXml.framework/Versions/5/QtXml.bak" ]; then

		cp "${PD_ROOT_DIR}/Contents/Frameworks/QtXml.framework/Versions/5/QtXml" "${PD_ROOT_DIR}/Contents/Frameworks/QtXml.framework/Versions/5/QtXml.bak"
		"${CUR_DIR}/insert_dylib" --inplace --all-yes \
			"@rpath/libConfigurer64.dylib" \
			"${PD_ROOT_DIR}/Contents/Frameworks/QtXml.framework/Versions/5/QtXml"	
	fi
}

function sign_pt() {
	sign_cmd "${PT_ROOT_DIR}/Contents/Applications/Airplane Mode.app"
	sign_cmd "${PT_ROOT_DIR}/Contents/Applications/Alarm.app"
	sign_cmd "${PT_ROOT_DIR}/Contents/Applications/Archive.app"
	sign_cmd "${PT_ROOT_DIR}/Contents/Applications/Barcode Generator.app"
	sign_cmd "${PT_ROOT_DIR}/Contents/Applications/Barcode Reader.app"
	sign_cmd "${PT_ROOT_DIR}/Contents/Applications/Break Time.app"
	sign_cmd "${PT_ROOT_DIR}/Contents/Applications/CPU Temperature.app"
	sign_cmd "${PT_ROOT_DIR}/Contents/Applications/Capture Area.app"
	sign_cmd "${PT_ROOT_DIR}/Contents/Applications/Capture Screen.app"
	sign_cmd "${PT_ROOT_DIR}/Contents/Applications/Capture Window.app"
	sign_cmd "${PT_ROOT_DIR}/Contents/Applications/Clean Drive.app"
	sign_cmd "${PT_ROOT_DIR}/Contents/Applications/Clipboard History.app"
	sign_cmd "${PT_ROOT_DIR}/Contents/Applications/Convert Video.app"
	sign_cmd "${PT_ROOT_DIR}/Contents/Applications/Date Countdown.app"
	sign_cmd "${PT_ROOT_DIR}/Contents/Applications/Do Not Disturb.app"
	sign_cmd "${PT_ROOT_DIR}/Contents/Applications/Do Not Sleep.app"
	sign_cmd "${PT_ROOT_DIR}/Contents/Applications/Download Audio.app"
	sign_cmd "${PT_ROOT_DIR}/Contents/Applications/Download Video.app"
	sign_cmd "${PT_ROOT_DIR}/Contents/Applications/Eject Volumes.app"
	sign_cmd "${PT_ROOT_DIR}/Contents/Applications/Encrypt Files.app"
	sign_cmd "${PT_ROOT_DIR}/Contents/Applications/Energy Saver.app"
	sign_cmd "${PT_ROOT_DIR}/Contents/Applications/Find Duplicates.app"
	sign_cmd "${PT_ROOT_DIR}/Contents/Applications/Focus on Window.app"
	sign_cmd "${PT_ROOT_DIR}/Contents/Applications/Free Memory.app"
	sign_cmd "${PT_ROOT_DIR}/Contents/Applications/Hidden Files.app"
	sign_cmd "${PT_ROOT_DIR}/Contents/Applications/Hide Desktop Files.app"
	sign_cmd "${PT_ROOT_DIR}/Contents/Applications/Hide Menu Icons.app"
	sign_cmd "${PT_ROOT_DIR}/Contents/Applications/Launch.app"
	sign_cmd "${PT_ROOT_DIR}/Contents/Applications/Lock Screen.app"
	sign_cmd "${PT_ROOT_DIR}/Contents/Applications/Make GIF.app"
	sign_cmd "${PT_ROOT_DIR}/Contents/Applications/Mute Microphone.app"
	sign_cmd "${PT_ROOT_DIR}/Contents/Applications/Parallels Tool Launcher.app"
	sign_cmd "${PT_ROOT_DIR}/Contents/Applications/Presentation Mode.app"
	sign_cmd "${PT_ROOT_DIR}/Contents/Applications/Recognize Text.app"
	sign_cmd "${PT_ROOT_DIR}/Contents/Applications/Record Area.app"
	sign_cmd "${PT_ROOT_DIR}/Contents/Applications/Record Audio.app"
	sign_cmd "${PT_ROOT_DIR}/Contents/Applications/Record Screen.app"
	sign_cmd "${PT_ROOT_DIR}/Contents/Applications/Record Window.app"
	sign_cmd "${PT_ROOT_DIR}/Contents/Applications/Resize Images.app"
	sign_cmd "${PT_ROOT_DIR}/Contents/Applications/Screenshot Page.app"
	sign_cmd "${PT_ROOT_DIR}/Contents/Applications/Show Desktop.app"
	sign_cmd "${PT_ROOT_DIR}/Contents/Applications/Sleep Timer.app"
	sign_cmd "${PT_ROOT_DIR}/Contents/Applications/Stopwatch.app"
	sign_cmd "${PT_ROOT_DIR}/Contents/Applications/Switch Resolution.app"
	sign_cmd "${PT_ROOT_DIR}/Contents/Applications/Take Photo.app"
	sign_cmd "${PT_ROOT_DIR}/Contents/Applications/Take Video.app"
	sign_cmd "${PT_ROOT_DIR}/Contents/Applications/Timer.app"
	sign_cmd "${PT_ROOT_DIR}/Contents/Applications/Transform Text.app"
	sign_cmd "${PT_ROOT_DIR}/Contents/Applications/Unarchive.app"
	sign_cmd "${PT_ROOT_DIR}/Contents/Applications/Uninstall Apps.app"
	sign_cmd "${PT_ROOT_DIR}/Contents/Applications/Unit Converter.app"
	sign_cmd "${PT_ROOT_DIR}/Contents/Applications/Verify Checksum.app"
	sign_cmd "${PT_ROOT_DIR}/Contents/Applications/Window Manager.app"
	sign_cmd "${PT_ROOT_DIR}/Contents/Applications/World Time.app"
	sign_cmd "${PT_ROOT_DIR}/Parallels Toolbox.app"
}

function sign_pd() {
	sign_cmd "${PD_ROOT_DIR}/Contents/Applications/Parallels Link.app"
	sign_cmd "${PD_ROOT_DIR}/Contents/Applications/Parallels Mounter.app"
	sign_cmd "${PD_ROOT_DIR}/Contents/Applications/Parallels Technical Data Reporter.app"
	sign_cmd "${PD_ROOT_DIR}/Contents/MacOS/Parallels Mac VM.app"
	sign_cmd "${PD_ROOT_DIR}/Contents/MacOS/Parallels Service.app"
	sign_cmd "${PD_ROOT_DIR}/Contents/MacOS/Parallels VM 10.14.app"
	sign_cmd "${PD_ROOT_DIR}/Contents/MacOS/Parallels VM.app"
	sign_cmd "${PD_ROOT_DIR}/Parallels Desktop.app"
}

kill_pt_app
kill_pd_app
apply_pt_crack
apply_pd_crack
sign_pt
sign_pd

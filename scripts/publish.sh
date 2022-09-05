#!/bin/bash

CUR_PATH=$(cd "$(dirname $(readlink -f "$0"))" && pwd)
ROOT_PATH=$(cd "${CUR_PATH}/../" && pwd)
TEMP_PATH="${ROOT_PATH}/tmp"
PUBLISH_PATH="${ROOT_PATH}/publish"

PTFM_VERSION="5.5.1-4410"
PDFM_VERSION="18.0.1-53056"

PTFM_SHA256SUM="412bddebac28e229c7973dad6d702c67d1b42195b99b009af26ef036f5631349"
PDFM_SHA256SUM="8a021158b29b814f2942bb0afa5ca33fc6a87729578d1ad194e95a3f929b1e6f"

PTFM_DMG_DOWNLOAD_URL="https://download.parallels.com/toolbox/v5/${PTFM_VERSION}/ParallelsToolbox-${PTFM_VERSION}.dmg"
PDFM_DMG_DOWNLOAD_URL="https://download.parallels.com/desktop/v18/${PDFM_VERSION}/ParallelsDesktop-${PDFM_VERSION}.dmg"

PTFM_DMG_FILE="${TEMP_PATH}/download/ParallelsToolbox-${PTFM_VERSION}.dmg"
PDFM_DMG_FILE="${TEMP_PATH}/download/ParallelsDesktop-${PDFM_VERSION}.dmg"

PTFM_PUBLISH_FILE="${PUBLISH_PATH}/ParallelsToolbox-${PTFM_VERSION}_Crack.dmg"
PDFM_PUBLISH_FILE="${PUBLISH_PATH}/ParallelsDesktop-${PDFM_VERSION}_Crack.dmg"

CODESIGN_CERT=-

if [ -n "$(security find-identity -v -p codesigning | grep B8474E27C322DFB3D4A0168127EB02DB877C3F81)" ]; then
	CODESIGN_CERT=B8474E27C322DFB3D4A0168127EB02DB877C3F81
fi

CRACK_LIB_DST_NAME="libUIWarp"
CRACK_LIB="${ROOT_PATH}/build/${CRACK_LIB_DST_NAME}.dylib"

PTFM_TMP_DIR="${TEMP_PATH}/ptfm_files"
PDFM_TMP_DIR="${TEMP_PATH}/pdfm_files"

function sign_cmd() {
	codesign -f -s ${CODESIGN_CERT} -o runtime --all-architectures --deep "$@"
}

function ensure_download_ptfm_dmg() {
	if [ -f "${PTFM_DMG_FILE}" ]; then
		echo "[*] Check hash for \"${PTFM_DMG_FILE}\""
		FILE_HASH=$(shasum -a 256 -b "${PTFM_DMG_FILE}" | awk '{print $1}')
		if [ ${FILE_HASH} != ${PTFM_SHA256SUM} ]; then
			echo "[-] ${FILE_HASH} != ${PTFM_SHA256SUM}"
			echo "[*] Delete \"${PTFM_DMG_FILE}\""
			rm -f "${PTFM_DMG_FILE}"
		fi
	fi
	if [ ! -f "${PTFM_DMG_FILE}" ]; then
		echo "[*] Download ${PTFM_DMG_DOWNLOAD_URL}"
		mkdir -p $(dirname "${PTFM_DMG_FILE}")
		curl -L --progress-bar -o "${PTFM_DMG_FILE}" "${PTFM_DMG_DOWNLOAD_URL}"
	fi
}

function ensure_download_pdfm_dmg() {
	if [ -f "${PDFM_DMG_FILE}" ]; then
		echo "[*] Check hash for \"${PDFM_DMG_FILE}\""
		FILE_HASH=$(shasum -a 256 -b "${PDFM_DMG_FILE}" | awk '{print $1}')
		if [ ${FILE_HASH} != ${PDFM_SHA256SUM} ]; then
			echo "[-] ${FILE_HASH} != ${PDFM_SHA256SUM}"
			echo "[*] Delete \"${PDFM_DMG_FILE}\""
			rm -f "${PDFM_DMG_FILE}"
		fi
	fi
	if [ ! -f "${PDFM_DMG_FILE}" ]; then
		echo "[*] Download ${PDFM_DMG_DOWNLOAD_URL}"
		mkdir -p $(dirname "${PDFM_DMG_FILE}")
		curl -L --progress-bar -o "${PDFM_DMG_FILE}" "${PDFM_DMG_DOWNLOAD_URL}"
	fi
}

function copy_ptfm_files() {
	echo "[*] Copy files"
	if [ -d "${PTFM_TMP_DIR}" ]; then
		rm -rf "${PTFM_TMP_DIR}" > /dev/null
	fi
	mkdir -p "${PTFM_TMP_DIR}" > /dev/null

	hdiutil attach -noverify -noautofsck -noautoopen "${PTFM_DMG_FILE}"
	cp -R -X "/Volumes/Parallels Toolbox/Install Parallels Toolbox.app" "${PTFM_TMP_DIR}/" > /dev/null
	hdiutil detach "/Volumes/Parallels Toolbox"

	rm -f "${PTFM_TMP_DIR}/Install Parallels Toolbox.app/Contents/embedded.provisionprofile" > /dev/null
	chflags -R 0 "${PTFM_TMP_DIR}" > /dev/null
	xattr -cr "${PTFM_TMP_DIR}" > /dev/null
}

function copy_pdfm_files() {
	echo "[*] Copy files"
	if [ -d "${PDFM_TMP_DIR}" ]; then
		rm -rf "${PDFM_TMP_DIR}" > /dev/null
	fi
	mkdir -p "${PDFM_TMP_DIR}" > /dev/null

	hdiutil attach -noverify -noautofsck -noautoopen "${PDFM_DMG_FILE}"
	cp -R -X "/Volumes/Parallels Desktop 18/Install.app" "${PDFM_TMP_DIR}/" > /dev/null
	cp -R -X "/Volumes/Parallels Desktop 18/Parallels Desktop.app" "${PDFM_TMP_DIR}/" > /dev/null
	hdiutil detach "/Volumes/Parallels Desktop 18"

	rm -f "${PDFM_TMP_DIR}/Parallels Desktop.app/Contents/embedded.provisionprofile" > /dev/null
	chflags -R 0 "${PDFM_TMP_DIR}" > /dev/null
	xattr -cr "${PDFM_TMP_DIR}" > /dev/null
}

function apply_ptfm_crack() {
	echo "[*] Apply patch"

	if [ -f /usr/local/opt/llvm/bin/llvm-strip ]; then
		/usr/local/opt/llvm/bin/llvm-strip -s "${CRACK_LIB}" > /dev/null
	fi

	RPATH="@rpath/${CRACK_LIB_DST_NAME}.dylib"
	DST="${PTFM_TMP_DIR}/Install Parallels Toolbox.app/Contents/Frameworks/${CRACK_LIB_DST_NAME}.dylib"
	LOADER="${PTFM_TMP_DIR}/Install Parallels Toolbox.app/Contents/Frameworks/libLogging.dylib"

	"${CUR_PATH}/insert_dylib" --inplace --overwrite --no-strip-codesig --all-yes \
		"${RPATH}" "${LOADER}" > /dev/null

	cp -f -X "${CRACK_LIB}" "${DST}" > /dev/null
}

function apply_pdfm_crack() {
	echo "[*] Apply patch"

	if [ -f /usr/local/opt/llvm/bin/llvm-strip ]; then
		/usr/local/opt/llvm/bin/llvm-strip -s "${CRACK_LIB}" > /dev/null
	fi

	RPATH="@rpath/${CRACK_LIB_DST_NAME}.dylib"
	DST="${PDFM_TMP_DIR}/Parallels Desktop.app/Contents/Frameworks/${CRACK_LIB_DST_NAME}.dylib"
	LOADER="${PDFM_TMP_DIR}/Parallels Desktop.app/Contents/Frameworks/QtXml.framework/Versions/5/QtXml"

	"${CUR_PATH}/insert_dylib" --inplace --overwrite --no-strip-codesig --all-yes \
		"${RPATH}" "${LOADER}" > /dev/null

	cp -f -X "${CRACK_LIB}" "${DST}" > /dev/null

	SRC="${ROOT_PATH}/crack/pdfm-18.0.1.53056/prl_client_app"
	DST="${PDFM_TMP_DIR}/Parallels Desktop.app/Contents/MacOS/prl_client_app"
	cp -f -X "${SRC}" "${DST}" > /dev/null

	SRC="${ROOT_PATH}/crack/pdfm-18.0.1.53056/prl_disp_service"
	DST="${PDFM_TMP_DIR}/Parallels Desktop.app/Contents/MacOS/Parallels Service.app/Contents/MacOS/prl_disp_service"
	cp -f -X "${SRC}" "${DST}" > /dev/null
}

function sign_ptfm() {
	echo "[*] Sign Parallels Toolbox App"
	sign_cmd "${PTFM_TMP_DIR}/Install Parallels Toolbox.app/Contents/Library/Install/ToolboxInstaller"
	sign_cmd "${PTFM_TMP_DIR}/Install Parallels Toolbox.app/Contents/Applications/Airplane Mode.app"
	sign_cmd "${PTFM_TMP_DIR}/Install Parallels Toolbox.app/Contents/Applications/Alarm.app"
	sign_cmd "${PTFM_TMP_DIR}/Install Parallels Toolbox.app/Contents/Applications/Archive.app"
	sign_cmd "${PTFM_TMP_DIR}/Install Parallels Toolbox.app/Contents/Applications/Barcode Generator.app"
	sign_cmd "${PTFM_TMP_DIR}/Install Parallels Toolbox.app/Contents/Applications/Barcode Reader.app"
	sign_cmd "${PTFM_TMP_DIR}/Install Parallels Toolbox.app/Contents/Applications/Break Time.app"
	sign_cmd "${PTFM_TMP_DIR}/Install Parallels Toolbox.app/Contents/Applications/CPU Temperature.app"
	sign_cmd "${PTFM_TMP_DIR}/Install Parallels Toolbox.app/Contents/Applications/Capture Area.app"
	sign_cmd "${PTFM_TMP_DIR}/Install Parallels Toolbox.app/Contents/Applications/Capture Screen.app"
	sign_cmd "${PTFM_TMP_DIR}/Install Parallels Toolbox.app/Contents/Applications/Capture Window.app"
	sign_cmd "${PTFM_TMP_DIR}/Install Parallels Toolbox.app/Contents/Applications/Clean Drive.app"
	sign_cmd "${PTFM_TMP_DIR}/Install Parallels Toolbox.app/Contents/Applications/Clipboard History.app"
	sign_cmd "${PTFM_TMP_DIR}/Install Parallels Toolbox.app/Contents/Applications/Convert Video.app"
	sign_cmd "${PTFM_TMP_DIR}/Install Parallels Toolbox.app/Contents/Applications/Date Countdown.app"
	sign_cmd "${PTFM_TMP_DIR}/Install Parallels Toolbox.app/Contents/Applications/Do Not Disturb.app"
	sign_cmd "${PTFM_TMP_DIR}/Install Parallels Toolbox.app/Contents/Applications/Do Not Sleep.app"
	sign_cmd "${PTFM_TMP_DIR}/Install Parallels Toolbox.app/Contents/Applications/Download Audio.app"
	sign_cmd "${PTFM_TMP_DIR}/Install Parallels Toolbox.app/Contents/Applications/Download Video.app"
	sign_cmd "${PTFM_TMP_DIR}/Install Parallels Toolbox.app/Contents/Applications/Eject Volumes.app"
	sign_cmd "${PTFM_TMP_DIR}/Install Parallels Toolbox.app/Contents/Applications/Encrypt Files.app"
	sign_cmd "${PTFM_TMP_DIR}/Install Parallels Toolbox.app/Contents/Applications/Energy Saver.app"
	sign_cmd "${PTFM_TMP_DIR}/Install Parallels Toolbox.app/Contents/Applications/Find Duplicates.app"
	sign_cmd "${PTFM_TMP_DIR}/Install Parallels Toolbox.app/Contents/Applications/Focus on Window.app"
	sign_cmd "${PTFM_TMP_DIR}/Install Parallels Toolbox.app/Contents/Applications/Free Memory.app"
	sign_cmd "${PTFM_TMP_DIR}/Install Parallels Toolbox.app/Contents/Applications/Hidden Files.app"
	sign_cmd "${PTFM_TMP_DIR}/Install Parallels Toolbox.app/Contents/Applications/Hide Desktop Files.app"
	sign_cmd "${PTFM_TMP_DIR}/Install Parallels Toolbox.app/Contents/Applications/Hide Menu Icons.app"
	sign_cmd "${PTFM_TMP_DIR}/Install Parallels Toolbox.app/Contents/Applications/Launch.app"
	sign_cmd "${PTFM_TMP_DIR}/Install Parallels Toolbox.app/Contents/Applications/Lock Screen.app"
	sign_cmd "${PTFM_TMP_DIR}/Install Parallels Toolbox.app/Contents/Applications/Make GIF.app"
	sign_cmd "${PTFM_TMP_DIR}/Install Parallels Toolbox.app/Contents/Applications/Mute Microphone.app"
	sign_cmd "${PTFM_TMP_DIR}/Install Parallels Toolbox.app/Contents/Applications/Parallels Tool Launcher.app"
	sign_cmd "${PTFM_TMP_DIR}/Install Parallels Toolbox.app/Contents/Applications/Presentation Mode.app"
	sign_cmd "${PTFM_TMP_DIR}/Install Parallels Toolbox.app/Contents/Applications/Recognize Text.app"
	sign_cmd "${PTFM_TMP_DIR}/Install Parallels Toolbox.app/Contents/Applications/Record Area.app"
	sign_cmd "${PTFM_TMP_DIR}/Install Parallels Toolbox.app/Contents/Applications/Record Audio.app"
	sign_cmd "${PTFM_TMP_DIR}/Install Parallels Toolbox.app/Contents/Applications/Record Screen.app"
	sign_cmd "${PTFM_TMP_DIR}/Install Parallels Toolbox.app/Contents/Applications/Record Window.app"
	sign_cmd "${PTFM_TMP_DIR}/Install Parallels Toolbox.app/Contents/Applications/Resize Images.app"
	sign_cmd "${PTFM_TMP_DIR}/Install Parallels Toolbox.app/Contents/Applications/Screenshot Page.app"
	sign_cmd "${PTFM_TMP_DIR}/Install Parallels Toolbox.app/Contents/Applications/Show Desktop.app"
	sign_cmd "${PTFM_TMP_DIR}/Install Parallels Toolbox.app/Contents/Applications/Sleep Timer.app"
	sign_cmd "${PTFM_TMP_DIR}/Install Parallels Toolbox.app/Contents/Applications/Stopwatch.app"
	sign_cmd "${PTFM_TMP_DIR}/Install Parallels Toolbox.app/Contents/Applications/Switch Resolution.app"
	sign_cmd "${PTFM_TMP_DIR}/Install Parallels Toolbox.app/Contents/Applications/Take Photo.app"
	sign_cmd "${PTFM_TMP_DIR}/Install Parallels Toolbox.app/Contents/Applications/Take Video.app"
	sign_cmd "${PTFM_TMP_DIR}/Install Parallels Toolbox.app/Contents/Applications/Timer.app"
	sign_cmd "${PTFM_TMP_DIR}/Install Parallels Toolbox.app/Contents/Applications/Transform Text.app"
	sign_cmd "${PTFM_TMP_DIR}/Install Parallels Toolbox.app/Contents/Applications/Unarchive.app"
	sign_cmd "${PTFM_TMP_DIR}/Install Parallels Toolbox.app/Contents/Applications/Uninstall Apps.app"
	sign_cmd "${PTFM_TMP_DIR}/Install Parallels Toolbox.app/Contents/Applications/Unit Converter.app"
	sign_cmd "${PTFM_TMP_DIR}/Install Parallels Toolbox.app/Contents/Applications/Verify Checksum.app"
	sign_cmd "${PTFM_TMP_DIR}/Install Parallels Toolbox.app/Contents/Applications/Window Manager.app"
	sign_cmd "${PTFM_TMP_DIR}/Install Parallels Toolbox.app/Contents/Applications/World Time.app"
	sign_cmd "${PTFM_TMP_DIR}/Install Parallels Toolbox.app"
}

function sign_pdfm() {
	echo "[*] Sign Parallels Desktop App"
	sign_cmd "${PDFM_TMP_DIR}/Parallels Desktop.app/Contents/Library/QuickLook/ExeQL.qlgenerator"
	sign_cmd "${PDFM_TMP_DIR}/Parallels Desktop.app/Contents/Library/QuickLook/ParallelsQL.qlgenerator"
	sign_cmd "${PDFM_TMP_DIR}/Parallels Desktop.app/Contents/Resources/launchd_wrapper"
	sign_cmd "${PDFM_TMP_DIR}/Parallels Desktop.app/Contents/Resources/libprl_shared_apps.dylib"
	sign_cmd "${PDFM_TMP_DIR}/Parallels Desktop.app/Contents/Resources/lua/ssl.so"
	sign_cmd "${PDFM_TMP_DIR}/Parallels Desktop.app/Contents/Resources/lua/mime/core.so"
	sign_cmd "${PDFM_TMP_DIR}/Parallels Desktop.app/Contents/Resources/lua/socket/core.so"
	sign_cmd "${PDFM_TMP_DIR}/Parallels Desktop.app/Contents/Resources/lua/socket/serial.so"
	sign_cmd "${PDFM_TMP_DIR}/Parallels Desktop.app/Contents/Resources/lua/socket/unix.so"
	sign_cmd "${PDFM_TMP_DIR}/Parallels Desktop.app/Contents/Applications/Parallels Link.app"
	sign_cmd "${PDFM_TMP_DIR}/Parallels Desktop.app/Contents/Applications/Parallels Mounter.app"
	sign_cmd "${PDFM_TMP_DIR}/Parallels Desktop.app/Contents/Applications/Parallels Technical Data Reporter.app"
	sign_cmd --entitlements "${ROOT_PATH}/entitlements/ParallelsDesktop/ParallelsMacVM.entitlements"   "${PDFM_TMP_DIR}/Parallels Desktop.app/Contents/MacOS/Parallels Mac VM.app"
	sign_cmd --entitlements "${ROOT_PATH}/entitlements/ParallelsDesktop/ParallelsService.entitlements" "${PDFM_TMP_DIR}/Parallels Desktop.app/Contents/MacOS/Parallels Service.app"
	sign_cmd --entitlements "${ROOT_PATH}/entitlements/ParallelsDesktop/ParallelsVM1014.entitlements"  "${PDFM_TMP_DIR}/Parallels Desktop.app/Contents/MacOS/Parallels VM 10.14.app"
	sign_cmd --entitlements "${ROOT_PATH}/entitlements/ParallelsDesktop/ParallelsVM.entitlements"      "${PDFM_TMP_DIR}/Parallels Desktop.app/Contents/MacOS/Parallels VM.app"
	sign_cmd --entitlements "${ROOT_PATH}/entitlements/ParallelsDesktop/ParallelsDesktop.entitlements" "${PDFM_TMP_DIR}/Parallels Desktop.app"
	sign_cmd --entitlements "${ROOT_PATH}/entitlements/ParallelsDesktop/ParallelsDesktop.entitlements" "${PDFM_TMP_DIR}/Parallels Desktop.app"
	sign_cmd "${PDFM_TMP_DIR}/Install.app"
}

function set_pdfm_app_hide() {
	chflags hidden "${PDFM_TMP_DIR}/Parallels Desktop.app" > /dev/null
}

function create_ptfm_dmg() {
	echo "[*] Create dmg ${PTFM_PUBLISH_FILE}"
	mkdir -p "${PUBLISH_PATH}"

	if [ -f "${PTFM_PUBLISH_FILE}" ]; then
		rm -f "${PTFM_PUBLISH_FILE}" > /dev/null
	fi

	create-dmg \
		--volname "Parallels Toolbox" \
		--volicon "${ROOT_PATH}/assets/PTFM.VolumeIcon.icns" \
		--background "${ROOT_PATH}/assets/PTFM.background.png" \
		--window-pos 0 0 \
		--window-size 640 415 \
		--icon-size 256 \
		--icon "Install Parallels Toolbox.app" 450 126 \
		--codesign ${CODESIGN_CERT} \
		"${PTFM_PUBLISH_FILE}" \
		"${PTFM_TMP_DIR}/"
}

function create_pdfm_dmg() {
	echo "[*] Create dmg ${PDFM_PUBLISH_FILE}"
	mkdir -p "${PUBLISH_PATH}"

	if [ -f "${PDFM_PUBLISH_FILE}" ]; then
		rm -f "${PDFM_PUBLISH_FILE}" > /dev/null
	fi

	create-dmg \
		--volname "Parallels Desktop 18" \
		--volicon "${ROOT_PATH}/assets/PDFM.VolumeIcon.icns" \
		--background "${ROOT_PATH}/assets/PDFM.background.png" \
		--window-pos 0 0 \
		--window-size 640 415 \
		--icon-size 256 \
		--icon "Install.app" 450 126 \
		--codesign ${CODESIGN_CERT} \
		"${PDFM_PUBLISH_FILE}" \
		"${PDFM_TMP_DIR}/"
}

function publish_ptfm_crack_dmg() {
	ensure_download_ptfm_dmg
	copy_ptfm_files
	apply_ptfm_crack
	sign_ptfm
	create_ptfm_dmg
}

function publish_pdfm_crack_dmg() {
	ensure_download_pdfm_dmg
	copy_pdfm_files
	apply_pdfm_crack
	sign_pdfm
	set_pdfm_app_hide
	create_pdfm_dmg
}

# publish_ptfm_crack_dmg
publish_pdfm_crack_dmg

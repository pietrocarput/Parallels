#!/bin/sh

codesign -d --entitlements - --xml "/Volumes/Parallels Desktop 18/Parallels Desktop.app/Contents/MacOS/Parallels Mac VM.app" 2>/dev/null | plutil -convert xml1 -o - - > ParallelsMacVM.entitlements
codesign -d --entitlements - --xml "/Volumes/Parallels Desktop 18/Parallels Desktop.app/Contents/MacOS/Parallels Service.app" 2>/dev/null | plutil -convert xml1 -o - - > ParallelsService.entitlements
codesign -d --entitlements - --xml "/Volumes/Parallels Desktop 18/Parallels Desktop.app/Contents/MacOS/Parallels VM 10.14.app" 2>/dev/null | plutil -convert xml1 -o - - > ParallelsVM1014.entitlements
codesign -d --entitlements - --xml "/Volumes/Parallels Desktop 18/Parallels Desktop.app/Contents/MacOS/Parallels VM.app" 2>/dev/null | plutil -convert xml1 -o - - > ParallelsVM.entitlements
codesign -d --entitlements - --xml "/Volumes/Parallels Desktop 18/Parallels Desktop.app" 2>/dev/null | plutil -convert xml1 -o - - > ParallelsDesktop.entitlements

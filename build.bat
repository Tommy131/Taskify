@echo off
title Taskify Application Builder

set WINDOWS_BUILD_PATH=build\windows\x64\runner\Release\
set ANDROID_BUILD_PATH=build\app\outputs\apk\release\

cls
flutter build windows --release && flutter build apk --release && start %WINDOWS_BUILD_PATH% && start %ANDROID_BUILD_PATH%

pause
exit
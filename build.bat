@echo off
title Application Builder

cls
flutter build windows
start build\windows\x64\runner\Release\

flutter build apk 
start build\app\outputs\apk\release\


pause
exit
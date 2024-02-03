@echo off
title Application Builder

cls
flutter build windows && flutter build apk && start build\windows\x64\runner\Release\ && start build\app\outputs\apk\release\



pause
exit
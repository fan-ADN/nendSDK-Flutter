#!/bin/sh

if [ $# -ne 1 ]; then
    DEVICENAME=""
else
    DEVICENAME="$1"
fi

function flutterUITest() {
    if [ -n "${DEVICENAME}" ]; then
        flutter drive --target=test_driver/$1.dart -d ${DEVICENAME}
    else
        flutter drive --target=test_driver/$1.dart
    fi
}

# 使い方
# $ ./integration_test.sh [引数]
# -> 引数にデバイス名を指定すると指定したデバイスでのテストを試みます。

# Video
flutterUITest integration_video # flutter drive --target=test_driver/integration_video.dart

# Banner
flutterUITest integration_banner # flutter drive --target=test_driver/integration_banner.dart
flutterUITest integration_adjust_banner # flutter drive --target=test_driver/integration_adjust_banner.dart

# # Interstitial
flutterUITest integration_interstitial # flutter drive --target=test_driver/integration_interstitial.dart

# # Native Ad
flutterUITest integration_native_simple # flutter drive --target=test_driver/integration_native_simple.dart
flutterUITest integration_native_positioned # flutter drive --target=test_driver/integration_native_positioned.dart

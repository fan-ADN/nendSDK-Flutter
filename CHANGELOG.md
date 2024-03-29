## 2.0.2
- Bump up nendSDK_iOS to 8.2.0.
- Bump up nendSDK_Android to 10.0.0.

## 2.0.1
- Bump up nendSDK_iOS to 8.1.0.

## 2.0.0
- Bump up nendSDK_iOS to 8.0.1.
- Bump up nendSDK_Android to 9.0.1.
- Removed UserID, UserFeature on video ads.
  - Removed method
    - video.dart
        - userId(String value)
        - userFeature(UserFeature feature)
  - Removed class
    - UserFeature
      - gender
      - age
      - setBirthday(int year, int month, int day)
      - customBooleanParams['booleanParamKey']
      - customStringParams['stringParamKey']
      - customIntegerParams['integerParamKey']
      - customDoubleParams['doubleParamKey']

## 1.0.5
- Update Environment Flutter SDK version
- Bugfix: Not calling `onReceived()` when an ad loaded.

## 1.0.4
- Bump up nendSDK_iOS to 7.4.0.
- Bump up nendSDK_Android to 9.0.0.

## 1.0.3
- Bump up nendSDK_iOS to 7.3.0.

## 1.0.2
- Bump up nendSDK_iOS to 7.2.0.
- Bump up nendSDK_Android to 8.1.0.

## 1.0.1
- Bump up nendSDK_iOS to 7.1.0.

## 1.0.0
- Added support for null-safety.
- BannerAd, InterstitialAd, and VideoAd have been reimplemented.
  - **The previous interface cannot be used and needs to be implemented again.**
- NativeAd has been removed.

## 0.0.4

- Update Android module dependencies

## 0.0.3

- Added support for native ad
- Update Environment Flutter SDK version

## 0.0.2

- Update Environment Flutter SDK version

## 0.0.1

- Initial version

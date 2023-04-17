//
//  AdBridger.swift
//  nend_plugin
//
//

import UIKit
import Flutter

class AdBridger: NSObject {

    var channel: FlutterMethodChannel!

    var rootViewController: UIViewController? {
        return UIApplication.shared.keyWindow?.rootViewController
    }

    func adUnit(argument: Any?) -> AdUnit {
        let jsonData = try! JSONSerialization.data(withJSONObject: argument!, options: [])
        return try! JSONDecoder().decode(AdUnit.self, from: jsonData)
    }

    func invokeMethod(_ method: CallbackName, arguments: [String: Any?]?) {
        self.channel.invokeMethod(method.rawValue, arguments: arguments)
    }

    func targetMethod(_ method: String) -> MethodName {
        return MethodName(rawValue: method) ?? MethodName.notFound
    }

    enum MethodName: String {
        case loadAd,
        releaseAd,
        showAd,
        hideAd,
        // Common definitions are above here.

        resume,
        pause,

        isReady,
        mediationName,
        addFallbackFullboard,
        enableAutoReload,
        dismissAd,
        muteStartPlaying,

        // Specific definitions are above here.
        initAd,
        setLogLevel,
        notFound
    }

    enum CallbackName: String {
        case onLoaded,
        onFailedToLoad,
        onAdClicked,
        onInformationClicked,
        // Common definitions are above here.

        onFailedToPlay,
        onShown,
        onClosed,
        onStarted,
        onStopped,
        onCompleted,
        onRewarded,
        onFailedToShow,
        onReceiveAd,
        onDetectedVideoType,
        // Specific definitions are above here.
        notFound
    }
}

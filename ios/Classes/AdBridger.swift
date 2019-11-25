//
//  AdBridger.swift
//  nend_plugin
//
//

import UIKit
import Flutter

class AdBridger: NSObject {
    let KEY_ERROR_CODE = "errorCode"
    
    let targetName: String
    let mappingId: String
    let channel: FlutterMethodChannel

    var rootViewController: UIViewController {
        return UIApplication.shared.delegate!.window!!.rootViewController!
    }
    
    class func adUnit(from argument: Any?) -> AdUnitCodable {
        let jsonData = try! JSONSerialization.data(withJSONObject: argument!, options: [])
        return try! JSONDecoder().decode(AdUnitCodable.self, from: jsonData)
    }
    
    static func frame(from argument: Any?) -> FrameCodable {
        let jsonData = try! JSONSerialization.data(withJSONObject: argument!, options: [])
        return try! JSONDecoder().decode(FrameCodable.self, from: jsonData)
    }
    
    init(with channel: FlutterMethodChannel, tag: SwiftNendPlugin.ClassNameTag, mappingId: String) {
        self.channel = channel
        self.targetName = tag.rawValue
        self.mappingId = mappingId
    }
    
    func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        result(FlutterMethodNotImplemented)
    }
    
    func targetMethod(from: FlutterMethodCall) -> MethodName {
        guard let methodName = MethodName(rawValue: SwiftNendPlugin.targetFunc(method: from.method, className: targetName)) else {
            return MethodName.notFound
        }
        return methodName
    }
    
    func invokeDelegates(event: CallbackName, args: [String: Any]?) {
        channel.invokeMethod(targetName + "." + event.rawValue, arguments: mappingArguments(mappingId: mappingId, args: args))
    }
    
    private func mappingArguments(mappingId: String, args: [String: Any]?) -> [String: Any]? {
        guard var args = args else {
            return [SwiftNendPlugin.KEY_MAPPING_ID: mappingId]
        }
        guard args[SwiftNendPlugin.KEY_MAPPING_ID] == nil else {
            assertionFailure("\(SwiftNendPlugin.KEY_MAPPING_ID) is reserved key for mapping arguments...")
            return nil
        }
        args[SwiftNendPlugin.KEY_MAPPING_ID] = mappingId
        
        return args
    }

    enum MethodName: String {
        case loadAd,
        releaseAd,
        showAd,
        hideAd,
        layout,
        // Common definitions are above here.
        
        resume,
        pause,
        
        isReady,
        mediationName,
        userId,
        userFeature,
        locationEnabled,
        addFallbackFullboard,
        isEnableAutoReload,
        enableAutoReload,
        disableAutoReload,
        dismissAd,
        muteStartPlaying,
        
        performAdClick,
        performInformationClick,
        activate,
        // Specific definitions are above here.
        
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
        // Specific definitions are above here.
        
        notFound
    }
}

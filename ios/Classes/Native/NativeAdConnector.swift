//
//  NativeAdConnector.swift
//  nend_plugin
//
//

import UIKit
import NendAd

class NativeAdConnector: AdBridger {
    private let adConnector : NADNative

    init(with param: NADNative, channel: FlutterMethodChannel) {
        adConnector = param
        super.init(with: channel, tag: .nativeAdConnector, mappingId: String(adConnector.hash))
    }
    
    override func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let target = targetMethod(from: call)
        switch target {
        case .activate:
            performInternal(methodName: "sendImpression")
        case .performAdClick: fallthrough
        case .performInformationClick:
            performInternal(methodName: target.rawValue)
        default:
            super.handle(call, result: result)
            return
        }
        result(true)
    }
    
    private func performInternal(methodName: String) {
        let selector = NSSelectorFromString(methodName)
        if adConnector.responds(to: selector) {
            adConnector.perform(selector)
        } else {
            print("Not found \(selector)")
        }
    }
}

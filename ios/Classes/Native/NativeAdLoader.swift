//
//  NativeAdLoader.swift
//  nend_plugin
//
//

import UIKit
import NendAd

class NativeAdLoader: AdBridger {
    var onConnect: ((NADNative, String) -> Void)?
    
    private let client : NADNativeClient
    private var loadCompletion : NADNativeCompletionBlock!
    
    init(with param: AdUnitCodable, channel: FlutterMethodChannel) {
        client = NADNativeClient(spotId: String(param.adUnit.spotId), apiKey: param.adUnit.apiKey)
        super.init(with: channel, tag: .nativeAdLoader, mappingId: param.mappingId)
        loadCompletion = { (ad: NADNative?, error: Error?)  in
            guard let ad = ad, error == nil else {
                self.invokeDelegates(event: .onFailedToLoad, args: [self.KEY_ERROR_CODE: (error != nil ? error!._code : kNADNativeErrorCodeInvalidResponseType)])
                return
            }
            let hashCode = String(ad.hash)
            self.onConnect?(ad, hashCode)
            let bridgingAd = ["nativeAd": [
                "titleText": ad.shortText,
                "contentText": ad.longText,
                "promotionName": ad.promotionName,
                "promotionUrl": ad.promotionUrl,
                "adImageUrl": ad.imageUrl,
                "logoImageUrl": ad.logoUrl,
                "actionButtonText": ad.actionButtonText,
                "hashCode" : hashCode]
            ]
            self.invokeDelegates(event: .onLoaded, args: bridgingAd)
        }
    }
    
    override func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch targetMethod(from: call) {
        case .disableAutoReload:
            client.disableAutoReload()
        case .enableAutoReload:
            if let intervalMillis = NativeAdLoader.adUnit(from: call.arguments).intervalMillis {
                client.enableAutoReload(withInterval: TimeInterval(intervalMillis / 1000), completionBlock: loadCompletion)
                break
            }
            fallthrough
        case .loadAd:
            client.load(completionBlock: loadCompletion)
        default:
            super.handle(call, result: result)
            return
        }
        result(true)
    }
    
    class func adUnit(from argument: Any?) -> NativeAdUnitCodable {
        let jsonData = try! JSONSerialization.data(withJSONObject: argument!, options: [])
        return try! JSONDecoder().decode(NativeAdUnitCodable.self, from: jsonData)
    }
    
}

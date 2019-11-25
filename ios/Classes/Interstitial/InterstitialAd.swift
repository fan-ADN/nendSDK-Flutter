//
//  InterstitialAd.swift
//  nend_plugin
//
//

import UIKit
import Flutter
import NendAd

class InterstitialAd: AdBridger,
    NADInterstitialDelegate
{
    let KEY_SPOT_ID = "spotId"
    var lastLoadedSpotId = 0
    let defaultSpotId = -1
    
    enum InterstitialStatusCode: Int {
        case success = 0,
        invalidResponseType,
        failedAdRequest,
        failedAdDownload = 4,
        max
    }
    
    init(with param: InterstitialCodable, channel: FlutterMethodChannel) {
        super.init(with: channel, tag: .interstitial, mappingId: param.mappingId)
        NADInterstitial.sharedInstance().delegate = self
    }
    
    override func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch targetMethod(from: call) {
        case .loadAd:
            let adUnit = AdBridger.adUnit(from: call.arguments)
            lastLoadedSpotId = adUnit.adUnit.spotId
            NADInterstitial.sharedInstance().loadAd(withApiKey: adUnit.adUnit.apiKey, spotId: String(adUnit.adUnit.spotId))
        case .showAd:
            let spotId = InterstitialAd.adUnit(from: call.arguments).spotId == defaultSpotId ? lastLoadedSpotId : InterstitialAd.adUnit(from: call.arguments).spotId!
            let showResult = (NADInterstitial.sharedInstance().showAd(from: rootViewController, spotId: String(spotId)))
            switch showResult {
            case .AD_SHOW_SUCCESS:
                invokeDelegates(event: .onShown, args: [KEY_SPOT_ID : String(spotId)])
            default:
                invokeDelegates(event: .onFailedToShow, args: [KEY_ERROR_CODE : showResult.rawValue, KEY_SPOT_ID : String(spotId)])
            }
        case .dismissAd:
            NADInterstitial.sharedInstance().dismissAd()
        case .isEnableAutoReload:
            NADInterstitial.sharedInstance().enableAutoReload = InterstitialAd.adUnit(from: call.arguments).enableAutoReload!
        default:
            super.handle(call, result: result)
            return
        }
        result(true)
    }
    
    class func adUnit(from argument: Any?) -> InterstitialCodable {
        let jsonData = try! JSONSerialization.data(withJSONObject: argument!, options: [])
        return try! JSONDecoder().decode(InterstitialCodable.self, from: jsonData)
    }
    
    func didClick(with type: NADInterstitialClickType, spotId: String!) {
        switch type {
        case .DOWNLOAD:
            invokeDelegates(event: .onAdClicked, args: [KEY_SPOT_ID : String(spotId)])
        case .INFORMATION:
            invokeDelegates(event: .onInformationClicked, args: [KEY_SPOT_ID : String(spotId)])
        case .CLOSE:
            invokeDelegates(event: .onClosed, args: [KEY_SPOT_ID : String(spotId)])
        }
    }
    
    func didFinishLoadInterstitialAd(withStatus status: NADInterstitialStatusCode, spotId: String!) {
        var errorCode: InterstitialStatusCode
        switch status {
        case .SUCCESS:
            invokeDelegates(event: .onLoaded, args: [KEY_SPOT_ID : String(spotId)])
            return
        case .INVALID_RESPONSE_TYPE:
            errorCode = .invalidResponseType
        case .FAILED_AD_REQUEST:
            errorCode = .failedAdRequest
        case .FAILED_AD_DOWNLOAD:
            errorCode = .failedAdDownload
        default:
            errorCode = .failedAdRequest
        }
        invokeDelegates(event: .onFailedToLoad, args: [KEY_ERROR_CODE : String(errorCode.rawValue) , KEY_SPOT_ID : String(spotId)])
    }
}

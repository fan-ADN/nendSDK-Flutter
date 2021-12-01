//
//  InterstitialAd.swift
//  nend_plugin
//
//

import UIKit
import Flutter
import NendAd

class InterstitialAd:
    AdBridger,
    NADInterstitialLoadingDelegate,
    NADInterstitialClickDelegate,
    FlutterPlugin
{
    private var registrar: FlutterPluginRegistrar!
    
    override init() {
        super.init()
        NADInterstitial.sharedInstance().clickDelegate = self
        NADInterstitial.sharedInstance().loadingDelegate = self
    }
    
    static func register(with registrar: FlutterPluginRegistrar) {
        let instance = InterstitialAd()
        instance.registrar = registrar
        
        instance.channel = FlutterMethodChannel(
            name: "nend_plugin/interstitial",
            binaryMessenger: registrar.messenger(),
            codec: FlutterJSONMethodCodec.sharedInstance()
        )
        instance.channel.setMethodCallHandler({
            (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            instance.handle(call, result: result)
        })
        registrar.addMethodCallDelegate(instance, channel: instance.channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch targetMethod(call.method) {
            case .showAd:
                showAd(arguments: call.arguments)
            case .loadAd:
                loadAd(arguments: call.arguments)
            case .dismissAd:
                dismissAd()
            case .enableAutoReload:
                enableAutoReload(arguments: call.arguments)
            default:
                return
        }
        result(true)
    }
    
    private func loadAd(arguments: Any?) {
        let adUnit = self.adUnit(argument: arguments)
        let spotId = adUnit.spotId
        let apiKey = adUnit.apiKey
        
        NADInterstitial.sharedInstance().loadAd(withSpotID: spotId, apiKey: apiKey)
    }
    
    private func showAd(arguments: Any?) {
        guard let rootViewController = self.rootViewController else { return }
        let codable = interstitialCodable(argument: arguments)
        guard let spotId = codable.spotId else { return }
        let showResult = NADInterstitial.sharedInstance().showAd(from: rootViewController, spotID: spotId)
        var result: String?
        switch showResult {
            case .AD_SHOW_SUCCESS:
                self.invokeMethod(CallbackName.onShown, arguments: ["result": "AD SHOW SUCCESS"])
            case .AD_SHOW_ALREADY:
                result = "AD SHOW ALREADY"
            case .AD_LOAD_INCOMPLETE:
                result = "AD LOAD INCOMPLETE"
            case .AD_REQUEST_INCOMPLETE:
                result = "AD REQUEST INCOMPLETE"
            case .AD_DOWNLOAD_INCOMPLETE:
                result = "AD DOWNLOAD INCOMPLETE"
            case .AD_FREQUENCY_NOT_REACHABLE:
                result = "AD FREQUENCY NOT REACHABLE"
            case .AD_CANNOT_DISPLAY:
                result = "AD CANNOT DISPLAY"
        }
        
        if result != nil {
            self.invokeMethod(CallbackName.onFailedToShow, arguments: ["result": result])
        }
    }
    
    private func dismissAd() {
        NADInterstitial.sharedInstance().dismissAd()
    }
    
    private func enableAutoReload(arguments: Any?) {
        let codable = interstitialCodable(argument: arguments)
        NADInterstitial.sharedInstance().enableAutoReload = codable.enableAutoReload ?? true
    }
    
    private func interstitialCodable(argument: Any?) -> InterstitialCodable {
        let jsonData = try! JSONSerialization.data(withJSONObject: argument!, options: [])
        return try! JSONDecoder().decode(InterstitialCodable.self, from: jsonData)
    }
    
    func didFinishLoadInterstitialAd(withStatus status: NADInterstitialStatusCode) {
        var result: String?
        switch status {
            case .SUCCESS:
                self.invokeMethod(.onLoaded, arguments: ["result": "LOAD AD SUCCESS"])
            case .INVALID_RESPONSE_TYPE:
                result = "INVALID RESPONSE TYPE"
            case .FAILED_AD_REQUEST:
                result = "FAILED AD REQUEST"
            case .FAILED_AD_DOWNLOAD:
                result = "FAILED AD DOWNLOAD"
            default:
                result = "FAILED AD REQUEST"
        }
        if result != nil {
            self.invokeMethod(.onFailedToLoad, arguments: ["result": result])
        }
    }
    
    func didClick(with type: NADInterstitialClickType) {
        switch type {
            case .DOWNLOAD:
                self.invokeMethod(.onAdClicked, arguments: nil)
            case .INFORMATION:
                self.invokeMethod(.onInformationClicked, arguments: nil)
            case .CLOSE:
                self.invokeMethod(.onClosed, arguments: nil)
        }
    }
}

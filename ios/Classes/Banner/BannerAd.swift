//
//  BannerAd.swift
//  nend_plugin
//
//

import UIKit
import Flutter
import NendAd

class BannerAd:
    UIView,
    NADViewDelegate,
    FlutterPlatformView
{
    private var banner: NADView!
    private var channel: FlutterMethodChannel!
    
    init(frame: CGRect, arguments: Any?, viewId: Int64, messenger: FlutterBinaryMessenger) {
        super.init(frame: frame)
        
        self.channel = FlutterMethodChannel(name: "nend_plugin/banner/\(viewId)", binaryMessenger: messenger, codec: FlutterJSONMethodCodec.sharedInstance())
        self.channel.setMethodCallHandler({
            [weak self]
            (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            if let this = self {
                this.handle(call, result: result)
            }
        })
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch AdBridger().targetMethod(call.method) {
            case .showAd: showAd()
            case .hideAd: hideAd()
            case .loadAd: loadAd(arguments: call.arguments)
            case .resume: banner.resume()
            case .pause : banner.pause()
            case .releaseAd: releaseAd()
            default:
                return
        }
        result(true)
    }

    func view() -> UIView {
        return self
    }
    
    func bannerAdUnitCodable(from argument: Any?) -> BannerAdUnitCodable {
        let jsonData = try! JSONSerialization.data(withJSONObject: argument!, options: [])
        return try! JSONDecoder().decode(BannerAdUnitCodable.self, from: jsonData)
    }
    
    private func loadAd(arguments: Any?) {
        if (banner != nil) {
            releaseAd()
        }
        let codable = bannerAdUnitCodable(from: arguments)
        let spotId = codable.adUnit.spotId
        let apiKey = codable.adUnit.apiKey
        
        banner = NADView.init(frame: frame, isAdjustAdSize: codable.adjustSize)
        banner.setNendID(spotId, apiKey: apiKey)
        
        banner.delegate = self
        banner.load()
    }
    
    private func showAd() {
        self.view().addSubview(banner)
        banner.resume()
    }
    
    private func hideAd() {
        banner.pause()
        banner.removeFromSuperview()
    }
    
    private func releaseAd() {
        hideAd()
        banner = nil
    }
    
    func invokeMethod(_ method: AdBridger.CallbackName, arguments: [String: Any?]?) {
        self.channel.invokeMethod(method.rawValue, arguments: arguments)
    }
    
    //MARK: - NADViewDelegate
    
    func nadViewDidFinishLoad(_ adView: NADView!) {
        self.invokeMethod(.onLoaded, arguments: nil)
    }

    func nadViewDidReceiveAd(_ adView: NADView!) {
        self.invokeMethod(.onReceiveAd, arguments: nil)
    }

    func nadViewDidFail(toReceiveAd adView: NADView!) {
        print("error code: \(String(describing: NADViewErrorCode(rawValue: adView.error._code)))")
        self.invokeMethod(.onFailedToLoad, arguments: nil)
    }

    func nadViewDidClickAd(_ adView: NADView!) {
        self.invokeMethod(.onAdClicked, arguments: nil)
    }

    func nadViewDidClickInformation(_ adView: NADView!) {
        self.invokeMethod(.onInformationClicked, arguments: nil)
    }
}

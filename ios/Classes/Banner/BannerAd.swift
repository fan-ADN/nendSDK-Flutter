//
//  NendAdView.swift
//  nend_plugin
//
//

import UIKit
import Flutter
import NendAd

class BannerAd: AdBridger,
    NADViewDelegate
{
    private let banner: NADView
    
    init(with param: BannerAdUnitCodable, channel: FlutterMethodChannel) {
        banner = NADView(isAdjustAdSize: param.adjustSize)
        banner.setNendID(param.adUnit.apiKey, spotID: String(param.adUnit.spotId))

        super.init(with: channel, tag: .banner, mappingId: param.mappingId)
        
        banner.delegate = self
        banner.load()
    }
    
    override func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch targetMethod(from: call) {
        case .resume: banner.resume()
        case .pause: banner.pause()
        case .showAd: showAd()
        case .hideAd: hideAd()
        case .layout: layout(frame: BannerAd.frame(from: call.arguments).frame)
        default:
            super.handle(call, result: result)
            return
        }
        result(true)
    }
    
    class func adUnit(from argument: Any?) -> BannerAdUnitCodable {
        let jsonData = try! JSONSerialization.data(withJSONObject: argument!, options: [])
        return try! JSONDecoder().decode(BannerAdUnitCodable.self, from: jsonData)
    }
    
    private func layout(frame: Frame) {
        banner.frame = CGRect(x: frame.x, y: frame.y, width: frame.width, height: frame.height)
        banner.setNeedsLayout()
    }
    
    private func showAd() {
        rootViewController.view.addSubview(banner)
        banner.resume()
    }
    
    private func hideAd() {
        banner.pause()
        banner.removeFromSuperview()
    }
    
    func nadViewDidReceiveAd(_ adView: NADView!) {
        invokeDelegates(event: .onLoaded, args: nil)
    }
    
    func nadViewDidFail(toReceiveAd adView: NADView!) {
        let code = NADViewErrorCode(rawValue: adView.error._code)!.rawValue
        invokeDelegates(event: .onFailedToLoad, args: [KEY_ERROR_CODE: code])
    }
    
    func nadViewDidClickAd(_ adView: NADView!) {
        invokeDelegates(event: .onAdClicked, args: nil)
    }
    
    func nadViewDidClickInformation(_ adView: NADView!) {
        invokeDelegates(event: .onInformationClicked, args: nil)
    }
}

//
//  InterstitialVideoAd.swift
//  nend_plugin
//
//

import UIKit
import Flutter
import NendAd

class InterstitialVideoAd:
    VideoAd,
    NADInterstitialVideoDelegate,
    FlutterPlugin
{
    private var registrar: FlutterPluginRegistrar!
    
    static func register(with registrar: FlutterPluginRegistrar) {
        let instance = InterstitialVideoAd()
        instance.registrar = registrar
        
        instance.channel = FlutterMethodChannel(
            name: "nend_plugin/NendAdInterstitialVideo",
            binaryMessenger: registrar.messenger(),
            codec: FlutterJSONMethodCodec.sharedInstance()
        )
        instance.channel.setMethodCallHandler({
            (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            instance.handle(call, result: result)
        })
        registrar.addMethodCallDelegate(instance, channel: instance.channel)
    }
    
    override func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch targetMethod(call.method) {
            case .initAd:
                initAd(arguments: call.arguments)
            case .addFallbackFullboard:
                if let interstitialVideo = video as? NADInterstitialVideo {
                    let adUnit = self.adUnit(from: call.arguments)
                    interstitialVideo.addFallbackFullboard(withSpotID: adUnit.spotId, apiKey: adUnit.apiKey)
                    return
                }
                fallthrough
            case .muteStartPlaying:
                if let interstitialVideo = video as? NADInterstitialVideo {
                    interstitialVideo.isMuteStartPlaying = videoCodable(from: call.arguments)?.muteStartPlaying ?? true
                    return
                }
                fallthrough
            default:
                super.handle(call, result: result)
        }
    }
    
    func initAd(arguments: Any?) {
        let adUnit = self.adUnit(from: arguments)
        let interstitialVideo = NADInterstitialVideo.init(spotID: adUnit.spotId, apiKey: adUnit.apiKey)
        interstitialVideo.delegate = self
        video = interstitialVideo
    }
    
    func nadInterstitialVideoAdDidReceiveAd(_ nadInterstitialVideoAd: NADInterstitialVideo!) {
        var adType = ""
        switch nadInterstitialVideoAd.adType {
            case .normal:
                adType = "normal"
            case .playable:
                adType = "playable"
            default:
                adType = "unknown"
        }
        self.invokeMethod(.onLoaded, arguments: nil)
        self.invokeMethod(
            .onDetectedVideoType,
            arguments: ["type": adType]
        )
    }
    
    func nadInterstitialVideoAd(_ nadInterstitialVideoAd: NADInterstitialVideo!, didFailToLoadWithError error: Error!) {
        print(error.localizedDescription)
        self.invokeMethod(.onFailedToLoad, arguments: nil)
    }
    
    func nadInterstitialVideoAdDidFailed(toPlay nadInterstitialVideoAd: NADInterstitialVideo!) {
        self.invokeMethod(.onFailedToPlay, arguments: nil)
    }
    
    func nadInterstitialVideoAdDidOpen(_ nadInterstitialVideoAd: NADInterstitialVideo!) {
        self.invokeMethod(.onShown, arguments: nil)
    }
    
    func nadInterstitialVideoAdDidClose(_ nadInterstitialVideoAd: NADInterstitialVideo!) {
        self.invokeMethod(.onClosed, arguments: nil)
    }
    
    func nadInterstitialVideoAdDidStartPlaying(_ nadInterstitialVideoAd: NADInterstitialVideo!) {
        self.invokeMethod(.onStarted, arguments: nil)
    }
    
    func nadInterstitialVideoAdDidStopPlaying(_ nadInterstitialVideoAd: NADInterstitialVideo!) {
        self.invokeMethod(.onStopped, arguments: nil)
    }
    
    func nadInterstitialVideoAdDidCompletePlaying(_ nadInterstitialVideoAd: NADInterstitialVideo!) {
        self.invokeMethod(.onCompleted, arguments: nil)
    }
    
    func nadInterstitialVideoAdDidClickAd(_ nadInterstitialVideoAd: NADInterstitialVideo!) {
        self.invokeMethod(.onAdClicked, arguments: nil)
    }
    
    func nadInterstitialVideoAdDidClickInformation(_ nadInterstitialVideoAd: NADInterstitialVideo!) {
        self.invokeMethod(.onInformationClicked, arguments: nil)
    }
}

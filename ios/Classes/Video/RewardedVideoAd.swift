//
//  RewardedVideoAd.swift
//  nend_plugin
//
//

import UIKit
import Flutter
import NendAd

class RewardedVideoAd: VideoAd,
    NADRewardedVideoDelegate,
    FlutterPlugin
{

    private var registrar: FlutterPluginRegistrar!
    
    static func register(with registrar: FlutterPluginRegistrar) {
        let instance = RewardedVideoAd()
        instance.registrar = registrar
        
        instance.channel = FlutterMethodChannel(
            name: "nend_plugin/NendAdRewardedVideo",
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
            default:
                super.handle(call, result: result)
        }
    }
    
    func initAd(arguments: Any?) {
        let adUnit = self.adUnit(from: arguments)
        let rewardedVideo = NADRewardedVideo.init(spotID: adUnit.spotId, apiKey: adUnit.apiKey)
        rewardedVideo.delegate = self
        video = rewardedVideo
    }

    func nadRewardVideoAd(_ nadRewardedVideoAd: NADRewardedVideo!, didReward reward: NADReward!) {
        self.invokeMethod(.onRewarded, arguments: ["reward": ["name": reward.name, "amount": reward.amount]])
    }

    func nadRewardVideoAdDidReceiveAd(_ nadRewardedVideoAd: NADRewardedVideo!) {
        var adType = ""
        switch nadRewardedVideoAd.adType {
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

    func nadRewardVideoAd(_ nadRewardedVideoAd: NADRewardedVideo!, didFailToLoadWithError error: Error!) {
        print(error.localizedDescription)
        self.invokeMethod(.onFailedToLoad, arguments: nil)
    }

    func nadRewardVideoAdDidFailed(toPlay nadRewardedVideoAd: NADRewardedVideo!) {
        self.invokeMethod(.onFailedToPlay, arguments: nil)
    }

    func nadRewardVideoAdDidOpen(_ nadRewardedVideoAd: NADRewardedVideo!) {
        self.invokeMethod(.onShown, arguments: nil)
    }

    func nadRewardVideoAdDidClose(_ nadRewardedVideoAd: NADRewardedVideo!) {
        self.invokeMethod(.onClosed, arguments: nil)
    }

    func nadRewardVideoAdDidStartPlaying(_ nadRewardedVideoAd: NADRewardedVideo!) {
        self.invokeMethod(.onStarted, arguments: nil)
    }

    func nadRewardVideoAdDidStopPlaying(_ nadRewardedVideoAd: NADRewardedVideo!) {
        self.invokeMethod(.onStopped, arguments: nil)
    }

    func nadRewardVideoAdDidCompletePlaying(_ nadRewardedVideoAd: NADRewardedVideo!) {
        self.invokeMethod(.onCompleted, arguments: nil)
    }

    func nadRewardVideoAdDidClickAd(_ nadRewardedVideoAd: NADRewardedVideo!) {
        self.invokeMethod(.onAdClicked, arguments: nil)
    }

    func nadRewardVideoAdDidClickInformation(_ nadRewardedVideoAd: NADRewardedVideo!) {
        self.invokeMethod(.onInformationClicked, arguments: nil)
    }
}

//
//  InterstitialVideoAd.swift
//  nend_plugin
//
//

import UIKit
import Flutter
import NendAd

class InterstitialVideoAd: VideoAd,
    NADInterstitialVideoDelegate
{

    init(with param: AdUnitCodable, channel: FlutterMethodChannel) {
        let interstitialVideo = NADInterstitialVideo(spotId: String(param.adUnit.spotId), apiKey: param.adUnit.apiKey)
        super.init(with: .interstitialVideo, param: param, video: interstitialVideo, channel: channel)
        interstitialVideo.delegate = self
    }
    
    override func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch targetMethod(from: call) {
        case .addFallbackFullboard:
            if let interstitialVideo = video as? NADInterstitialVideo {
                let param = InterstitialVideoAd.adUnit(from: call.arguments)
                interstitialVideo.addFallbackFullboard(withSpotId: String(describing: param.adUnit.spotId), apiKey: param.adUnit.apiKey)
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
    
    func nadInterstitialVideoAdDidReceiveAd(_ nadInterstitialVideoAd: NADInterstitialVideo!) {
        invokeDelegates(event: .onLoaded, args: nil)
    }
    
    func nadInterstitialVideoAd(_ nadInterstitialVideoAd: NADInterstitialVideo!, didFailToLoadWithError error: Error!) {
        invokeDelegates(event: .onFailedToLoad, args: [KEY_ERROR_CODE: error._code])
    }
    
    func nadInterstitialVideoAdDidFailed(toPlay nadInterstitialVideoAd: NADInterstitialVideo!) {
        invokeDelegates(event: .onFailedToPlay, args: nil)
    }
    
    func nadInterstitialVideoAdDidOpen(_ nadInterstitialVideoAd: NADInterstitialVideo!) {
        invokeDelegates(event: .onShown, args: nil)
    }
    
    func nadInterstitialVideoAdDidClose(_ nadInterstitialVideoAd: NADInterstitialVideo!) {
        invokeDelegates(event: .onClosed, args: nil)
    }
    
    func nadInterstitialVideoAdDidStartPlaying(_ nadInterstitialVideoAd: NADInterstitialVideo!) {
        invokeDelegates(event: .onStarted, args: nil)
    }
    
    func nadInterstitialVideoAdDidStopPlaying(_ nadInterstitialVideoAd: NADInterstitialVideo!) {
        invokeDelegates(event: .onStopped, args: nil)
    }
    
    func nadInterstitialVideoAdDidCompletePlaying(_ nadInterstitialVideoAd: NADInterstitialVideo!) {
        invokeDelegates(event: .onCompleted, args: nil)
    }
    
    func nadInterstitialVideoAdDidClickAd(_ nadInterstitialVideoAd: NADInterstitialVideo!) {
        invokeDelegates(event: .onAdClicked, args: nil)
    }
    
    func nadInterstitialVideoAdDidClickInformation(_ nadInterstitialVideoAd: NADInterstitialVideo!) {
        invokeDelegates(event: .onInformationClicked, args: nil)
    }
}

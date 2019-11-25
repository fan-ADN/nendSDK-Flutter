//
//  NendAdRewardedVideo.swift
//  nend_plugin
//
//

import UIKit
import Flutter
import NendAd

class RewardedVideoAd: VideoAd,
    NADRewardedVideoDelegate
{

    init(with param: AdUnitCodable, channel: FlutterMethodChannel) {
        let rewardedVideo = NADRewardedVideo(spotId: String(param.adUnit.spotId), apiKey: param.adUnit.apiKey)
        super.init(with: .rewardedVideo, param: param, video: rewardedVideo, channel: channel)
        rewardedVideo.delegate = self
    }
    
    func nadRewardVideoAd(_ nadRewardedVideoAd: NADRewardedVideo!, didReward reward: NADReward!) {
        invokeDelegates(event: .onRewarded, args: ["reward": ["currencyAmount": reward.amount, "currencyName": reward.name]])
    }
    
    func nadRewardVideoAdDidReceiveAd(_ nadRewardedVideoAd: NADRewardedVideo!) {
        invokeDelegates(event: .onLoaded, args: nil)
    }
    
    func nadRewardVideoAd(_ nadRewardedVideoAd: NADRewardedVideo!, didFailToLoadWithError error: Error!) {
        invokeDelegates(event: .onFailedToLoad, args: [KEY_ERROR_CODE: error._code])
    }
    
    func nadRewardVideoAdDidFailed(toPlay nadRewardedVideoAd: NADRewardedVideo!) {
        invokeDelegates(event: .onFailedToPlay, args: nil)
    }
    
    func nadRewardVideoAdDidOpen(_ nadRewardedVideoAd: NADRewardedVideo!) {
        invokeDelegates(event: .onShown, args: nil)
    }
    
    func nadRewardVideoAdDidClose(_ nadRewardedVideoAd: NADRewardedVideo!) {
        invokeDelegates(event: .onClosed, args: nil)
    }
    
    func nadRewardVideoAdDidStartPlaying(_ nadRewardedVideoAd: NADRewardedVideo!) {
        invokeDelegates(event: .onStarted, args: nil)
    }
    
    func nadRewardVideoAdDidStopPlaying(_ nadRewardedVideoAd: NADRewardedVideo!) {
        invokeDelegates(event: .onStopped, args: nil)
    }
    
    func nadRewardVideoAdDidCompletePlaying(_ nadRewardedVideoAd: NADRewardedVideo!) {
        invokeDelegates(event: .onCompleted, args: nil)
    }
    
    func nadRewardVideoAdDidClickAd(_ nadRewardedVideoAd: NADRewardedVideo!) {
        invokeDelegates(event: .onAdClicked, args: nil)
    }
    
    func nadRewardVideoAdDidClickInformation(_ nadRewardedVideoAd: NADRewardedVideo!) {
        invokeDelegates(event: .onInformationClicked, args: nil)
    }
}

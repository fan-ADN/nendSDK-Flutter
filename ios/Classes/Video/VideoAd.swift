//
//  VideoAd.swift
//  nend_plugin
//
//

import UIKit
import Flutter
import NendAd

class VideoAd: AdBridger {
    
    var video: NADVideo!
    
    func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch targetMethod(call.method) {
            case .isReady: return result(video.isReady)
            case .loadAd: loadAd()
            case .showAd: showAd()
            case .releaseAd: video.releaseAd()
            case .mediationName:
                video.mediationName = videoCodable(from: call.arguments)?.mediationName ?? ""
            default:
                return
        }
        result(true)
    }
    
    func loadAd() {
        if video != nil {
            video.loadAd()
        }
    }
    
    private func showAd() {
        guard let rootViewController = self.rootViewController else { return }
        video.showAd(from: rootViewController)
    }
    
    func adUnit(from argument: Any?) -> AdUnit {
        let jsonData = try! JSONSerialization.data(withJSONObject: argument!, options: [])
        return try! JSONDecoder().decode(AdUnit.self, from: jsonData)
    }
    
    func videoCodable(from argument: Any?) -> VideoCodable? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: argument!, options: [])
            return try JSONDecoder().decode(VideoCodable.self, from: jsonData)
        } catch let error {
            print(error)
        }
        return nil
    }
}

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
            case .userId:
                video.userId = videoCodable(from: call.arguments)?.userId ?? ""
            case .userFeature:
                video.userFeature = generateFeature(from: videoCodable(from: call.arguments))
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
    
    func generateFeature(from videoCodable: VideoCodable?) -> NADUserFeature {
        let feature = NADUserFeature()
        guard let args = videoCodable, let featureJson = args.userFeature else {
            return feature
        }
        if let age = featureJson.age {
            feature.age = age
        }
        if let gender = featureJson.gender {
            switch gender {
            case NADGender.male.rawValue:
                feature.gender = NADGender.male
            case NADGender.female.rawValue:
                feature.gender = NADGender.female
            default:
                break
            }
        }
        if let birthday = featureJson.birthday {
            feature.setBirthdayWithYear(birthday.year, month: birthday.month, day: birthday.day)
        }
        if let customDoubleParams = featureJson.customDoubleParams {
            customDoubleParams.forEach({
                feature.addCustomDoubleValue($0.value, forKey: $0.key)
            })
        }
        if let customStringParams = featureJson.customStringParams {
            customStringParams.forEach({
                feature.addCustomStringValue($0.value, forKey: $0.key)
            })
        }
        if let customIntegerParams = featureJson.customIntegerParams {
            customIntegerParams.forEach({
                feature.addCustomIntegerValue($0.value, forKey: $0.key)
            })
        }
        if let customBooleanParams = featureJson.customBooleanParams {
            customBooleanParams.forEach({
                feature.addCustomBoolValue($0.value, forKey: $0.key)
            })
        }

        return feature
    }
}

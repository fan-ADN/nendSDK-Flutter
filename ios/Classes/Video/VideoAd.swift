//
//  NendAdVideo.swift
//  nend_plugin
//
//

import UIKit
import Flutter
import NendAd

class VideoAd: AdBridger {
    let video: NADVideo

    init(with tag: SwiftNendPlugin.ClassNameTag, param: AdUnitCodable, video: NADVideo, channel: FlutterMethodChannel) {
        self.video = video
        super.init(with: channel, tag: tag, mappingId: param.mappingId)
    }
    
    override func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch targetMethod(from: call) {
        case .isReady: return result(video.isReady)
        case .loadAd: video.loadAd()
        case .showAd: video.showAd(from: rootViewController)
        case .releaseAd: video.releaseAd()
        case .mediationName:
            video.mediationName = videoCodable(from: call.arguments)?.mediationName ?? ""
        case .userId:
            video.userId = videoCodable(from: call.arguments)?.userId ?? ""
        case .userFeature:
            video.userFeature = generateFeature(from: videoCodable(from: call.arguments))
        case .locationEnabled:
            video.isLocationEnabled = videoCodable(from: call.arguments)?.locationEnabled ?? true
        default:
            super.handle(call, result: result)
            return
        }
        result(true)
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

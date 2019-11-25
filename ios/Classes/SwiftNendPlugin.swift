import Flutter
import UIKit

public class SwiftNendPlugin: NSObject, FlutterPlugin {
    static let KEY_MAPPING_ID = "mappingId"
    
    private let registrar: FlutterPluginRegistrar
    private let channel: FlutterMethodChannel
    private var banners = [String: BannerAd]()
    private var nativeAdLoaders = [String: NativeAdLoader]()
    private var nativeAdConnectors = [String: NativeAdConnector]()
    private var interstitialVideos = [String: InterstitialVideoAd]()
    private var rewardedVideos = [String: RewardedVideoAd]()
    private var interstitials = [String: InterstitialAd]()

    init(with registrar: FlutterPluginRegistrar, channel: FlutterMethodChannel) {
        self.registrar = registrar
        self.channel = channel
    }
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "nend_plugin", binaryMessenger: registrar.messenger(), codec: FlutterJSONMethodCodec.sharedInstance())
        let instance = SwiftNendPlugin(with: registrar, channel: channel)
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if call.method.contains(".init") {
            instantiate(call, result: result)
        } else {
            execute(call, result: result)
        }
    }
    
    private func instantiate(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch SwiftNendPlugin.targetAd(method: call.method) {
        case .banner:
            let banner = BannerAd(with: BannerAd.adUnit(from: call.arguments), channel: channel)
            banners.updateValue(banner, forKey: banner.mappingId)
        case .nativeAdLoader:
            let loader = NativeAdLoader(with: NativeAdLoader.adUnit(from: call.arguments), channel: channel)
            loader.onConnect = {(ad, key) in
                self.nativeAdConnectors.updateValue(NativeAdConnector(with: ad, channel: self.channel), forKey: key)
            }
            nativeAdLoaders.updateValue(loader, forKey: loader.mappingId)
        case .interstitialVideo:
            let video = InterstitialVideoAd(with: InterstitialVideoAd.adUnit(from: call.arguments), channel: channel)
            interstitialVideos.updateValue(video, forKey: video.mappingId)
        case .rewardedVideo:
            let video = RewardedVideoAd(with: RewardedVideoAd.adUnit(from: call.arguments), channel: channel)
            rewardedVideos.updateValue(video, forKey: video.mappingId)
        case .interstitial:
            let interstitial = InterstitialAd(with: InterstitialAd.adUnit(from: call.arguments), channel: channel)
            interstitials.updateValue(interstitial, forKey: interstitial.mappingId)
        default:
            result(FlutterMethodNotImplemented)
            return
        }
        result(nil)
    }
    
    private func execute(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch SwiftNendPlugin.targetAd(method: call.method) {
        case .banner:
            handleTarget(targetAds: banners, call: call, result: result)
        case .nativeAdLoader:
            handleTarget(targetAds: nativeAdLoaders, call: call, result: result)
        case .nativeAdConnector:
            handleTarget(targetAds: nativeAdConnectors, call: call, result: result)
        case .interstitialVideo:
            handleTarget(targetAds: interstitialVideos, call: call, result: result)
        case .rewardedVideo:
            handleTarget(targetAds: rewardedVideos, call: call, result: result)
        case .interstitial:
            handleTarget(targetAds: interstitials, call: call, result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    private func handleTarget(targetAds: [String: AdBridger], call: FlutterMethodCall, result: @escaping FlutterResult) {
        let isDispose = call.method.contains(".dispose")
        if isDispose {
            var targetAds = targetAds
            targetAds.removeValue(forKey: SwiftNendPlugin.mappingId(from: call.arguments))
            result(true)
        } else if let target = targetAds[SwiftNendPlugin.mappingId(from: call.arguments)] {
            target.handle(call, result: result)
        } else {
            result(false)
        }
    }
    
    static func targetAd(method: String) -> ClassNameTag {
        let name = String(method.split(separator: ".").first ?? "unKnown")
        let tag = ClassNameTag(rawValue: name) ?? .unKnown
        return tag
        //return ClassNameTag(rawValue: String(method.split(separator: ".").first ?? "unKnown")) ?? .unKnown
    }
    
    static func targetFunc(method: String, className: String) -> String {
        return method.replacingOccurrences(of: className + ".", with: "")
    }
    
    static func mappingId(from argument: Any?) -> String {
        guard let dictionary = argument as? [String: Any],
            let mappingId = dictionary[KEY_MAPPING_ID] as? String else {
                return ""
        }
        return mappingId
    }
    
    //Note: Use the same class name as the Android side.
    enum ClassNameTag: String {
        case banner = "NendAdView",
        nativeAdLoader = "NendAdNativeClient",
        nativeAdConnector = "NendNativeAdConnector",
        interstitialVideo = "NendAdInterstitialVideo",
        rewardedVideo = "NendAdRewardedVideo",
        interstitial = "NendAdInterstitial",
        unKnown = "???"
    }
}

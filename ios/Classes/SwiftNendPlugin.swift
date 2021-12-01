import Flutter
import UIKit

public class SwiftNendPlugin: NSObject, FlutterPlugin {
    
    private let registrar: FlutterPluginRegistrar
    private let channel: FlutterMethodChannel

    init(with registrar: FlutterPluginRegistrar, channel: FlutterMethodChannel) {
        self.registrar = registrar
        self.channel = channel
    }
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        registrar.register(BannerAdFactory(messenger: registrar.messenger()), withId: "nend_plugin/banner")
        InterstitialAd.register(with: registrar)
        InterstitialVideoAd.register(with: registrar)
        RewardedVideoAd.register(with: registrar)
        NendAdLogger.register(with: registrar)
    }
}

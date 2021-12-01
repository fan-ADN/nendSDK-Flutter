//
//  NendAdLogger.swift
//  nend_plugin
//

import NendAd
import Flutter

class NendAdLogger: AdBridger, FlutterPlugin {
    var registrar: FlutterPluginRegistrar!
    
    static func register(with registrar: FlutterPluginRegistrar) {
        let instance = NendAdLogger()
        instance.registrar = registrar
        
        instance.channel = FlutterMethodChannel(
            name: "nend_plugin/ad_logger",
            binaryMessenger: registrar.messenger(),
            codec: FlutterJSONMethodCodec.sharedInstance()
        )
        
        instance.channel.setMethodCallHandler({
            (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            switch instance.targetMethod(call.method) {
                case .setLogLevel: instance.setLogLevel(argument: call.arguments)
                default:
                    return;
            }
            result(true)
        })
    }
    
    func setLogLevel(argument: Any?) {
        let jsonData = try! JSONSerialization.data(withJSONObject: argument!, options: [])
        let result = try! JSONDecoder().decode([String: Int?].self, from: jsonData)
        let logLevel = result["logLevel"]! ?? Int.max
        NADLogger.setLogLevel(NADLogLevel(rawValue: logLevel) ?? .off)
    }
}

package net.nend.nendplugin

import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.JSONMethodCodec
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import net.nend.android.NendAdLogger
import org.json.JSONObject

class AdLogger(messenger: BinaryMessenger?) : MethodChannel.MethodCallHandler, AdBridger() {

    override val methodChannel =
        MethodChannel(messenger, "nend_plugin/ad_logger", JSONMethodCodec.INSTANCE)

    init {
        methodChannel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (targetMethod(call.method)) {
            MethodName.SetLogLevel -> setLogLevel(call.arguments())
            else -> result.notImplemented()
        }
        result.success(true)
    }

    private fun setLogLevel(arguments: JSONObject) {
        val logLevel: NendAdLogger.LogLevel = when (arguments.optInt("logLevel")) {
            1 -> NendAdLogger.LogLevel.DEBUG
            2 -> NendAdLogger.LogLevel.INFO
            3 -> NendAdLogger.LogLevel.WARN
            4 -> NendAdLogger.LogLevel.ERROR
            else -> NendAdLogger.LogLevel.OFF
        }
        NendAdLogger.setLogLevel(logLevel)
    }
}
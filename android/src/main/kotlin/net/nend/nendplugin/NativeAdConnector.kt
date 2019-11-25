package net.nend.nendplugin

import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry
import net.nend.android.internal.connectors.NendNativeAdConnector

class NativeAdConnector(registrar: PluginRegistry.Registrar, private val adConnector: NendNativeAdConnector): AdBridger(registrar, adConnector.hashCode().toString()) {

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (getMethod(call, "NendNativeAdConnector")) {
            MethodName.Activate -> {
                adConnector.sendImpression()
            }
            MethodName.PerformAdClick -> {
                adConnector.performAdClick(activity)
            }
            MethodName.PerformInformationClick -> {
                adConnector.performInformationClick(activity)
            }
            else -> {
                super.onMethodCall(call, result)
                return
            }
        }
        result.success(true)
    }
}
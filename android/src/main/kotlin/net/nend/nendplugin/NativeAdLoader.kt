package net.nend.nendplugin

import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry
import net.nend.android.NendAdNative
import net.nend.android.NendAdNativeClient
import net.nend.android.internal.connectors.NendNativeAdConnectorFactory

class NativeAdLoader(registrar: PluginRegistry.Registrar, arguments: Any) : AdBridger(registrar, NendPlugin.getAdUnitFrom(arguments).first) {
    lateinit var connectorCallback: NendPlugin.ConnectorCallback
    private val client : NendAdNativeClient
    private val adUnit = NendPlugin.getAdUnitFrom(arguments)

    private val callback = object : NendAdNativeClient.Callback {
        override fun onSuccess(nendAdNative: NendAdNative) {
            val connector = NendNativeAdConnectorFactory.createNativeAdConnector(nendAdNative)
            val hashCode = connector.hashCode().toString()
            connectorCallback.onConnect(connector, hashCode)
            val nativeAd = mapOf(
                    "titleText" to connector.shortText,
                    "contentText" to connector.longText,
                    "promotionName" to connector.promotionName,
                    "promotionUrl" to connector.promotionUrl,
                    "adImageUrl" to connector.adImageUrl,
                    "logoImageUrl" to connector.logoImageUrl,
                    "actionButtonText" to connector.actionButtonText,
                    "hashCode" to hashCode
            )
            invokeListenerEvent(CallbackName.OnLoaded, mapOf("nativeAd" to nativeAd))
        }

        override fun onFailure(nendError: NendAdNativeClient.NendError) {
            invokeListenerEvent(CallbackName.OnFailedToLoad, mapOf(KEY_ERROR_CODE to nendError.code))
        }
    }

    init {
        client = NendAdNativeClient(activity, adUnit.second, adUnit.third)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (getMethod(call, getTag(client))) {
            MethodName.LoadAd -> {
                client.loadAd(callback)
            }
            MethodName.EnableAutoReload -> {
                val interval = NendPlugin.simplePickFrom(call.arguments, "intervalMillis").toLong()
                client.enableAutoReload(interval, callback)
            }
            MethodName.DisableAutoReload -> {
                client.disableAutoReload()
            }
            else -> {
                super.onMethodCall(call, result)
                return
            }
        }
        result.success(true)
    }

    private fun invokeListenerEvent(event: CallbackName, args: Map<String, Any>?) {
        NendPlugin.channel.invokeMethod(getTag(client) + "." + event.toString().decapitalize(), mappingArguments(mappingId, args))
    }
}
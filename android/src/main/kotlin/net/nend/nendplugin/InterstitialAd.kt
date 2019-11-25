package net.nend.nendplugin

import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry
import net.nend.android.NendAdInterstitial


class InterstitialAd(private var registrar: PluginRegistry.Registrar, arguments: Any) : AdBridger(registrar, NendPlugin.getMappingIdFrom(arguments)) {
    private val interstitial: NendAdInterstitial = NendAdInterstitial()
    private var lastLoadedSpotId: Int = 0

    companion object {
        private const val defaultSpotId = -1
    }

    init {
        registerListener()
    }

    private fun registerListener() {
        NendAdInterstitial.setListener(object : NendAdInterstitial.OnCompletionListenerSpot {
            override fun onCompletion(p0: NendAdInterstitial.NendAdInterstitialStatusCode?) {
            }

            override fun onCompletion(status: NendAdInterstitial.NendAdInterstitialStatusCode?, spotId: Int) {
                when (status) {
                    NendAdInterstitial.NendAdInterstitialStatusCode.SUCCESS -> {
                        invokeListenerEvent(CallbackName.OnLoaded, mapOf(NendPlugin.KEY_SPOT_ID to spotId.toString()))
                    }
                    else -> {
                        invokeListenerEvent(CallbackName.OnFailedToLoad, mapOf(NendPlugin.KEY_SPOT_ID to spotId.toString(), KEY_ERROR_CODE to status!!.ordinal))
                    }
                }
            }
        })
    }

    private fun invokeListenerEvent(event: CallbackName, args: Map<String, Any>?) {
        NendPlugin.channel.invokeMethod(getTag(interstitial) + "." + event.toString().decapitalize(), mappingArguments(mappingId, args))
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (getMethod(call, getTag(interstitial))) {
            MethodName.LoadAd -> {
                val adUnit = NendPlugin.getAdUnitFrom(call.arguments)
                lastLoadedSpotId = adUnit.second
                NendAdInterstitial.loadAd(registrar.activity(), adUnit.third, lastLoadedSpotId)
            }
            MethodName.ShowAd -> {
                var spotId = getSpotIdFrom(call.arguments)
                if (spotId == defaultSpotId) {
                    spotId = lastLoadedSpotId
                }

                val clickListener = object : NendAdInterstitial.OnClickListenerSpot {
                    override fun onClick(clickType: NendAdInterstitial.NendAdInterstitialClickType?) {
                    }

                    override fun onClick(clickType: NendAdInterstitial.NendAdInterstitialClickType?, spotId: Int) {
                        when (clickType) {
                            NendAdInterstitial.NendAdInterstitialClickType.CLOSE -> {
                                invokeListenerEvent(CallbackName.OnClosed, mapOf(NendPlugin.KEY_SPOT_ID to spotId.toString()))
                            }
                            NendAdInterstitial.NendAdInterstitialClickType.DOWNLOAD -> {
                                invokeListenerEvent(CallbackName.OnAdClicked, mapOf(NendPlugin.KEY_SPOT_ID to spotId.toString()))
                            }
                            NendAdInterstitial.NendAdInterstitialClickType.INFORMATION -> {
                                invokeListenerEvent(CallbackName.OnInformationClicked, mapOf(NendPlugin.KEY_SPOT_ID to spotId.toString()))
                            }
                        }
                    }
                }

                val showResult = NendAdInterstitial.showAd(registrar.activity(), spotId, clickListener)
                when (showResult) {
                    NendAdInterstitial.NendAdInterstitialShowResult.AD_SHOW_SUCCESS -> {
                        invokeListenerEvent(CallbackName.OnShown, mapOf(NendPlugin.KEY_SPOT_ID to spotId.toString()))
                    }
                    else -> {
                        invokeListenerEvent(CallbackName.OnFailedToShow, mapOf(KEY_ERROR_CODE to showResult.ordinal, NendPlugin.KEY_SPOT_ID to spotId.toString()))
                    }
                }
            }
            MethodName.DismissAd -> {
                NendAdInterstitial.dismissAd()
            }
            MethodName.IsEnableAutoReload -> {
                NendAdInterstitial.isAutoReloadEnabled = NendPlugin.simplePickFrom(call.arguments, "enableAutoReload").toBoolean()
            }
            else -> {
                super.onMethodCall(call, result)
                return
            }
        }
        result.success(true)
    }

    private fun getSpotIdFrom(arguments: Any): Int {
        return NendPlugin.simplePickFrom(arguments, "spotId").toInt()
    }

}

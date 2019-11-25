package net.nend.nendplugin

import io.flutter.plugin.common.JSONMethodCodec
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar
import net.nend.android.*
import net.nend.android.internal.connectors.NendNativeAdConnector
import org.json.JSONObject

class NendPlugin : MethodCallHandler {
    private val banners = mutableMapOf<String, BannerAd>()
    private val nativeAdLoaders = mutableMapOf<String, NativeAdLoader>()
    private val nativeAdConnectors = mutableMapOf<String, NativeAdConnector>()
    private val interstitialVideos = mutableMapOf<String, InterstitialVideoAd>()
    private val rewardedVideos = mutableMapOf<String, RewardedVideoAd>()
    private var interstitial: InterstitialAd? = null

    companion object {
        const val TAG = "NendPlugin"
        const val KEY_MAPPING_ID = "mappingId"
        lateinit var registrar: Registrar
        lateinit var channel: MethodChannel
        const val KEY_SPOT_ID = "spotId"

        @JvmStatic
        fun registerWith(registrar: Registrar) {
            val channel = MethodChannel(registrar.messenger(), "nend_plugin", JSONMethodCodec.INSTANCE)
            channel.setMethodCallHandler(NendPlugin())
            this.registrar = registrar
            this.channel = channel
        }

        fun getAdUnitFrom(arguments: Any): Triple<String, Int, String> {
            val adUnit = (arguments as JSONObject).getJSONObject("adUnit")
            return Triple(getMappingIdFrom(arguments), adUnit.getInt("spotId"), adUnit.getString("apiKey"))
        }

        fun getMappingIdFrom(arguments: Any): String {
            return simplePickFrom(arguments, KEY_MAPPING_ID)
        }

        fun simplePickFrom(arguments: Any, key: String): String {
            return (arguments as JSONObject).getString(key)
        }
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        if (call.method.contains(".init")) {
            initializeAd(call, result)
        } else {
            handleMethodCall(call, result)
        }
    }

    private fun initializeAd(call: MethodCall, result: Result) {
        when {
            call.method.startsWith(NendAdView::class.java.simpleName) -> {
                val banner = BannerAd(registrar, call.arguments)
                banners[banner.mappingId] = banner
                result.success(null)
            }
            call.method.startsWith(NendAdNativeClient::class.java.simpleName) -> {
                val loader = NativeAdLoader(registrar, call.arguments).apply {
                    connectorCallback = object : ConnectorCallback {
                        override fun onConnect(connector: NendNativeAdConnector, key: String) {
                            nativeAdConnectors[key] = NativeAdConnector(registrar, connector)
                        }
                    }
                }
                nativeAdLoaders[loader.mappingId] = loader
                result.success(null)
            }
            call.method.startsWith(NendAdInterstitialVideo::class.java.simpleName) -> {
                val video = InterstitialVideoAd(registrar, call.arguments)
                interstitialVideos[video.mappingId] = video
                result.success(null)
            }
            call.method.startsWith(NendAdRewardedVideo::class.java.simpleName) -> {
                val video = RewardedVideoAd(registrar, call.arguments)
                rewardedVideos[video.mappingId] = video
                result.success(null)
            }
            call.method.startsWith(NendAdInterstitial::class.java.simpleName) -> {
                if (interstitial == null) {
                    interstitial = InterstitialAd(registrar, call.arguments)
                }
                result.success(null)
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    private fun handleMethodCall(call: MethodCall, result: Result) {
        val isDispose = call.method.contains(".dispose")
        when {
            call.method.startsWith(NendAdView::class.java.simpleName) -> {
                if (isDispose) {
                    banners.remove(getMappingIdFrom(call.arguments))
                } else {
                    val target = banners[getMappingIdFrom(call.arguments)]
                    if (target != null) {
                        target.onMethodCall(call, result)
                    } else {
                        result.success(false)
                    }
                }
            }
            call.method.startsWith(NendAdNativeClient::class.java.simpleName) -> {
                if (isDispose) {
                    nativeAdLoaders.remove(getMappingIdFrom(call.arguments))
                } else {
                    val target = nativeAdLoaders[getMappingIdFrom(call.arguments)]
                    if (target != null) {
                        target.onMethodCall(call, result)
                    } else {
                        result.success(false)
                    }
                }
            }
            call.method.startsWith(NendNativeAdConnector::class.java.simpleName) -> {
                if (isDispose) {
                    nativeAdConnectors.remove(getMappingIdFrom(call.arguments))
                } else {
                    val target = nativeAdConnectors[getMappingIdFrom(call.arguments)]
                    if (target != null) {
                        target.onMethodCall(call, result)
                    } else {
                        result.success(false)
                    }
                }
            }
            call.method.startsWith(NendAdInterstitialVideo::class.java.simpleName) -> {
                if (isDispose) {
                    interstitialVideos.remove(getMappingIdFrom(call.arguments))
                } else {
                    val target = interstitialVideos[getMappingIdFrom(call.arguments)]
                    if (target != null) {
                        target.onMethodCall(call, result)
                    } else {
                        result.success(false)
                    }
                }
            }
            call.method.startsWith(NendAdRewardedVideo::class.java.simpleName) -> {
                if (isDispose) {
                    rewardedVideos.remove(getMappingIdFrom(call.arguments))
                } else {
                    val target = rewardedVideos[getMappingIdFrom(call.arguments)]
                    if (target != null) {
                        target.onMethodCall(call, result)
                    } else {
                        result.success(false)
                    }
                }
            }
            call.method.startsWith(NendAdInterstitial::class.java.simpleName) -> {
                // 'isDispose' is unnecessary. Because interstitial is singleton.
                if (interstitial != null) {
                    interstitial!!.onMethodCall(call, result)
                } else {
                    result.success(false)
                }
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    interface ConnectorCallback {
        fun onConnect(connector: NendNativeAdConnector, key: String)
    }
}

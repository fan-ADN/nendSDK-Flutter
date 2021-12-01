package net.nend.nendplugin

import android.app.Activity
import android.content.Context
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.JSONMethodCodec
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import net.nend.android.NendAdInterstitial
import net.nend.android.NendAdInterstitial.NendAdInterstitialShowResult
import net.nend.android.NendAdInterstitial.NendAdInterstitialStatusCode.FAILED_AD_DOWNLOAD
import net.nend.android.NendAdInterstitial.NendAdInterstitialStatusCode.FAILED_AD_REQUEST
import net.nend.android.NendAdInterstitial.NendAdInterstitialStatusCode.INVALID_RESPONSE_TYPE
import net.nend.android.NendAdInterstitial.NendAdInterstitialStatusCode.SUCCESS
import net.nend.nendplugin.ext.maybeBoolean
import net.nend.nendplugin.ext.maybeInt
import org.json.JSONObject


class InterstitialAd(
    private val activity: Activity?,
    private val context: Context?,
    messenger: BinaryMessenger?
) : MethodChannel.MethodCallHandler, AdBridger(), NendAdInterstitial.OnClickListener {

    override val methodChannel =
        MethodChannel(messenger, "nend_plugin/interstitial", JSONMethodCodec.INSTANCE)

    init {
        methodChannel.setMethodCallHandler(this)
        registerListener()
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (targetMethod(call.method)) {
            MethodName.LoadAd -> loadAd(call.arguments())
            MethodName.ShowAd -> showAd(call.arguments())
            MethodName.DismissAd -> dismissAd()
            MethodName.EnableAutoReload -> enableAutoReload(call.arguments())
            else -> {
                return result.notImplemented()
            }
        }
        result.success(true)
    }

    private fun registerListener() {
        NendAdInterstitial.setListener { status ->
            when (status) {
                SUCCESS -> {
                    methodChannel.invokeListenerEvent(
                        CallbackName.OnLoaded,
                        mapOf(KEY_RESULT to "LOAD AD SUCCESS")
                    )
                }
                FAILED_AD_DOWNLOAD, INVALID_RESPONSE_TYPE, FAILED_AD_REQUEST -> {
                    methodChannel.invokeListenerEvent(
                        CallbackName.OnFailedToLoad,
                        mapOf(KEY_RESULT to status.name.replace("_", " "))
                    )
                }
                else -> return@setListener
            }
        }
    }

    private fun loadAd(arguments: JSONObject) {
        val adUnit = AdUnit.fromArguments(arguments)
        if (context != null && adUnit != null) {
            adUnit.let { (spotId, apiKey) ->
                NendAdInterstitial.loadAd(context, apiKey, spotId)
            }
        }
    }

    private fun showAd(arguments: JSONObject) {
        val result = activity?.let { activity ->
            arguments.maybeInt("spotId")?.let { spotId ->
                NendAdInterstitial.showAd(activity, spotId, this)
            }
        }

        result?.let { status ->
            when (status) {
                NendAdInterstitialShowResult.AD_SHOW_SUCCESS -> methodChannel.invokeListenerEvent(
                    CallbackName.OnShown,
                    mapOf(KEY_RESULT to "AD SHOW SUCCESS")
                )
                else -> methodChannel.invokeListenerEvent(
                    CallbackName.OnFailedToShow, mapOf(KEY_RESULT to status.name.replace("_", " "))
                )
            }
        }
    }

    private fun dismissAd() {
        NendAdInterstitial.dismissAd()
    }

    private fun enableAutoReload(arguments: JSONObject) {
        arguments.maybeBoolean("enableAutoReload")?.run {
            NendAdInterstitial.isAutoReloadEnabled = this
        }
    }

    override fun onClick(status: NendAdInterstitial.NendAdInterstitialClickType?) {
        when (status) {
            NendAdInterstitial.NendAdInterstitialClickType.DOWNLOAD -> methodChannel.invokeListenerEvent(
                CallbackName.OnAdClicked,
                null
            )
            NendAdInterstitial.NendAdInterstitialClickType.INFORMATION -> methodChannel.invokeListenerEvent(
                CallbackName.OnInformationClicked,
                null
            )
            NendAdInterstitial.NendAdInterstitialClickType.CLOSE -> methodChannel.invokeListenerEvent(
                CallbackName.OnClosed,
                null
            )
            else -> return
        }
    }
}

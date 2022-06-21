package net.nend.nendplugin

import android.content.Context
import android.view.View
import android.view.ViewGroup
import android.view.ViewGroup.LayoutParams.MATCH_PARENT
import android.widget.LinearLayout
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.JSONMethodCodec
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView
import net.nend.android.NendAdInformationListener
import net.nend.android.NendAdView
import org.json.JSONObject

class BannerAd(private val context: Context, messenger: BinaryMessenger, private val id: Int) :
    PlatformView,
    MethodChannel.MethodCallHandler, AdBridger() {

    override val methodChannel: MethodChannel =
        MethodChannel(messenger, "nend_plugin/banner/$id", JSONMethodCodec.INSTANCE)

    private val platformView: LinearLayout = LinearLayout(context).apply {
        layoutParams = ViewGroup.LayoutParams(MATCH_PARENT, MATCH_PARENT)
    }

    private var nendAdView: NendAdView? = null

    init {
        methodChannel.setMethodCallHandler(this)
    }

    override fun getView(): View {
        return platformView
    }

    override fun dispose() {
        releaseAd()
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (targetMethod(call.method)) {
            MethodName.LoadAd -> {
                call.arguments<JSONObject?>()?.let {
                    loadAd(it)
                }
            }
            MethodName.ShowAd -> showAd()
            MethodName.HideAd -> hideAd()
            MethodName.Resume -> nendAdView?.run { resume() }
            MethodName.Pause -> nendAdView?.run { pause() }
            MethodName.ReleaseAd -> releaseAd()
            else -> {
                return result.notImplemented()
            }
        }
        result.success(true)
    }

    private fun loadAd(arguments: JSONObject) {
        releaseAd()
        val codable = BannerCodable.fromArguments(arguments)
        nendAdView = codable?.let { (adjustSize, adUnit) ->
            NendAdView(context, adUnit.spotId, adUnit.apiKey, adjustSize).let { ad ->
                ad.loadAd()
                ad
            }
        }
        registerListener()
    }

    private fun showAd() {
        nendAdView?.let { ad ->
            if (platformView.childCount != 0) {
                ad.visibility = View.VISIBLE
                return
            }
            platformView.addView(nendAdView)
            ad.resume()
        }
    }

    private fun hideAd() {
        nendAdView?.let { ad ->
            if (platformView.childCount != 0) {
                ad.pause()
                ad.visibility = View.GONE
            }
        }
    }

    private fun releaseAd() {
        nendAdView?.let { ad ->
            ad.pause()
            platformView.removeView(ad)
        }
        nendAdView = null
    }

    private fun registerListener() {
        nendAdView?.setListener(object : NendAdInformationListener {
            override fun onReceiveAd(p0: NendAdView) {
                nendAdView?.let {
                    methodChannel.invokeListenerEvent(CallbackName.OnLoaded, null)
                }
            }

            override fun onFailedToReceiveAd(p0: NendAdView) {
                val errorCode = p0.nendError.code - 840
                val message = p0.nendError.message
                println("error $errorCode: $message")
                nendAdView?.let {
                    methodChannel.invokeListenerEvent(CallbackName.OnFailedToLoad, null)
                }
            }

            override fun onClick(p0: NendAdView) {
                nendAdView?.let {
                    methodChannel.invokeListenerEvent(CallbackName.OnAdClicked, null)
                }
            }

            override fun onInformationButtonClick(p0: NendAdView) {
                nendAdView?.let {
                    methodChannel.invokeListenerEvent(CallbackName.OnInformationClicked, null)
                }
            }

            override fun onDismissScreen(p0: NendAdView) {
                // Note: Do nothing. Because this callback is of Android only.
            }
        })
    }

    data class BannerCodable(
        val adjustSize: Boolean,
        val adUnit: AdUnit
    ) {
        companion object {
            fun fromArguments(arguments: JSONObject): BannerCodable? = runCatching {
                arguments.let { args ->
                    val adjustSize = args.getBoolean("adjustSize")
                    val adUnitJson = args.getJSONObject("adUnit")
                    AdUnit.fromArguments(adUnitJson)?.let {
                        BannerCodable(adjustSize, it)
                    }
                }
            }.getOrNull()
        }
    }
}
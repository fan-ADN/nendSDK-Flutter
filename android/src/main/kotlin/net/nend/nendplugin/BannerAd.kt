package net.nend.nendplugin

import android.util.Log
import android.view.ViewGroup
import android.view.ViewGroup.LayoutParams.MATCH_PARENT
import android.widget.LinearLayout
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry
import net.nend.android.NendAdInformationListener
import net.nend.android.NendAdView
import org.json.JSONObject


class BannerAd(registrar: PluginRegistry.Registrar, arguments: Any) : AdBridger(registrar, NendPlugin.getAdUnitFrom(arguments).first) {
    private val adView: NendAdView
    private var content: LinearLayout? = null

    init {
        val adUnit = NendPlugin.getAdUnitFrom(arguments)
        adView = NendAdView(activity, adUnit.second, adUnit.third, isAdjustSizeFrom(arguments))
        registerListener()
        adView.loadAd()
    }

    private fun registerListener() {
        adView.setListener(object : NendAdInformationListener {
            override fun onReceiveAd(p0: NendAdView) {
                invokeListenerEvent(CallbackName.OnLoaded, null)
            }

            override fun onFailedToReceiveAd(p0: NendAdView) {
                val errorCode = p0.nendError.code - 840
                invokeListenerEvent(CallbackName.OnFailedToLoad, mapOf(KEY_ERROR_CODE to errorCode))
            }

            override fun onClick(p0: NendAdView) {
                invokeListenerEvent(CallbackName.OnAdClicked, null)
            }

            override fun onInformationButtonClick(p0: NendAdView) {
                invokeListenerEvent(CallbackName.OnInformationClicked, null)
            }

            override fun onDismissScreen(p0: NendAdView) {
                // Note: Do nothing. Because this callback is of Android only.
            }
        })
    }

    private fun invokeListenerEvent(event: CallbackName, args: Map<String, Any>?) {
        NendPlugin.channel.invokeMethod(getTag(adView) + "." + event.toString().decapitalize(), mappingArguments(mappingId, args))
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (getMethod(call, getTag(adView))) {
            MethodName.Resume -> adView.resume()
            MethodName.Pause -> adView.pause()
            MethodName.Layout -> {
                layoutBanner(call.arguments)
            }
            MethodName.ShowAd -> {
                showBanner()
            }
            MethodName.HideAd -> {
                hideBanner()
            }
            else -> {
                super.onMethodCall(call, result)
                return
            }
        }
        result.success(true)
    }

    private fun layoutBanner(arguments: Any) {
        if (content != null) {
            content!!.findViewWithTag<NendAdView>(mappingId)?.apply {
                layoutParams = layoutParamsFrom(arguments)
                invalidate()
            }
        } else {
            content = LinearLayout(activity).apply {
                id = mappingId.toInt()
                adView.tag = mappingId
                addView(adView, layoutParamsFrom(arguments))
            }
        }
    }

    private fun showBanner() {
        if (activity == null) {
            Log.e(NendPlugin.TAG,"PluginRegistry cannot given activity object...")
            return
        }

        if (activity.findViewById<LinearLayout>(mappingId.toInt()) == null) {
            activity.addContentView(content, ViewGroup.LayoutParams(MATCH_PARENT, MATCH_PARENT))
        }
        adView.resume()
        registerListener()
    }

    private fun hideBanner() {
        adView.pause()
        (content?.parent as ViewGroup).removeView(content)
    }

    private fun convertDp2Px(dp: Double): Int {
        if (activity == null) {
            Log.e(NendPlugin.TAG,"PluginRegistry cannot given activity object...")
            return 0
        }

        return (dp.toFloat() * activity.resources.displayMetrics.density).toInt()
    }

    private fun layoutParamsFrom(arguments: Any): LinearLayout.LayoutParams {
        val frame = (arguments as JSONObject).getJSONObject("frame")
        val params = LinearLayout.LayoutParams(MATCH_PARENT, MATCH_PARENT)
        params.topMargin = convertDp2Px(frame.getDouble("y"))
        params.leftMargin = convertDp2Px(frame.getDouble("x"))

        return params
    }

    private fun isAdjustSizeFrom(arguments: Any): Boolean {
        return (arguments as JSONObject).getBoolean("adjustSize")
    }
}
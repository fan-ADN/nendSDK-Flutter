package net.nend.nendplugin

import android.app.Activity
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel.Result
import net.nend.android.NendAdVideo
import org.json.JSONObject

abstract class VideoAd<Ad : NendAdVideo>(private val activity: Activity?) : AdBridger() {

    var video: Ad? = null

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (targetMethod(call.method)) {
            MethodName.IsReady -> {
                return result.success(video?.isLoaded)
            }
            MethodName.LoadAd -> video?.loadAd()
            MethodName.ShowAd -> video?.showAd(activity)
            MethodName.ReleaseAd -> video?.releaseAd()
            MethodName.MediationName -> video?.setMediationName(call.argument("mediationName"))
            else -> return
        }
        result.success(true)
    }

    abstract fun initAd(adUnit: AdUnit?)

}

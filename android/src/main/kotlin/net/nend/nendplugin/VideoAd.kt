package net.nend.nendplugin

import android.app.Activity
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel.Result
import net.nend.android.NendAdUserFeature
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
            MethodName.UserId -> video?.setUserId(call.argument("userId"))
            MethodName.UserFeature -> video?.setUserFeature(generateUserFeatureFrom(call.arguments()))
            else -> return
        }
        result.success(true)
    }

    abstract fun initAd(adUnit: AdUnit?)

    private fun generateUserFeatureFrom(arguments: JSONObject): NendAdUserFeature {
        val builder = NendAdUserFeature.Builder().apply {
            arguments.optJSONObject("userFeature")?.let { userFeature ->
                if (userFeature.has("age")) {
                    setAge(userFeature.getInt("age"))
                }
                if (userFeature.has("gender")) userFeature.getInt("gender").let {
                    when (it) {
                        1 -> setGender(NendAdUserFeature.Gender.MALE)
                        2 -> setGender(NendAdUserFeature.Gender.FEMALE)
                        else -> {
                        }
                    }
                }
                userFeature.optJSONObject("birthday")?.let {
                    setBirthday(
                        it.getInt("year"),
                        it.getInt("month"),
                        it.getInt("day")
                    )
                }
                userFeature.optJSONObject("customStringParams")?.let {
                    parseCustomFeature(this, it)
                }
                userFeature.optJSONObject("customIntegerParams")?.let {
                    parseCustomFeature(this, it)
                }
                userFeature.optJSONObject("customDoubleParams")?.let {
                    parseCustomFeature(this, it)
                }
                userFeature.optJSONObject("customBooleanParams")?.let {
                    parseCustomFeature(this, it)
                }
            }
        }
        return builder.build()
    }

    private fun parseCustomFeature(builder: NendAdUserFeature.Builder, jsonObj: JSONObject) {
        val it = jsonObj.keys()
        while (it.hasNext()) {
            val key = it.next()
            builder.addCustomFeature(key, jsonObj.getString(key))
        }
    }
}

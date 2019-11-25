package net.nend.nendplugin

import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar
import net.nend.android.NendAdUserFeature
import net.nend.android.NendAdVideo
import org.json.JSONObject

open class VideoAd<Ad : NendAdVideo>(private var registrar: Registrar, protected val adUnit: Triple<String, Int, String>): AdBridger(registrar, adUnit.first) {

    open lateinit var video: Ad

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (getMethod(call, getTag(video))) {
            MethodName.IsReady -> {
                result.success(video.isLoaded)
                return
            }
            MethodName.LoadAd -> {
                video.loadAd()
            }
            MethodName.ShowAd -> {
                video.showAd(registrar.activity())
            }
            MethodName.ReleaseAd -> {
                video.releaseAd()
            }
           MethodName.MediationName -> {
                video.setMediationName(NendPlugin.simplePickFrom(call.arguments, "mediationName"))
            }
            MethodName.UserId -> {
                video.setUserId(NendPlugin.simplePickFrom(call.arguments, "userId"))
            }
            MethodName.UserFeature -> {
                video.setUserFeature(generateUserFeatureFrom(call.arguments))
            }
            MethodName.LocationEnabled -> {
                video.setLocationEnabled(NendPlugin.simplePickFrom(call.arguments, "locationEnabled").toBoolean())
            }
            else -> {
                super.onMethodCall(call, result)
                return
            }
        }
        result.success(true)
    }

    open fun invokeListenerEvent(event: CallbackName, args: Map<String, Any>?) {
        NendPlugin.channel.invokeMethod(getTag(video) + "." + event.toString().decapitalize(), mappingArguments(mappingId, args))
    }

    private fun generateUserFeatureFrom(arguments: Any): NendAdUserFeature {
        val builder = NendAdUserFeature.Builder().apply {
            (arguments as JSONObject).optJSONObject("userFeature")?.let { jsonObj ->
                if (jsonObj.has("age")) {
                    setAge(jsonObj.getInt("age"))
                }
                if (jsonObj.has("gender")) jsonObj.getInt("gender").let {
                    when (it) {
                        1 -> setGender(NendAdUserFeature.Gender.MALE)
                        2 -> setGender(NendAdUserFeature.Gender.FEMALE)
                        else -> {
                        }
                    }
                }
                jsonObj.optJSONObject("birthday")?.let {
                    setBirthday(
                            it.getInt("year"),
                            it.getInt("month"),
                            it.getInt("day")
                    )
                }
                jsonObj.optJSONObject("customStringParams")?.let {
                    parseCustomFeature(this, it)
                }
                jsonObj.optJSONObject("customIntegerParams")?.let {
                    parseCustomFeature(this, it)
                }
                jsonObj.optJSONObject("customDoubleParams")?.let {
                    parseCustomFeature(this, it)
                }
                jsonObj.optJSONObject("customBooleanParams")?.let {
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

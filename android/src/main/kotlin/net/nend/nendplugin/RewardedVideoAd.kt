package net.nend.nendplugin

import android.app.Activity
import android.content.Context
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.JSONMethodCodec
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import net.nend.android.NendAdRewardItem
import net.nend.android.NendAdRewardedActionListener
import net.nend.android.NendAdRewardedVideo
import net.nend.android.NendAdVideo
import net.nend.android.NendAdVideoActionListener
import net.nend.android.NendAdVideoPlayingStateListener
import net.nend.android.NendAdVideoType
import org.json.JSONObject
import java.util.Locale

class RewardedVideoAd(
    activity: Activity?,
    private val context: Context?,
    messenger: BinaryMessenger
) : MethodChannel.MethodCallHandler, VideoAd<NendAdRewardedVideo>(activity) {

    override val methodChannel =
        MethodChannel(messenger, "nend_plugin/NendAdRewardedVideo", JSONMethodCodec.INSTANCE)

    init {
        methodChannel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (targetMethod(call.method)) {
            MethodName.InitAd -> {
                call.arguments<JSONObject?>()?.let {
                    val adUnit = AdUnit.fromArguments(it)
                    initAd(adUnit)
                    result.success(true)
                }
            }
            else -> super.onMethodCall(call, result)
        }
    }

    override fun initAd(adUnit: AdUnit?) {
        adUnit?.let { (spotId, apiKey) ->
            video = NendAdRewardedVideo(context, spotId, apiKey)
            registerListener()
        }
    }

    private fun registerListener() {
        video?.setActionListener(object : NendAdVideoActionListener, NendAdRewardedActionListener {
            override fun onRewarded(p0: NendAdVideo, reward: NendAdRewardItem) {
                methodChannel.invokeListenerEvent(
                    CallbackName.OnRewarded,
                    mapOf(
                        "reward" to mapOf(
                            "name" to reward.currencyName,
                            "amount" to reward.currencyAmount
                        )
                    )
                )
            }

            override fun onLoaded(videoAd: NendAdVideo) {
                when (videoAd.type) {
                    NendAdVideoType.NORMAL -> videoAd.playingState()?.let {
                        it.playingStateListener = object : NendAdVideoPlayingStateListener {
                            override fun onStarted(p0: NendAdVideo) {
                                methodChannel.invokeListenerEvent(CallbackName.OnStarted, null)
                            }

                            override fun onStopped(p0: NendAdVideo) {
                                methodChannel.invokeListenerEvent(CallbackName.OnStopped, null)
                            }

                            override fun onCompleted(p0: NendAdVideo) {
                                methodChannel.invokeListenerEvent(CallbackName.OnCompleted, null)
                            }
                        }
                    }
                    else -> {
                    }
                }
                methodChannel.invokeListenerEvent(CallbackName.OnLoaded, null)
                methodChannel.invokeListenerEvent(
                    CallbackName.OnDetectedVideoType,
                    mapOf("type" to videoAd.type.toString().toLowerCase(Locale.ROOT))
                )
            }

            override fun onFailedToLoad(p0: NendAdVideo, p1: Int) {
                methodChannel.invokeListenerEvent(CallbackName.OnFailedToLoad, null)
            }

            override fun onFailedToPlay(p0: NendAdVideo) {
                methodChannel.invokeListenerEvent(CallbackName.OnFailedToPlay, null)
            }

            override fun onShown(p0: NendAdVideo) {
                methodChannel.invokeListenerEvent(CallbackName.OnShown, null)
            }

            override fun onClosed(p0: NendAdVideo) {
                methodChannel.invokeListenerEvent(CallbackName.OnClosed, null)
            }

            override fun onAdClicked(p0: NendAdVideo) {
                methodChannel.invokeListenerEvent(CallbackName.OnAdClicked, null)
            }

            override fun onInformationClicked(p0: NendAdVideo) {
                methodChannel.invokeListenerEvent(CallbackName.OnInformationClicked, null)
            }
        })
    }
}
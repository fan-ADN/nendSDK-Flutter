package net.nend.nendplugin

import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry
import net.nend.android.NendAdInterstitialVideo
import net.nend.android.NendAdVideo
import net.nend.android.NendAdVideoListener

class InterstitialVideoAd(registrar: PluginRegistry.Registrar, arguments: Any) : VideoAd<NendAdInterstitialVideo>(registrar, NendPlugin.getAdUnitFrom(arguments)) {
    init {
        video = NendAdInterstitialVideo(registrar.context(), adUnit.second, adUnit.third)
        video.setAdListener(object : NendAdVideoListener {
            override fun onLoaded(p0: NendAdVideo) {
                invokeListenerEvent(CallbackName.OnLoaded, null)
            }

            override fun onFailedToLoad(p0: NendAdVideo, p1: Int) {
                invokeListenerEvent(CallbackName.OnFailedToLoad, mapOf(KEY_ERROR_CODE to p1))
            }

            override fun onFailedToPlay(p0: NendAdVideo) {
                invokeListenerEvent(CallbackName.OnFailedToPlay, null)
            }

            override fun onShown(p0: NendAdVideo) {
                invokeListenerEvent(CallbackName.OnShown, null)
            }

            override fun onStarted(p0: NendAdVideo) {
                invokeListenerEvent(CallbackName.OnStarted, null)
            }

            override fun onStopped(p0: NendAdVideo) {
                invokeListenerEvent(CallbackName.OnStopped, null)
            }

            override fun onCompleted(p0: NendAdVideo) {
                invokeListenerEvent(CallbackName.OnCompleted, null)
            }

            override fun onInformationClicked(p0: NendAdVideo) {
                invokeListenerEvent(CallbackName.OnInformationClicked, null)
            }

            override fun onAdClicked(p0: NendAdVideo) {
                invokeListenerEvent(CallbackName.OnAdClicked, null)
            }

            override fun onClosed(p0: NendAdVideo) {
                invokeListenerEvent(CallbackName.OnClosed, null)
            }
        })
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (getMethod(call, getTag(video))) {
            MethodName.AddFallbackFullboard -> {
                val fallbackUnit = NendPlugin.getAdUnitFrom(call.arguments)
                video.addFallbackFullboard(fallbackUnit.second, fallbackUnit.third)
                result.success(null)
            }
            MethodName.MuteStartPlaying -> {
                video.isMuteStartPlaying = NendPlugin.simplePickFrom(call.arguments, "muteStartPlaying").toBoolean()
            }
            else -> {
                super.onMethodCall(call, result)
            }
        }
    }
}
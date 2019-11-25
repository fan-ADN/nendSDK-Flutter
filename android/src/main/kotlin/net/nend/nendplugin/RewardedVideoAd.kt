package net.nend.nendplugin

import io.flutter.plugin.common.PluginRegistry
import net.nend.android.NendAdRewardItem
import net.nend.android.NendAdRewardedListener
import net.nend.android.NendAdRewardedVideo
import net.nend.android.NendAdVideo

class RewardedVideoAd(registrar: PluginRegistry.Registrar, arguments: Any) : VideoAd<NendAdRewardedVideo>(registrar, NendPlugin.getAdUnitFrom(arguments)) {
    init {
        video = NendAdRewardedVideo(registrar.context(), adUnit.second, adUnit.third)
        video.setAdListener(object : NendAdRewardedListener {
            override fun onRewarded(p0: NendAdVideo, p1: NendAdRewardItem) {
                val reward = mapOf("currencyAmount" to p1.currencyAmount, "currencyName" to p1.currencyName)
                invokeListenerEvent(CallbackName.OnRewarded, mapOf("reward" to reward))
            }

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
}
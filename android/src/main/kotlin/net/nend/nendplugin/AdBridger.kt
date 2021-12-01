package net.nend.nendplugin

import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.util.Locale

abstract class AdBridger {

    abstract val methodChannel: MethodChannel

    open fun onMethodCall(call: MethodCall, result: MethodChannel.Result) = result.notImplemented()

    fun MethodChannel.invokeListenerEvent(event: CallbackName, args: Map<String, Any>?) {
        this.invokeMethod(
            event.toString().decapitalize(Locale.ROOT),
            args
        )
    }

    protected fun targetMethod(method: String): MethodName {
        return MethodName.valueOf(method.capitalize(Locale.ROOT))
    }

    enum class MethodName {
        LoadAd,
        ReleaseAd,
        ShowAd,
        HideAd,
        // Common definitions are above here.

        Resume,
        Pause,

        IsReady,
        MediationName,
        UserId,
        UserFeature,
        AddFallbackFullboard,
        EnableAutoReload,
        DismissAd,
        MuteStartPlaying,

        // Specific definitions are above here.
        InitAd,
        SetLogLevel,
    }

    enum class CallbackName {
        OnLoaded,
        OnFailedToLoad,
        OnAdClicked,
        OnInformationClicked,
        // Common definitions are above here.

        OnFailedToPlay,
        OnShown,
        OnClosed,
        OnStarted,
        OnStopped,
        OnCompleted,
        OnRewarded,
        OnFailedToShow,
        OnDetectedVideoType,
        // Specific definitions are above here.
    }

    companion object {
        const val KEY_RESULT = "result"
    }
}

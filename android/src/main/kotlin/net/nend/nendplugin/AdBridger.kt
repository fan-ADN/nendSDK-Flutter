package net.nend.nendplugin

import android.app.Activity
import android.util.Log
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry

const val KEY_ERROR_CODE = "errorCode"

open class AdBridger(registrar: PluginRegistry.Registrar, val mappingId: String) {
    val activity: Activity? = registrar.activity()

    protected fun getTag(by: Any): String {
        return by.javaClass.simpleName
    }

    protected fun getMethod(call: MethodCall, tag: String): MethodName =
            MethodName.valueOf(call.method.replace("$tag.", "").capitalize())

    protected fun mappingArguments(mappingId: String, args: Map<String, Any>?): Map<String, Any> {
        if (args == null) {
            return mapOf(NendPlugin.KEY_MAPPING_ID to mappingId)
        }
        if (args[NendPlugin.KEY_MAPPING_ID] != null) {
            Log.e(NendPlugin.TAG, "${NendPlugin.KEY_MAPPING_ID} is reserved key for mapping arguments...")
            throw RuntimeException()
        }
        val map = args.toMutableMap()
        map[NendPlugin.KEY_MAPPING_ID] = mappingId
        return map
    }

    open fun onMethodCall(call: MethodCall, result: MethodChannel.Result) = result.notImplemented()

    enum class MethodName {
        LoadAd,
        ReleaseAd,
        ShowAd,
        HideAd,
        Layout,
        // Common definitions are above here.

        Resume,
        Pause,

        IsReady,
        MediationName,
        UserId,
        UserFeature,
        AddFallbackFullboard,
        IsEnableAutoReload,
        EnableAutoReload,
        DisableAutoReload,
        DismissAd,
        LocationEnabled,
        MuteStartPlaying,

        PerformAdClick,
        PerformInformationClick,
        Activate,
        // Specific definitions are above here.
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
        // Specific definitions are above here.
    }
}
package net.nend.nendplugin

import android.app.Activity
import android.content.Context
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.BinaryMessenger

class NendPlugin : FlutterPlugin, ActivityAware {
    private var activity: Activity? = null
    private var context: Context? = null
    private var messenger: BinaryMessenger? = null

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        flutterPluginBinding.platformViewRegistry.registerViewFactory(
            "nend_plugin/banner",
            BannerAdFactory(flutterPluginBinding.binaryMessenger)
        )
        context = flutterPluginBinding.applicationContext
        messenger = flutterPluginBinding.binaryMessenger
        AdLogger(messenger)
    }

    override fun onDetachedFromEngine(p0: FlutterPlugin.FlutterPluginBinding) {
        context = null
        messenger = null
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
        InterstitialAd(activity, context, messenger)
        RewardedVideoAd(activity, context, messenger)
        InterstitialVideoAd(activity, context, messenger)
    }

    override fun onDetachedFromActivityForConfigChanges() {
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity
        InterstitialAd(activity, context, messenger)
        RewardedVideoAd(activity, context, messenger)
        InterstitialVideoAd(activity, context, messenger)
    }

    override fun onDetachedFromActivity() {
        activity = null
    }

    companion object {
        const val TAG = "NendPlugin"
    }
}

package net.nend.nendplugin

import android.app.Activity
import android.content.Context
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.BinaryMessenger

class NendPlugin : FlutterPlugin, ActivityAware {
    private lateinit var flutterPluginBinding: FlutterPlugin.FlutterPluginBinding

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        this.flutterPluginBinding = binding
        flutterPluginBinding.platformViewRegistry.registerViewFactory(
            "nend_plugin/banner",
            BannerAdFactory(binding.applicationContext, binding.binaryMessenger)
        )
        AdLogger(binding.binaryMessenger)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        InterstitialAd(
            binding.activity,
            flutterPluginBinding.applicationContext,
            flutterPluginBinding.binaryMessenger
        )
        RewardedVideoAd(
            binding.activity,
            flutterPluginBinding.applicationContext,
            flutterPluginBinding.binaryMessenger
        )
        InterstitialVideoAd(
            binding.activity,
            flutterPluginBinding.applicationContext,
            flutterPluginBinding.binaryMessenger
        )
    }

    override fun onDetachedFromActivityForConfigChanges() {
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        InterstitialAd(
            binding.activity,
            flutterPluginBinding.applicationContext,
            flutterPluginBinding.binaryMessenger
        )
        RewardedVideoAd(
            binding.activity,
            flutterPluginBinding.applicationContext,
            flutterPluginBinding.binaryMessenger
        )
        InterstitialVideoAd(
            binding.activity,
            flutterPluginBinding.applicationContext,
            flutterPluginBinding.binaryMessenger
        )
    }

    override fun onDetachedFromActivity() {
    }

    companion object {
        const val TAG = "NendPlugin"
    }
}

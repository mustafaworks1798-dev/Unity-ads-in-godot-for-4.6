package com.replit.unityadsplugin

import com.unity3d.ads.IUnityAdsInitializationListener
import com.unity3d.ads.IUnityAdsLoadListener
import com.unity3d.ads.IUnityAdsShowListener
import com.unity3d.ads.UnityAds
import com.unity3d.ads.UnityAdsShowOptions
import org.godotengine.godot.Godot
import org.godotengine.godot.plugin.GodotPlugin
import org.godotengine.godot.plugin.SignalInfo
import org.godotengine.godot.plugin.UsedByGodot

class UnityAdsPlugin(godot: Godot) : GodotPlugin(godot),
    IUnityAdsInitializationListener,
    IUnityAdsLoadListener,
    IUnityAdsShowListener {

    override fun getPluginName() = "UnityAds"

    override fun getPluginSignals(): Set<SignalInfo> {
        return setOf(
            SignalInfo("initialization_complete"),
            SignalInfo("initialization_failed", String::class.java),
            SignalInfo("ad_loaded", String::class.java),
            SignalInfo("ad_failed_to_load", String::class.java, String::class.java),
            SignalInfo("ad_showed", String::class.java),
            SignalInfo("ad_failed_to_show", String::class.java, String::class.java),
            SignalInfo("ad_clicked", String::class.java),
            SignalInfo("ad_closed", String::class.java),
        )
    }

    @UsedByGodot
    fun initialize(gameId: String, testMode: Boolean) {
        runOnUiThread {
            UnityAds.initialize(activity!!, gameId, testMode, this)
        }
    }

    @UsedByGodot
    fun load_ad(placementId: String) {
        UnityAds.load(placementId, this)
    }

    @UsedByGodot
    fun show_ad(placementId: String) {
        runOnUiThread {
            UnityAds.show(activity!!, placementId, UnityAdsShowOptions(), this)
        }
    }

    @UsedByGodot
    fun is_initialized(): Boolean = UnityAds.isInitialized()

    // --- Initialization Callbacks ---
    override fun onInitializationComplete() {
        emitSignal("initialization_complete")
    }

    override fun onInitializationFailed(
        error: UnityAds.UnityAdsInitializationError,
        message: String
    ) {
        emitSignal("initialization_failed", message)
    }

    // --- Load Callbacks ---
    override fun onUnityAdsAdLoaded(placementId: String) {
        emitSignal("ad_loaded", placementId)
    }

    override fun onUnityAdsFailedToLoad(
        placementId: String,
        error: UnityAds.UnityAdsLoadError,
        message: String
    ) {
        emitSignal("ad_failed_to_load", placementId, message)
    }

    // --- Show Callbacks ---
    override fun onUnityAdsShowComplete(
        placementId: String,
        state: UnityAds.UnityAdsShowCompletionState
    ) {
        emitSignal("ad_closed", placementId)
    }

    override fun onUnityAdsShowFailure(
        placementId: String,
        error: UnityAds.UnityAdsShowError,
        message: String
    ) {
        emitSignal("ad_failed_to_show", placementId, message)
    }

    override fun onUnityAdsShowStart(placementId: String) {
        emitSignal("ad_showed", placementId)
    }

    override fun onUnityAdsShowClick(placementId: String) {
        emitSignal("ad_clicked", placementId)
    }
}

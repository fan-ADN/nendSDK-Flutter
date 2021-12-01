package net.nend.nendplugin

import org.json.JSONObject

data class AdUnit(val spotId: Int, val apiKey: String) {
    companion object {
        fun fromArguments(arguments: JSONObject): AdUnit? = runCatching {
            arguments.let { adUnit ->
                AdUnit(adUnit.getInt("spotId"), adUnit.getString("apiKey"))
            }
        }.getOrNull()
    }
}

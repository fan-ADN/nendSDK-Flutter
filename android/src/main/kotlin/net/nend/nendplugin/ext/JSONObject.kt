package net.nend.nendplugin.ext

import org.json.JSONObject

fun JSONObject.maybeInt(key: String): Int? = runCatching {
    this.getInt(key)
}.getOrNull()

fun JSONObject.maybeBoolean(key: String): Boolean? = runCatching {
    this.getBoolean(key)
}.getOrNull()


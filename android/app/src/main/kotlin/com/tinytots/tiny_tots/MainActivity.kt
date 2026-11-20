package com.tinytots.tiny_tots

import android.content.Context
import android.speech.tts.TextToSpeech
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.util.Locale

/** Native, offline-only bridge for pronunciation and learning progress. */
class MainActivity : FlutterActivity(), TextToSpeech.OnInitListener {
    private val channelName = "tiny_tots/learning"
    private lateinit var textToSpeech: TextToSpeech
    private var speechReady = false

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        textToSpeech = TextToSpeech(this, this)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName)
            .setMethodCallHandler { call, result -> handleCall(call, result) }
    }

    override fun onInit(status: Int) {
        speechReady = status == TextToSpeech.SUCCESS
        if (speechReady) {
            textToSpeech.language = Locale.US
            textToSpeech.setSpeechRate(0.82f)
            textToSpeech.setPitch(1.05f)
        }
    }

    private fun handleCall(call: MethodCall, result: MethodChannel.Result) {
        val preferences = getSharedPreferences("tiny_tots_progress", Context.MODE_PRIVATE)
        when (call.method) {
            "loadCategoryProgress" -> {
                val cat = call.argument<String>("category") ?: "abc"
                result.success(mapOf(
                    "explored" to preferences.getString("explored_$cat", ""),
                    "lastIndex" to preferences.getInt("lastIndex_$cat", 0)
                ))
            }
            "saveCategoryProgress" -> {
                val cat = call.argument<String>("category") ?: "abc"
                preferences.edit()
                    .putString("explored_$cat", call.argument<String>("explored") ?: "")
                    .putInt("lastIndex_$cat", call.argument<Int>("lastIndex") ?: 0)
                    .apply()
                result.success(null)
            }
            "loadProgress" -> result.success(mapOf(
                "explored" to preferences.getString("explored_abc", preferences.getString("explored", "")),
                "lastIndex" to preferences.getInt("lastIndex_abc", preferences.getInt("lastIndex", 0))
            ))
            "saveProgress" -> {
                preferences.edit()
                    .putString("explored_abc", call.argument<String>("explored") ?: "")
                    .putInt("lastIndex_abc", call.argument<Int>("lastIndex") ?: 0)
                    .apply()
                result.success(null)
            }
            "speak" -> {
                if (speechReady) {
                    textToSpeech.stop()
                    textToSpeech.speak(call.argument<String>("text") ?: "", TextToSpeech.QUEUE_FLUSH, null, "tiny_tots_card")
                }
                result.success(null)
            }
            "stop" -> { if (speechReady) textToSpeech.stop(); result.success(null) }
            else -> result.notImplemented()
        }
    }

    override fun onDestroy() {
        if (::textToSpeech.isInitialized) {
            textToSpeech.stop()
            textToSpeech.shutdown()
        }
        super.onDestroy()
    }
}

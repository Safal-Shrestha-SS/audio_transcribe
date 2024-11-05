package com.example.verygoodcore

import android.Manifest
import android.app.Activity
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Bundle
import android.speech.RecognitionListener
import android.speech.RecognizerIntent
import android.speech.SpeechRecognizer
import android.util.Log
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry
import java.util.Locale


class AudioTranscribePlugin : FlutterPlugin, MethodCallHandler, ActivityAware,
    PluginRegistry.ActivityResultListener, EventChannel.StreamHandler {
    private lateinit var channel: MethodChannel
    private var context: Context? = null
    private var mActivity: Activity? = null
    private var speechRecognizer: SpeechRecognizer? = null
    private var speechRecognizerIntent: Intent? = null
    private var audioText: String = ""

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "audio_transcribe_android")
        channel.setMethodCallHandler(this)
        context = flutterPluginBinding.applicationContext
        speechRecognizer = SpeechRecognizer.createSpeechRecognizer(context)
        speechRecognizerIntent = Intent(RecognizerIntent.ACTION_RECOGNIZE_SPEECH)
        speechRecognizerIntent!!.putExtra(
            RecognizerIntent.EXTRA_LANGUAGE_MODEL,
            RecognizerIntent.LANGUAGE_MODEL_FREE_FORM
        )
        speechRecognizerIntent!!.putExtra(RecognizerIntent.EXTRA_LANGUAGE, Locale.getDefault())
        speechRecognizer!!.setRecognitionListener(object : RecognitionListener {
            override fun onReadyForSpeech(params: Bundle?) {
                Log.d("Flutter", "onReadyForSpeech")
            }

            override fun onBeginningOfSpeech() {
                Log.d("Flutter", "onBeginningOfSpeech")

            }

            override fun onRmsChanged(rmsdB: Float) {
            }

            override fun onBufferReceived(buffer: ByteArray?) {
            }

            override fun onEndOfSpeech() {
                Log.d("Flutter", "onEndOfSpeech")
            }

            override fun onError(error: Int) {
            }

            override fun onResults(results: Bundle?) {
                val matches = results?.getStringArrayList(SpeechRecognizer.RESULTS_RECOGNITION)
                if (matches.isNullOrEmpty().not()) {
                    audioText = matches?.get(0) ?: ""
                    Log.d("Flutter", audioText)
                }
            }

            override fun onPartialResults(partialResults: Bundle?) {
            }

            override fun onEvent(eventType: Int, params: Bundle?) {
                TODO("Not yet implemented")
            }

        })
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "getPlatformName" -> {
                result.success("Android")
            }

            "getAudioText" -> {
                result.success(audioText)
            }

            "startListening" -> {
                Log.d("Flutter", "startListening Called")
                hasRecordPermission()
                try {
                    speechRecognizer!!.startListening(speechRecognizerIntent)
                } catch (e: Exception) {
                    Log.d("Flutter", "startListening ${e.message}")
                }
                Log.d("Flutter", "getAudioText start")
            }

            "stopListening" -> {
                Log.d("Flutter", "stopListening Called")
                speechRecognizer!!.stopListening()
            }

            else -> {
                result.notImplemented()
            }
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
        context = null
    }

    override fun onAttachedToActivity(p0: ActivityPluginBinding) {
        Log.d("Flutter", "Attaching activity")
        mActivity = p0.activity
        p0.addActivityResultListener(this);

    }

    override fun onDetachedFromActivityForConfigChanges() {
    }

    override fun onReattachedToActivityForConfigChanges(p0: ActivityPluginBinding) {
        this.mActivity = p0.activity;
    }

    override fun onDetachedFromActivity() {
    }

    private fun hasRecordPermission(): Boolean {
        if (ContextCompat.checkSelfPermission(
                mActivity!!.applicationContext,
                Manifest.permission.RECORD_AUDIO
            ) != PackageManager.PERMISSION_GRANTED
        ) {
            // Permission is not granted, request it
            ActivityCompat.requestPermissions(
                mActivity!!,
                arrayOf(Manifest.permission.RECORD_AUDIO),
                65656
            )
        } else {
            return true
        }
        return false
    }

    override fun onActivityResult(p0: Int, p1: Int, p2: Intent?): Boolean {
        return p0 == 65656
    }


    override fun onListen(p0: Any?, p1: EventChannel.EventSink?) {
        TODO("Not yet implemented")
    }

    override fun onCancel(p0: Any?) {
        TODO("Not yet implemented")
    }
}
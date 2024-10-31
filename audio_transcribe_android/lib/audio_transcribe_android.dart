import 'package:audio_transcribe_platform_interface/audio_transcribe_platform_interface.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// The Android implementation of [AudioTranscribePlatform].
class AudioTranscribeAndroid extends AudioTranscribePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('audio_transcribe_android');

  /// Registers this class as the default instance of [AudioTranscribePlatform]
  static void registerWith() {
    AudioTranscribePlatform.instance = AudioTranscribeAndroid();
  }

  @override
  Future<String?> getPlatformName() {
    return methodChannel.invokeMethod<String>('getPlatformName');
  }

  @override
  Future<String?> getAudioText() {
    return methodChannel.invokeMethod<String>('getAudioText');
  }

  @override
  Future<void> startListening() async {
    return methodChannel.invokeMethod<void>('startListening');
  }

  @override
  Future<void> stopListening() async {
    return methodChannel.invokeMethod<void>('stopListening');
  }
}

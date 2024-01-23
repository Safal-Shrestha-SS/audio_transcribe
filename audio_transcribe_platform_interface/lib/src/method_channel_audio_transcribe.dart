import 'package:audio_transcribe_platform_interface/audio_transcribe_platform_interface.dart';
import 'package:flutter/foundation.dart' show visibleForTesting;
import 'package:flutter/services.dart';

/// An implementation of [AudioTranscribePlatform] that uses method channels.
class MethodChannelAudioTranscribe extends AudioTranscribePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('audio_transcribe');

  @override
  Future<String?> getPlatformName() {
    return methodChannel.invokeMethod<String>('getPlatformName');
  }

  @override
  Future<String?> getAudioText() {
    return methodChannel.invokeMethod<String>('getAudioText');
  }
  
  @override
  Future<void> startListening() {
    return methodChannel.invokeMethod<String>('startListeningetAudioText');
  }
  
  @override
  Future<void> stopListening() {
    return methodChannel.invokeMethod<String>('stopListening');
  }
}

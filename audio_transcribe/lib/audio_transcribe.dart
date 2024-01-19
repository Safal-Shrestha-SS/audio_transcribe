// ignore_for_file: public_member_api_docs

import 'package:audio_transcribe_platform_interface/audio_transcribe_platform_interface.dart';

AudioTranscribePlatform get _platform => AudioTranscribePlatform.instance;

/// Returns the name of the current platform.
Future<String> getPlatformName() async {
  final platformName = await _platform.getPlatformName();
  if (platformName == null) throw Exception('Unable to get platform name.');
  return platformName;
}

Future<String> getAudioText() async {
  final platformText = await _platform.getAudioText();
  if (platformText == null) throw Exception('Unable to get audio Text.');
  return platformText;
}

Future<void> startListening() async {
  await _platform.startListening();
}

Future<void> stopListening() async {
  await _platform.stopListening();
}

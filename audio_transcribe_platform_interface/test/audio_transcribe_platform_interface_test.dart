import 'package:audio_transcribe_platform_interface/audio_transcribe_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';

class AudioTranscribeMock extends AudioTranscribePlatform {
  static const mockPlatformName = 'Mock';
  static const mockAudioText = 'Hello World';
  @override
  Future<String?> getPlatformName() async => mockPlatformName;
  
  @override
  Future<String?> getAudioText() async => mockAudioText;
  
  @override
  Future<void> startListening() {
    throw UnimplementedError();
  }
  
  @override
  Future<void> stopListening() {
    throw UnimplementedError();
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('AudioTranscribePlatformInterface', () {
    late AudioTranscribePlatform audioTranscribePlatform;

    setUp(() {
      audioTranscribePlatform = AudioTranscribeMock();
      AudioTranscribePlatform.instance = audioTranscribePlatform;
    });

    group('getPlatformName', () {
      test('returns correct name', () async {
        expect(
          await AudioTranscribePlatform.instance.getPlatformName(),
          equals(AudioTranscribeMock.mockPlatformName),
        );
      });

        test('returns correct audio', () async {
        expect(
          await AudioTranscribePlatform.instance.getAudioText(),
          equals(AudioTranscribeMock.mockAudioText),
        );
      });
    });
  });
}

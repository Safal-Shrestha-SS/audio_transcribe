import 'package:audio_transcribe/audio_transcribe.dart';
import 'package:audio_transcribe_platform_interface/audio_transcribe_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockAudioTranscribePlatform extends Mock
    with MockPlatformInterfaceMixin
    implements AudioTranscribePlatform {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AudioTranscribe', () {
    late AudioTranscribePlatform audioTranscribePlatform;

    setUp(() {
      audioTranscribePlatform = MockAudioTranscribePlatform();
      AudioTranscribePlatform.instance = audioTranscribePlatform;
    });

    group('getPlatformName', () {
      test('returns correct name when platform implementation exists',
          () async {
        const platformName = '__test_platform__';
        when(
          () => audioTranscribePlatform.getPlatformName(),
        ).thenAnswer((_) async => platformName);

        final actualPlatformName = await getPlatformName();
        expect(actualPlatformName, equals(platformName));
      });

      test('throws exception when platform implementation is missing',
          () async {
        when(
          () => audioTranscribePlatform.getPlatformName(),
        ).thenAnswer((_) async => null);

        expect(getPlatformName, throwsException);
      });
    });
  });
}

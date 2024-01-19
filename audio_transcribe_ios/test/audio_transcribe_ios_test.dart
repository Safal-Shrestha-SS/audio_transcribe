import 'package:audio_transcribe_ios/audio_transcribe_ios.dart';
import 'package:audio_transcribe_platform_interface/audio_transcribe_platform_interface.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AudioTranscribeIOS', () {
    const kPlatformName = 'iOS';
    late AudioTranscribeIOS audioTranscribe;
    late List<MethodCall> log;

    setUp(() async {
      audioTranscribe = AudioTranscribeIOS();

      log = <MethodCall>[];
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(audioTranscribe.methodChannel, (methodCall) async {
        log.add(methodCall);
        switch (methodCall.method) {
          case 'getPlatformName':
            return kPlatformName;
          default:
            return null;
        }
      });
    });

    test('can be registered', () {
      AudioTranscribeIOS.registerWith();
      expect(AudioTranscribePlatform.instance, isA<AudioTranscribeIOS>());
    });

    test('getPlatformName returns correct name', () async {
      final name = await audioTranscribe.getPlatformName();
      expect(
        log,
        <Matcher>[isMethodCall('getPlatformName', arguments: null)],
      );
      expect(name, equals(kPlatformName));
    });
  });
}

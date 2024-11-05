import 'package:audio_transcribe_platform_interface/src/method_channel_audio_transcribe.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

/// The interface that implementations of audio_transcribe must implement.
///
/// Platform implementations should extend this class
/// rather than implement it as `AudioTranscribe`.
/// Extending this class (using `extends`) ensures that the subclass will get
/// the default implementation, while platform implementations that `implements`
///  this interface will be broken by newly added [AudioTranscribePlatform] methods.
abstract class AudioTranscribePlatform extends PlatformInterface {
  /// Constructs a AudioTranscribePlatform.
  AudioTranscribePlatform() : super(token: _token);

  static final Object _token = Object();

  static AudioTranscribePlatform _instance = MethodChannelAudioTranscribe();

  /// The default instance of [AudioTranscribePlatform] to use.
  ///
  /// Defaults to [MethodChannelAudioTranscribe].
  static AudioTranscribePlatform get instance => _instance;

  /// Platform-specific plugins should set this with their own platform-specific
  /// class that extends [AudioTranscribePlatform] when they register themselves.
  static set instance(AudioTranscribePlatform instance) {
    PlatformInterface.verify(instance, _token);
    _instance = instance;
  }

  /// Return the current platform name.
  Future<String?> getPlatformName();

  // Added methods after creating the plugin
  /// Return the current platform name.
  Future<String?> getAudioText();

  /// Return the current platform name.
  Future<void> startListening();

  /// Return the current platform name.
  Future<void> stopListening();
}

# audio_transcribe_ios

[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]

The ios implementation of `audio_transcribe`.

# AudioTranscribePlugin.swift Documentation

## Overview

`AudioTranscribePlugin` is a Flutter plugin for iOS that provides functionalities for speech recognition. It uses the `SFSpeechRecognizer` class from the `Speech` framework to transcribe audio to text.

## Classes

### AudioTranscribePlugin

#### Properties

- `speechRecognizer: SFSpeechRecognizer?`
    - An instance of `SFSpeechRecognizer` used to recognize speech.

- `recognitionRequest: SFSpeechAudioBufferRecognitionRequest?`
    - An instance of `SFSpeechAudioBufferRecognitionRequest` used to manage the audio buffer for speech recognition.

- `recognitionTask: SFSpeechRecognitionTask?`
    - An instance of `SFSpeechRecognitionTask` used to manage the speech recognition task.

- `audioEngine: AVAudioEngine`
    - An instance of `AVAudioEngine` used to manage the audio input.

- `resultText: String`
    - A string to store the recognized text.

#### Methods

- `public static func register(with registrar: FlutterPluginRegistrar)`
    - Registers the plugin with the Flutter plugin registrar.

- `public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult)`
    - Handles method calls from the Flutter side. Supports the following methods:
        - `getPlatformName`: Returns the platform name and version.
        - `getAudioText`: Returns the recognized text.
        - `startListening`: Starts the speech recognition process.
        - `stopListening`: Stops the speech recognition process.

- `private func startListening(result: @escaping FlutterResult)`
    - Starts the speech recognition process. Requests authorization if not already authorized.

- `private func startSpeechRecognition(result: @escaping FlutterResult)`
    - Configures the audio session and starts the speech recognition task.

- `private func stopListening(result: @escaping FlutterResult)`
    - Stops the speech recognition process and ends the audio session.

## Usage

To use the `AudioTranscribePlugin`, you need to register it in your Flutter project and call the appropriate methods from the Dart side.

### Register the Plugin
## Usage

This package is [endorsed][endorsed_link], which means you can simply use `audio_transcribe`
normally. This package will be automatically included in your app when you do.

[endorsed_link]: https://flutter.dev/docs/development/packages-and-plugins/developing-packages#endorsed-federated-plugin
[very_good_analysis_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis
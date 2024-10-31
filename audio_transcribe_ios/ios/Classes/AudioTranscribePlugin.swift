import AVFoundation
import Speech
import Flutter

public class AudioTranscribePlugin: NSObject, FlutterPlugin {
    private var speechRecognizer: SFSpeechRecognizer?
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private var audioEngine = AVAudioEngine()
    private var resultText = ""
    private var channel: FlutterMethodChannel?

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "audio_transcribe_ios", binaryMessenger: registrar.messenger())
        let instance = AudioTranscribePlugin()
        instance.channel = channel  // Store channel reference
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "getPlatformName":
            result("iOS " + UIDevice.current.systemVersion)
        case "getAudioText":
            result(resultText)  // Return the current resultText
        case "startListening":
            startListening(result: result)
        case "stopListening":
            stopListening(result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    private func startListening(result: @escaping FlutterResult) {
        // Initialize speech recognizer if not already done
        speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))

        guard let speechRecognizer = speechRecognizer else {
            result(FlutterError(code: "speech_recognizer_error",
                              message: "Speech recognizer not available",
                              details: nil))
            return
        }

        if !speechRecognizer.isAvailable {
            result(FlutterError(code: "speech_recognizer_error",
                              message: "Speech recognizer is not available",
                              details: nil))
            return
        }

        // Check if the audio engine is already running
        if audioEngine.isRunning {
            audioEngine.stop()
            audioEngine.inputNode.removeTap(onBus: 0)
        }

        // Request authorization for speech recognition
        SFSpeechRecognizer.requestAuthorization { [weak self] authStatus in
            guard let self = self else { return }

            DispatchQueue.main.async {
                switch authStatus {
                case .authorized:
                    self.startSpeechRecognition(result: result)
                case .denied, .restricted, .notDetermined:
                    result(FlutterError(code: "speech_recognition_not_authorized",
                                      message: "Speech recognition not authorized",
                                      details: nil))
                @unknown default:
                    result(FlutterError(code: "speech_recognition_unknown_error",
                                      message: "Unknown error",
                                      details: nil))
                }
            }
        }
    }

    private func startSpeechRecognition(result: @escaping FlutterResult) {
        // Configure the audio session
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            result(FlutterError(code: "audio_session_error",
                              message: "Audio session configuration error",
                              details: error.localizedDescription))
            return
        }

        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else {
            result(FlutterError(code: "recognition_request_error",
                              message: "Unable to create recognition request",
                              details: nil))
            return
        }

        let inputNode = audioEngine.inputNode
        recognitionRequest.shouldReportPartialResults = true

        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) { [weak self] result, error in
            guard let self = self else { return }

            if let error = error {
                DispatchQueue.main.async {
                    self.channel?.invokeMethod("onError", arguments: error.localizedDescription)
                }
                return
            }

            if let result = result {
                self.resultText = result.bestTranscription.formattedString

                // Send updated text to Flutter
                DispatchQueue.main.async {
                    self.channel?.invokeMethod("onTextChanged", arguments: self.resultText)
                }
            }

            if result?.isFinal == true {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                self.recognitionRequest = nil
                self.recognitionTask = nil
            }
        }

        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, when in
            self.recognitionRequest?.append(buffer)
        }

        audioEngine.prepare()

        do {
            try audioEngine.start()
            result(true)  // Indicate successful start
        } catch {
            result(FlutterError(code: "audio_engine_error",
                              message: "Audio engine start error",
                              details: error.localizedDescription))
        }
    }

    private func stopListening(result: @escaping FlutterResult) {
        if audioEngine.isRunning {
            audioEngine.stop()
            audioEngine.inputNode.removeTap(onBus: 0)
            recognitionRequest?.endAudio()
            result(resultText)  // Return the final text when stopping
        } else {
            result(FlutterError(code: "audio_engine_not_running",
                              message: "Audio engine is not running",
                              details: nil))
        }
    }
}
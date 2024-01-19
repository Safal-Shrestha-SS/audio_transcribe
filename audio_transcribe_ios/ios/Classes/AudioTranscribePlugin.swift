import Flutter
import UIKit
import Speech

public class AudioTranscribePlugin: NSObject, FlutterPlugin {
    private var speechRecognizer: SFSpeechRecognizer?
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    private var resultText = ""

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "audio_transcribe_ios", binaryMessenger: registrar.messenger())
        let instance = AudioTranscribePlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "getPlatformName":
            result("Shyau")
        case "getAudioText":
            result(resultText)
        case "startListening":
            startListening(result: result)
        case "stopListening":
            stopListening(result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    private func startListening(result: @escaping FlutterResult) {
        guard SFSpeechRecognizer.authorizationStatus() == .authorized else {
            // Request speech recognition authorization if not authorized
            SFSpeechRecognizer.requestAuthorization { status in
                if status == .authorized {
                    self.startSpeechRecognition(result: result)
                } 
            }
            return
        }

        startSpeechRecognition(result: result)
    }

    private func startSpeechRecognition(result: @escaping FlutterResult) {
        do {
            // Configure the audio session
            try AVAudioSession.sharedInstance().setCategory(.record, mode: .measurement, options: [])
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)

            speechRecognizer = SFSpeechRecognizer()
            recognitionRequest = SFSpeechAudioBufferRecognitionRequest()

            let inputNode = audioEngine.inputNode
            let recordingFormat = inputNode.outputFormat(forBus: 0)

            inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, _) in
                self.recognitionRequest?.append(buffer)
            }

            audioEngine.prepare()
            try audioEngine.start()
            recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest!, resultHandler: {
                result, error in
                   if let result = result {
                       let recognizedText = result.bestTranscription.formattedString
                       self.resultText = recognizedText
                   }
            })
        } catch {
            
        }
    }

    private func stopListening(result: @escaping FlutterResult) {
        if audioEngine.isRunning {
            audioEngine.stop()
            audioEngine.inputNode.removeTap(onBus: 0)
        }
        if let request = recognitionRequest {
            request.endAudio()
        }
    }
}



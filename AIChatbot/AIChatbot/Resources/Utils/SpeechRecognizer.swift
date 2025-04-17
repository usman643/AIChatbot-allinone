//
//  SpeechRecognizer.swift
//  AIChatbot
//
//  Created by Muhammad Usman on 13/04/2025.
//

import Foundation
import Speech
import AVFoundation

class SpeechRecognizer: NSObject, ObservableObject, AVSpeechSynthesizerDelegate {
    
    private let audioEngine = AVAudioEngine()
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?

    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))!
    
    private let synthesizer = AVSpeechSynthesizer()

    @Published var transcribedText: String = ""
    
    //to handle chat bubbles
    @Published var voicepPlayerId: String = ""
    var onFinishSpeech: (() -> Void)?

    override init() {
        super.init()
        requestPermissions()
    }
    
    func speakText(_ text: String) {
        print("Speaking: \(text)")
        
        if synthesizer.isSpeaking{
            synthesizer.stopSpeaking(at: .immediate)
        }
        
        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: .immediate)
        }
        synthesizer.delegate = self
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US") // Or try nil for system default
        utterance.rate = 0.5 // Optional: Adjust speed
        utterance.volume = 1.0 // Ensure volume is max
        synthesizer.speak(utterance)
    }
    
    
    func stopSpeaker() {
        if synthesizer.isSpeaking {
            self.voicepPlayerId = ""
            synthesizer.stopSpeaking(at: .immediate)
        }
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        onFinishSpeech?()
    }
    

    func requestPermissions() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            switch authStatus {
            case .authorized:
                print("Speech recognition authorized")
            default:
                print("Speech recognition not authorized")
            }
        }
    }

    func startTranscribing() throws {
        if audioEngine.isRunning {
            stopTranscribing()
        }

        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()

        let inputNode = audioEngine.inputNode
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create request")
        }

        recognitionRequest.shouldReportPartialResults = true

        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { result, error in
            if let result = result {
                DispatchQueue.main.async {
                    self.transcribedText = result.bestTranscription.formattedString
                }
            }

            if error != nil || (result?.isFinal ?? false) {
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
        try audioEngine.start()
    }


    func stopTranscribing() {
        audioEngine.stop()
        recognitionRequest?.endAudio()
    }
}

//
//  ProcessUtils.swift
//  AIChatbot
//
//  Created by Muhammad Usman on 12/04/2025.
//

import Foundation
import AVFoundation

final class ProcessUtils {
    static let shared = ProcessUtils()
    private let synthesizer = AVSpeechSynthesizer()
    
    
    func speakText(_ text: String) {
        print("Speaking: \(text)")
        
        if synthesizer.isSpeaking{
            synthesizer.stopSpeaking(at: .immediate)
        }
        
        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: .immediate)
        }
        
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US") // Or try nil for system default
        utterance.rate = 0.5 // Optional: Adjust speed
        utterance.volume = 1.0 // Ensure volume is max
        synthesizer.speak(utterance)
    }
    
    
    func stopSpeaker() {
        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: .immediate)
        }
    }
    
}

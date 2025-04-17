//
//  String+Extension.swift
//  AIChatbot
//
//  Created by Muhammad Usman on 12/04/2025.
//

import Foundation
import AppKit
import AVFoundation

extension String {
    
    
    func copyToClipboard() {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(self, forType: .string)
    }
    
    func shareText() {
        let sharingPicker = NSSharingServicePicker(items: [self])
        
        // Get the key window's content view
        if let window = NSApplication.shared.keyWindow,
           let contentView = window.contentView {
            sharingPicker.show(relativeTo: .zero, of: contentView, preferredEdge: .minY)
        }
    }
    
    func speakText() {
        let synthesizer = AVSpeechSynthesizer()
        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: .immediate)
        }
        let utterance = AVSpeechUtterance(string: self)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        synthesizer.speak(utterance)
    }
}




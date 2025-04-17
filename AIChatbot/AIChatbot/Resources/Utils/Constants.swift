//
//  Constants.swift
//  AIChatbot
//
//  Created by Muhammad Usman on 02/04/2025.
//

import Foundation

struct Constants {
    static let gptCloudeBaseURL = "https://us-central1-aichatbot-allinone.cloudfunctions.net/chatGPT"
    static let gptImageCloudeBaseURL = "https://us-central1-aichatbot-allinone.cloudfunctions.net/generateImages"
}

enum ImageSize {
    case wide, square, tall
}


// MARK: - Chat Header Picker Views
enum ChatModelType: String, Codable, CaseIterable, CustomStringConvertible {
    case chatGPT3_5 = "gpt-3.5-turbo"
    case chatGPT4 = "gpt-4"
    case chatGPT4Turbo = "gpt-4-turbo"
    case chatGPT4O = "gpt-4o"
    case chatGPT4_5 = "gpt-4.5-preview"
    
    
    var description: String { self.getModelTitle() }
    
    func getModelTitle() -> String {
        switch self {
        case .chatGPT3_5:
            return "Chat GPT 3.5"
        case .chatGPT4:
            return "Chat GPT 4"
        case .chatGPT4Turbo:
            return "Chat GPT 4 Turbo"
        case .chatGPT4O:
            return "Chat GPT 4O"
        case .chatGPT4_5:
            return "Chat GPT 4.5"
        }
    }
    
    var baseUrl : String {
        switch self {
        case .chatGPT3_5, .chatGPT4, .chatGPT4Turbo, .chatGPT4O, .chatGPT4_5:
            return Constants.gptCloudeBaseURL
        }
    }
    
    var isImageSupported: Bool {
        switch self {
        case .chatGPT3_5, .chatGPT4:
            return false
        case .chatGPT4Turbo, .chatGPT4O, .chatGPT4_5:
            return true
        }
    }
    
    var isDocumentsSupported: Bool {
        switch self {
        case .chatGPT3_5, .chatGPT4, .chatGPT4Turbo, .chatGPT4O, .chatGPT4_5:
            return false
        }
    }
    
    var isVoiceToTranscript: Bool {
        switch self {
        case .chatGPT3_5, .chatGPT4, .chatGPT4Turbo, .chatGPT4O, .chatGPT4_5:
            return false
        }
    }
    
}


enum MessageState: String, Codable {
    case noState = "no_state"
    case inProgress = "in_progress"
    case typingState = "typing_state"
    case completed = "completed"
    case error = "error"
}


enum HeaderOptions {
    case modelSelection
    case languageSelection
    case fontSelection
    case exportChat
    case shareChat
}

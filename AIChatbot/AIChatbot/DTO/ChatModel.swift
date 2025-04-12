//
//  ChatModel.swift
//  AIChatbot
//
//  Created by Muhammad Usman on 07/04/2025.
//

import Foundation

let defaultChatName : String = "New Assistent"


class ChatModel : Codable, Identifiable {
    let id : String = UUID().uuidString
    var chatName : String
    var messages : [ChatMessageModel]
    let createdAt : Date
    
    init(chatName: String, messages: [ChatMessageModel] = [], createdAt : Date = Date()) {
        self.chatName = chatName
        self.messages = messages
        self.createdAt = Date()
    }
    
    
    enum CodingKeys: CodingKey {
        case chatName
        case messages
        case createdAt
    }
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.chatName = try container.decode(String.self, forKey: .chatName)
        self.messages = try container.decode([ChatMessageModel].self, forKey: .messages)
        self.createdAt = try container.decode(Date.self, forKey: .createdAt)
    }
    
}

struct ChatMessageModel: Codable, Identifiable, Equatable {
    var id : String = UUID().uuidString
    let text : String?
    let isUserMessage : Bool
    let modelType : ChatModelType
    let dateTime : Date
    let attachments : [String]?
    let parentMessageId : String?
    var hasError : Bool = false
    
    init(text: String, attachments : [String]? = nil, isUserMessage: Bool, modelType: ChatModelType, dateTime: Date = Date(), parentMessageId : String? = nil, hasError : Bool = false) {
        self.text = text
        self.attachments = attachments
        self.isUserMessage = isUserMessage
        self.modelType = modelType
        self.dateTime = dateTime
        self.parentMessageId = parentMessageId
        self.hasError = hasError
    }
    
    enum CodingKeys: CodingKey {
        case id
        case text
        case isUserMessage
        case modelType
        case dateTime
        case attachments
        case parentMessageId
        case hasError
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.text = try container.decode(String.self, forKey: .text)
        self.attachments = try? container.decode([String].self, forKey: .attachments)
        self.isUserMessage = try container.decode(Bool.self, forKey: .isUserMessage)
        self.modelType = try container.decode(ChatModelType.self, forKey: .modelType)
        self.dateTime = try container.decode(Date.self, forKey: .dateTime)
        self.parentMessageId = try? container.decode(String.self, forKey: .parentMessageId)
        self.hasError = try container.decode(Bool.self, forKey: .hasError)
    }
}

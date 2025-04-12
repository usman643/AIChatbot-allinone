//
//  ChatViewModel.swift
//  AIChatbot
//
//  Created by Muhammad Usman on 07/04/2025.
//

import Foundation

class ChatViewModel : ObservableObject {
    @Published var chats : [ChatModel] = []
    @Published var selectedChat : ChatModel = ChatModel(chatName: defaultChatName, messages: [])
    
    init() {
        self.loadChatData()
    }
    
    func loadChatData() {
        let chatList = UserDefaults.standard.chatModelStorage ?? []
        if chatList.isEmpty {
            //set mock data
            self.chats = [ChatModel(chatName: defaultChatName, messages: [])]
            return
        }
        
        self.chats = chatList
        
    }
    
    
    func sendMessage(_ message: ChatMessageModel, completion: ((_ error:String?) -> Void)? = nil) {

        //save message
        self.selectedChat.messages.append(message)
        
        let emptyMessage = ChatMessageModel(text: "", isUserMessage: false, modelType: message.modelType, parentMessageId: message.id)
        self.selectedChat.messages.append(emptyMessage)
        
        self.saveUpdatedChat()
        
        //send message to server
        APIClient.shared.sendMessage(message: message) { response in
            switch response {
            case .success(let reply):
                self.createResponse(queryMsg: message, respMessage: reply)
                completion?(nil)
            case .failure(let error):
                print(error)
                self.createResponse(queryMsg: message, respMessage: "", hasError: true)
                completion?("Something went wrong, please try reloading the conversation.")
            }
        }
    }
    
    
    private func createResponse(queryMsg:ChatMessageModel, respMessage: String, hasError: Bool = false) {
        
        let message = ChatMessageModel(text: respMessage, isUserMessage: false, modelType: queryMsg.modelType, parentMessageId: queryMsg.id, hasError: hasError)
        
        if let lastMsg = self.selectedChat.messages.last, lastMsg.text == "", lastMsg.isUserMessage == false{
            self.selectedChat.messages.removeLast()
        }
        
        self.selectedChat.messages.append(message)
        self.saveUpdatedChat()
    }
    
    
    func saveUpdatedChat() {
        DispatchQueue.main.async {
            let chats = self.chats
            self.chats.removeAll()
            self.chats = chats
            UserDefaults.standard.chatModelStorage = self.chats
        }
    }
    
    
    func clearCache() {
        UserDefaults.standard.chatModelStorage = nil
        self.chats.removeAll()
    }
    
    
    
}

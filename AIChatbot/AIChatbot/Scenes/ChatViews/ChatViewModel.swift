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
    
    private func getDefaultChatModel() -> ChatModel {
        return ChatModel(chatName: defaultChatName, messages: [])
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
        let selectedChat = self.selectedChat
        
        
        selectedChat.messages.append(message)
        
        let emptyMessage = ChatMessageModel(text: "", isUserMessage: false, modelType: message.modelType, parentMessageId: message.id)
        selectedChat.messages.append(emptyMessage)
        
        self.saveUpdatedChat()
        
        //send message to server
        APIClient.shared.sendMessage(message: message) { response in
            switch response {
            case .success(let reply):
                self.createResponse(queryMsg: message, selectedChat: selectedChat, respMessage: reply)
                completion?(nil)
            case .failure(let error):
                print(error)
                self.createResponse(queryMsg: message, selectedChat: selectedChat, respMessage: "", hasError: true)
                completion?("Something went wrong, please try reloading the conversation.")
            }
        }
    }
    
    
    private func createResponse(queryMsg:ChatMessageModel, selectedChat:ChatModel, respMessage: String, hasError: Bool = false) {
        
        let message = ChatMessageModel(text: respMessage, isUserMessage: false, modelType: queryMsg.modelType, parentMessageId: queryMsg.id, hasError: hasError)
        
        if let lastMsg = selectedChat.messages.last, lastMsg.text == "", lastMsg.isUserMessage == false{
            selectedChat.messages.removeLast()
        }
        
        selectedChat.messages.append(message)
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
    
    func saveUpdatedChat(selectedChat: ChatModel) {
        DispatchQueue.main.async {
            let chats = self.chats
            self.chats.removeAll()
            self.chats = chats
            UserDefaults.standard.chatModelStorage = self.chats
        }
    }
    
    
    func clearCache() {
        DispatchQueue.main.async {
            self.chats.removeAll()
            self.chats.insert(self.getDefaultChatModel(), at: 0)
            self.selectedChat = self.chats.first!
            UserDefaults.standard.chatModelStorage = self.chats
        }
    }
    
    
    
}

//
//  ChatContentView.swift
//  AIChatbot
//
//  Created by Muhammad Usman on 24/03/2025.
//

import SwiftUI

struct ChatContentView: View {
    
    @StateObject var viewModel : ChatViewModel
    @State var selectedChatModel : ChatModelType = .chatGPT3_5
    @State var selectedFont : FontType = .px16
    
    @State var messageState : MessageState = .noState
    @State var promtMessage : ChatMessageModel?
    
    var body: some View {
        VStack(spacing: 0) {
            ChatHeaderView(headerSelection: [.modelSelection, .fontSelection, .exportChat, .shareChat], onModelSelection: { model in
                self.selectedChatModel = model
            }, onFontSelection: { fontType in
                self.selectedFont = fontType
            })
            .frame(height: 70)
            .frame(maxWidth: .infinity, alignment: .top)
            .zIndex(1)
            
            HStack{
                ChatListView(chats: $viewModel.chats, selectedCallback: { selectedIndex in
                    if viewModel.chats.count > selectedIndex {
                        viewModel.selectedChat = viewModel.chats[selectedIndex]
                    }
                }, onNewAssistent: {
                    viewModel.saveUpdatedChat()
                })
                    .frame(width: 250)

                if viewModel.selectedChat.messages.isEmpty {
                    ChatDefaultPromptsView()
//                        .padding()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }else {
                    
                    ScrollViewReader { scrollViewProxy in
                        
                        ScrollView {
                            VStack(spacing: 10) {
                                ForEach(Array(viewModel.selectedChat.messages.enumerated()), id: \.element.id) { index, message in
                                    
                                    let isLastMessage = index == viewModel.selectedChat.messages.count - 1
                                    
                                    ChatBubbleView(messageState: (isLastMessage ? $messageState : .constant(.noState)), message: message, selectedFont: selectedFont, onEditMessage: { message in
                                        self.promtMessage = message
                                    }, onReGenerateMessage:{ message in
                                        self.regenrateMessage(message: message)
                                    })
                                    .id(message.id)
                                }
                            }
                            .padding(.top, 20)
                            .onChange(of: viewModel.selectedChat.messages) {
                                
                                if let lastMessage = viewModel.selectedChat.messages.last {
                                    if lastMessage.isUserMessage {
                                        withAnimation {
                                            scrollViewProxy.scrollTo(lastMessage.id, anchor: .bottom)
                                        }
                                    } else {
                                        DispatchQueue.main.async {
                                            withAnimation {
                                                scrollViewProxy.scrollTo(lastMessage.id, anchor: .top)
                                            }
                                        }
                                    }
                                }
                                
                            }
                        }
                        
                        
                    }
                    
                    
                }
            }
            .padding(.bottom)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            ChatTextBoxView(messageState:$messageState, selectedChatModelType: self.selectedChatModel, promtMessage: $promtMessage, sendMessageDidTapped: { message, attachments in
                
                self.sendMessage(message: message, attachments: attachments)
            })
            .padding(.bottom)
            .padding(.horizontal, 40)
            .padding(.leading, 120)
            
        }
        .background(Color.chatbg)
        .onAppear {
            viewModel.selectedChat = viewModel.chats.first ?? ChatModel(chatName: defaultChatName, messages: [])
        }
        .overlay {
            ToastView()
        }
    }
    
    private func regenrateMessage(message:ChatMessageModel){
        if let parentId = message.parentMessageId {
            let parentMsg = viewModel.selectedChat.messages.first(where: { $0.id == parentId })
            
            if let text = parentMsg?.text {
                
                self.sendMessage(message: text, attachments: parentMsg?.attachments?.compactMap({URL(string: $0)}))
            }
        }
    }
    
    
    func sendMessage(message:String, attachments:[URL]? = nil){
        self.messageState = .inProgress
        
        let attachmentsUrlStr = attachments?.map { $0.absoluteString }
        
        let message = ChatMessageModel(text: message, attachments: attachmentsUrlStr, isUserMessage: true, modelType: selectedChatModel)
        
        viewModel.sendMessage(message) { error in
            self.messageState = .typingState
            if error == nil {
                //success case
            }else{
                //faluire case
            }
        }
    }
}

#Preview {
    ChatContentView(viewModel: ChatViewModel())
        .frame(minWidth: 1100, maxWidth: .infinity, minHeight: 800, maxHeight: .infinity)
}

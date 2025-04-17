//
//  ChatListView.swift
//  AIChatbot
//
//  Created by Muhammad Usman on 25/03/2025.
//

import SwiftUI

struct ChatListView: View {
    @Binding var chats : [ChatModel]
    @State var selectedIndex : Int = 0
    var selectedCallback : ((_ selectedIndex : Int) -> Void)
    var onNewAssistent : (() -> Void)
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.clear.ignoresSafeArea()
            
            VStack {
                
                Button {
                    self.createNewAssistent()
                } label: {
                    HStack(spacing: 20) {
                        Image("menuChatIcon")
                            .resizable()
                            .scaledToFit()
                            .foregroundStyle(Color.botPrimaryLight)
                            .frame(width: 25, height: 25)
                        
                        Text("Create New Chat")
                            .foregroundStyle(Color.botPrimaryLight)
                    }
                    .padding(10)
                    .padding(.horizontal, 25)
                    .overlay(content: {
                        RoundedRectangle(cornerRadius: 10)
                            .strokeBorder(style: StrokeStyle(lineWidth: 1.5, dash: [6]))
                            
                            
                    })
                    .padding(.top)
                }
                .buttonStyle(.borderless)
                
                
                VStack {
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        
                        ForEach(Array(chats.enumerated()), id: \.element.id) { index, chat in
                            VStack(spacing:0) {
                                Rectangle()
                                    .fill(Color.red.opacity(0.001))
                                    .overlay {
                                        ChatNameView(chatName: chat.chatName, isSelected: index == selectedIndex) { name in
                                            chat.chatName = name
                                            print("ChatName changed? \(chat.chatName)")
                                        } onDeleteTapped: {
                                            let selectedChat = chats[selectedIndex]
                                            chats.remove(at: index)
                                            
                                            if chats.count == 0 {
                                                self.createNewAssistent()
                                            }
                                            
                                            if index == selectedIndex {
                                                self.changeSelectedIndex(0)
                                            }else{
                                                
                                                self.changeSelectedIndex(chats.firstIndex(where: {$0.id == selectedChat.id}) ?? 0)
                                            }
                                        } onExportChat: {
                                            //Export Chat
                                        }
                                    }
                                    .frame(height:50)
                                    .onTapGesture {
                                        self.changeSelectedIndex(index)
                                    }
                                
                                Divider()
                                    .foregroundStyle(Color.botPrimaryLight)
                            }
                            
                             
                        }
                        
                    }
                }
                .padding(.top, 30)
                .padding(.horizontal)
                
            }
            
            
        }
    }
    
    private func createNewAssistent() {
        self.chats.insert(ChatModel(chatName: defaultChatName), at: 0)
        self.changeSelectedIndex(self.chats.startIndex)
        self.onNewAssistent()
    }
    
    private func changeSelectedIndex(_ index: Int) {
        selectedIndex = index
        self.selectedCallback(index)
    }
}

#Preview {
    ChatListView(chats: .constant(ChatViewModel().chats), selectedCallback: {_ in}, onNewAssistent: {})
        .frame(width: 300, height: 600)
}



struct ChatNameView : View {
    
    @State var chatName: String = ""
    var isSelected: Bool
    @State private var isEditing: Bool = false
    
    var onNameChange: ((String) -> Void)?
    var onDeleteTapped: (() -> Void)?
    var onExportChat: (() -> Void)?
    
    var body: some View {
        HStack {
            if !isEditing {
                Text(chatName)
                    .foregroundStyle(Color.botPrimaryLight)
                    .textFieldStyle(.plain)
                Spacer()
            }else {
                TextField(defaultChatName, text: $chatName)
                    .foregroundStyle(Color.botPrimaryLight)
                    .textFieldStyle(.roundedBorder)
                    .focusable(isEditing)
                    .onSubmit(of: .text) {
                        isEditing = false
                        onNameChange?(chatName)
//                        print("Edited value \(chatName)")
                    }
            }
            
            Button {
                onDeleteTapped?()
            } label: {
                Image(systemName: "trash.fill")
                    .foregroundColor(.botPrimaryLight)
            }
            .buttonStyle(.borderless)
            
            Button {
                onExportChat?()
            } label: {
                Image("exportChat")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.botPrimaryLight)
                    .frame(width: 20, height: 20)
            }
            .buttonStyle(.borderless)
            
            Button {
                isEditing = true
            } label: {
                Image(systemName: "pencil.line")
                    .foregroundColor(.botPrimaryLight)
            }
            .buttonStyle(.borderless)
                
        }
        .padding(12)
        .background(isSelected ? Color.gray.opacity(0.2) : Color.clear)
        .cornerRadius(8)
    }
}


#Preview {
    ChatNameView(chatName: "Chat 1", isSelected: true)
        .frame(width: 300, height: 600)
}

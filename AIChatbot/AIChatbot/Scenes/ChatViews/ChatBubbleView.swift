//
//  ChatBubbleView.swift
//  AIChatbot
//
//  Created by Muhammad Usman on 25/03/2025.
//


import SwiftUI

struct ChatBubbleView: View {
    @Binding var messageState: MessageState
    let message: ChatMessageModel
    var selectedFont: FontType = .px16

    @State private var displayedText = ""
    @State private var showToast = false
    private let typingSpeed: TimeInterval = 0.001
    @State private var isSpeakerPlaying = false
    
    var onEditMessage: ((ChatMessageModel) -> Void)?
    var onReGenerateMessage: ((ChatMessageModel) -> Void)?
    
    
    var body: some View {
        
        VStack(alignment: message.isUserMessage ? .trailing : .leading, spacing: 3) {
            HStack {
                if message.isUserMessage { Spacer() }

                VStack(alignment: .leading, spacing: 10) {
                    if let attachments = message.attachments, !attachments.isEmpty {
                        HStack {
                            ForEach(attachments, id: \.self) { urlStr in
                                if let url = URL(string: urlStr), let nsImage = NSImage(contentsOf: url){
                                    Image(nsImage: nsImage)
                                        .resizable()
                                        .frame(width: 50, height: 50)
                                        .cornerRadius(8)
                                }
                            }
                        }
                    }
                    
                    if let text = message.text, !message.hasError {
                        
                        if text == "" && messageState == .inProgress && !message.isUserMessage {
                            // show dot untill message state changed
                            PulsingDot()
                        }else if messageState == .typingState && message.isUserMessage == false {
                            Text(.init(displayedText))
                                .textSelection(.enabled)
                                .font(.regularFont(self.selectedFont.getFontSize()))
                                .foregroundColor(Color.botPrimaryLight)
                                .lineSpacing(8)
                                
                        }else{
                            Text(.init(text))
                                .textSelection(.enabled)
                                .font(.regularFont(self.selectedFont.getFontSize()))
                                .foregroundColor( message.isUserMessage ? Color.primaryWhite : Color.botPrimaryLight)
                                .lineSpacing(8)
                                
                            
                        }
                        
                    }else if message.hasError == true {
                        //show error view
                        MessageErrorView {
                            self.onReGenerateMessage?(message)
                        }
                    }
                }
                .padding(12)
                .background(message.hasError ? Color.red.opacity(0.2) : message.isUserMessage ? Color.selectedMenuBack : (messageState == .inProgress ? Color.clear : Color.appGray))
                .cornerRadius(12)
                .onAppear {
                    if let text = message.text, text != "", message.isUserMessage == false, messageState == .typingState {
                        self.startTyping(message: text)
                    }
                }
                if !message.isUserMessage { Spacer() }
            }
            
            if !(messageState == .inProgress || messageState == .typingState) && message.hasError == false {
                HStack {
                    if message.isUserMessage {
                        ChatBubbleButtonView(icon: "pencil.line", hasSystemIcon: true) {
                            self.onEditMessage?(message)
                        }
                    }

                    ChatBubbleButtonView(icon: "copyIcon") {
                        message.text?.copyToClipboard()
                        ToastManager.shared.show(message: "Copied to clipboard!")
                    }
                    
                    if !message.isUserMessage {
                        
                        ChatBubbleButtonView(icon: "rePrompt") {
                            self.onReGenerateMessage?(message)
                        }
                        
                        ChatBubbleButtonView(icon: "speaker.wave.2", hasSystemIcon: true) {
                            if isSpeakerPlaying {
                                ProcessUtils.shared.stopSpeaker()
                                isSpeakerPlaying = false
                            }else{
                                isSpeakerPlaying = true
                                ProcessUtils.shared.speakText(message.text ?? "")
                            }
                            
                        }
                        
                        ChatBubbleButtonView(icon: "shareIcon") {
                            self.message.text?.shareText()
                        }
                        
                    }
                    
                }
                .foregroundColor(.gray)
                .font(.system(size: 16))
                .padding(.horizontal, 12)
            }
        }
        .padding(.horizontal)
    }
    
    private func startTyping(message:String) {
        displayedText = ""
        var index = 0
        Timer.scheduledTimer(withTimeInterval: typingSpeed, repeats: true) { timer in
            if index < message.count {
                let char = message[message.index(message.startIndex, offsetBy: index)]
                displayedText.append(char)
                index += 1
            } else {
                timer.invalidate()
                messageState = .completed
            }
        }
    }
    
    func showToastMessage() {
        showToast = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            showToast = false
        }
    }
}

#Preview {
    
    ChatBubbleView(messageState: .constant(.noState), message: ChatMessageModel(text: "Hi this is test message", isUserMessage: true, modelType: .chatGPT3_5))
        .frame(width: 600, height: 600)
}


struct PulsingDot: View {
    @State private var scale: CGFloat = 0.6

    var body: some View {
        Circle()
            .fill(Color.botPrimaryLight)
            .frame(width: 10, height: 10)
            .scaleEffect(scale)
            .animation(
                Animation.easeInOut(duration: 0.6)
                    .repeatForever(autoreverses: true),
                value: scale
            )
            .onAppear {
                scale = 1.2
            }
    }
    
}


fileprivate struct ChatBubbleButtonView: View {
    
    let icon : String
    var hasSystemIcon : Bool = false
    
    var onButtonPressed : (() -> Void)
    
    var body: some View {
        Button(action: {
            self.onButtonPressed()
        }) {
            if hasSystemIcon {
                Image(systemName: icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 16, height: 16)
                    .foregroundStyle(Color.botPrimaryLight)
            }else{
                Image(icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 16, height: 16)
                    .foregroundStyle(Color.botPrimaryLight)
            }
        }
        .buttonStyle(.plain)
    }
}

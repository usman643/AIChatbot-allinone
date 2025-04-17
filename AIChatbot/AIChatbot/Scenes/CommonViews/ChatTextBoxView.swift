//
//  ChatTextBoxView.swift
//  AIChatbot
//
//  Created by Muhammad Usman on 24/03/2025.
//

import SwiftUI

struct ChatTextBoxView: View {
    @Binding var messageState: MessageState
    var selectedChatModelType : ChatModelType = .chatGPT3_5
    @Binding var promtMessage : ChatMessageModel?
    
    @State private var text: String = ""
    @State private var textHeight: CGFloat = 60
    private let maxHeight: CGFloat = 120
    @State private var attachments : [URL] = []
    @StateObject private var recognizer = SpeechRecognizer()
    @State private var isSpeakerPlaying = false
    
    var sendMessageDidTapped : ((_ message:String, _ attachments:[URL]?) -> Void)?
    
    var body: some View {
        
        VStack(spacing: 3) {
            
            HStack {
                Spacer()
                
                if selectedChatModelType.isVoiceToTranscript {
                    Circle()
                        .fill(Color.appGray)
                        .frame(width: 35, height: 35)
                        .overlay(
                            Image("voiceToTextIcon")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 18, height: 18)
                        )
                }
                
                if selectedChatModelType.isDocumentsSupported {
                    Circle()
                        .fill(Color.appGray)
                        .frame(width: 35, height: 35)
                        .overlay(
                            Image(systemName: "text.document.fill")
                        )
                }
                
                if selectedChatModelType.isImageSupported && attachments.count < 5 {
                    Circle()
                        .fill(Color.appGray)
                        .frame(width: 35, height: 35)
                        .overlay(
                            Image(systemName: "photo.fill")
                        )
                        .onTapGesture {
                            AttachmentUtils.shared.openImagePicker { url in
                                attachments.append(url)
                            }
                        }
                }
                
                Circle()
                    .fill(self.isSpeakerPlaying ? Color.red : Color.appGray)
                    .frame(width: 35, height: 35)
                    .overlay(
                        Image(systemName: "person.wave.2.fill")
                    )
                    .onTapGesture {
                        if isSpeakerPlaying {
                            isSpeakerPlaying = false
                            recognizer.stopTranscribing()
                        }else{
                            isSpeakerPlaying = true
                            try? recognizer.startTranscribing()
                        }
                    }
                
            }
            .foregroundStyle(Color.botPrimaryLight)
            .padding(.horizontal, 25)
            
            
            VStack(alignment: .leading, spacing: 0) {
                if attachments.count > 0 {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(Array(attachments.enumerated()), id: \.1) { index, attachment in
                                if let image = NSImage(contentsOf: attachment){
                                    
                                    Image(nsImage: image)
                                        .resizable()
                                        .scaledToFill()
                                        .background(Color.gray.opacity(0.1))
                                        .frame(width: 50, height: 50)
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                        .overlay {
                                            ZStack(alignment: .topTrailing) {
                                                Color.clear.ignoresSafeArea()
                                                Image(systemName: "xmark.circle.fill")
                                                    .foregroundStyle(Color.red)
                                                    .padding(2)
                                                    .onTapGesture {
                                                        self.attachments.remove(at: index)
                                                    }
                                            }
                                        }
                                }
                            }
                        }
                        .padding(.horizontal)
                        .frame(height: 55, alignment: .leading)
                    }
                }
                
                
                ZStack(alignment: .leading) {
                    if text.isEmpty {
                        Text("Enter your prompt here...")
                            .foregroundStyle(Color.gray)
                            .padding(8)
                            .padding(.leading, 5)
                    }
                    
                    HStack {
                        TextEditor(text: $text)
                            .font(.regularFont(14))
                            .lineSpacing(5)
                            .foregroundStyle(Color.botPrimaryLight)
                            .scrollContentBackground(.hidden)
        //                    .background(Color.white)
                            .padding(8)
                            .padding(.top, 12)
                            .onChange(of: text, {
                                adjustTextHeight()
                            })
                            .onChange(of: recognizer.transcribedText, {
                                self.text = self.recognizer.transcribedText
                            })
                        
                        Button {
                            if (!text.isEmpty || attachments.count > 0) && (messageState != .inProgress || messageState != .typingState) {
                                //send call back for textMessage
                                self.sendMessage()
                            }
                        } label: {
                            HStack {
                                Text("Send")
                                
                                Image(systemName: "paperplane.fill")
                            }
                            .font(.boldFont(14))
                            .foregroundStyle(Color.botPrimary)
                            .frame(width: 80, height: 35)
                            .background(Color.botPrimaryLight)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            
                        }
                        .padding(.trailing, 12)
                        .buttonStyle(.plain)

                    }
                    .frame(minHeight: 60, maxHeight: textHeight)
//                    .background(Color.red)
                }
                
            }
            .background(Color.botSecondry)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding(.horizontal)
            
            
            
        }
        .onChange(of: promtMessage) { _, message in
            self.text = message?.text ?? ""
            if let attachments = message?.attachments?.compactMap({URL(string: $0)}) {
                self.attachments = attachments
            }
        }
//        .background(Color.red)
        
    }
    
    private func adjustTextHeight() {
        let textSize = text.size(withAttributes: [.font: NSFont.systemFont(ofSize: 16)])
        let newHgt = min(max(60, textSize.height + 20), maxHeight)
        
        textHeight = newHgt < maxHeight ? newHgt : maxHeight
    }
    
    private func sendMessage() {
        self.sendMessageDidTapped?(text, attachments)
        attachments.removeAll()
        print("Message Sent: \(text)")
        text = ""
        textHeight = 60
    }
}

#Preview {
    ChatTextBoxView(messageState: .constant(.noState), promtMessage: .constant(nil))
        .frame(width: 600, height: 500)
}


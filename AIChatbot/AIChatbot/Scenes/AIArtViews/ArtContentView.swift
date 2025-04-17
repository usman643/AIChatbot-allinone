//
//  ArtContentView.swift
//  AIChatbot
//
//  Created by Muhammad Usman on 26/03/2025.
//

import SwiftUI

struct ArtContentView: View {
    
    @State var showResponseSheet : Bool = false
    @State var imageReqModel : ImageRequestModel?
    @State var promtMsg : ChatMessageModel?
    
    var body: some View {
        
        NavigationStack {
            
            VStack(spacing: 0) {
                
                ArtDefaultPromptsView(onPromtMsg: { message in
                    self.promtMsg = message
                })
                    .padding(.top)
                
                Spacer()
                
                ChatTextBoxView(messageState: .constant(.noState), selectedChatModelType: .chatGPT4O, promtMessage: $promtMsg ,sendMessageDidTapped: { message, attachments in
                    
                    if message != "" || attachments == nil {
                        self.generateImage(prompt: message, attachments: attachments)
                    }
                    
                })
                .padding(.bottom)
                .padding(.horizontal, 100)
            }
            .background(Color.chatbg)
        }
        .sheet(item: $imageReqModel, content: { model in
            ArtResponseView(viewModel: ArtResponseViewModel(reqModel: model))
                .presentationBackground(.clear)
        })
        
    }
    
    
    private func generateImage(prompt:String, attachments:[URL]?){
        
        var type : ImageRequestType = .textToImage
        var attachmentString : String?
        if let attachment = attachments?.first {
            type = .imageToImage
            attachmentString = AttachmentUtils.shared.imageToBase64(attachment.absoluteString)
        }
        
        let model = ImageRequestModel(prompt: prompt, imageBase64: attachmentString, type: type.rawValue, n: type.getImagesQuantity(), size: type.getImageSize())
        
        self.imageReqModel = model
        
    }
    
    
}

#Preview {
    ArtContentView()
        .frame(width: 800, height: 800)
}

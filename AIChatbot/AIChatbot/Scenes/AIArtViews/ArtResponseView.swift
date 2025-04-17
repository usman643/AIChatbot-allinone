//
//  ArtResponseView.swift
//  AIChatbot
//
//  Created by Muhammad Usman on 29/03/2025.
//

import SwiftUI

struct ArtResponseView: View {
    
    @StateObject var viewModel : ArtResponseViewModel
    
    @Environment(\.dismiss) var dismiss
    
    @State private var promptText: String = ""
    @State private var generatingImages: Bool = true
    @State private var mainImage: NSImage?
    
    var body: some View {
        
        VStack(alignment: .leading,spacing: 0) {
            // Close Button
            
            HStack {
                Button(action: {
                    self.dismiss()
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundColor(.red)
                }
                .padding(8)
                .buttonStyle(.plain)
                
                Spacer()
            }
            Spacer()
            
            // Main Content
            HStack(alignment: .top, spacing: 10) {
                // Main Image
                if generatingImages {
                    Spacer()
                    ProgressView("Generating Images....")
                    Spacer()
                }else {
                    Spacer()
                    VStack(alignment: .leading, spacing: 10) {
                        if let image = mainImage {
                            
                            let mainSizeImg = AttachmentUtils.shared.resizeImage(image:image, customSize: NSSize(width: 480, height: 430))
                            
                            Image(nsImage: mainSizeImg)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .padding(2)
                                .frame(height: 430)
                        }
                        
                        ZStack {
                            Rectangle()
                                .fill(Color.appGray)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                            
                            // Thumbnails Section
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 8) {
                                    ForEach(viewModel.artResponse, id: \.self) { image in
                            
                                        ZStack(alignment: .topTrailing) {
                                            let thumbnailSize = AttachmentUtils.shared.resizeImage(image:image, customSize: NSSize(width: 80, height: 90))
                                            
                                            Image(nsImage: thumbnailSize)
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                                .frame(width: 80, height: 80)
                                                .onTapGesture {
                                                    self.mainImage = image
                                                }
                                            
                                        }
                                    }
                                }

                            }
                            .padding(8)
                    
                        }
                        .padding(.leading, 5)
                        .padding(.bottom, 30)
 
                    }
                    .frame(width: 480)
                    Spacer()
                    // Prompt & Buttons
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Here’s your AI-generated image based on your prompt! Let me know if you’d like to make any changes or generate a new version. 🎨🤖✨")
                            .font(.regularFont(16))
                            .lineLimit(3)
                            .foregroundColor(.botPrimaryLight)
                        
                        Text("My Prompt:")
                            .font(.lightFont(18))
                            .foregroundColor(.botPrimaryLight)
                        
                        // Prompt Text Box
                        ZStack(alignment: .topLeading) {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.appGray)
                                .frame(height: 80)
                            
                            VStack(spacing:0) {
                                TextEditor(text: $promptText)
                                    .font(.regularFont(14))
                                    .foregroundStyle(Color.botPrimaryLight)
                                    .scrollContentBackground(.hidden)
                                    .frame(height: 40)
                                    .padding(8)
                                
                                HStack {
                                    Spacer()
                                    
                                    Button(action: {
                                        viewModel.reqModel.prompt = promptText
                                        viewModel.reqModel.type = ImageRequestType.textToImage.rawValue
                                        viewModel.reqModel.imageBase64 = nil
                                        
                                        self.generateArt()
                                    }) {
                                        Image("rePrompt")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 20, height: 20)
                                            .foregroundStyle(Color.botPrimaryLight)
                                        
                                    }
                                    .buttonStyle(.plain)
                                    
                                    Button(action: {
                                        promptText.copyToClipboard()
                                        ToastManager.shared.show(message: "Copied to clipboard!")
                                    }) {
                                        Image("copyIcon")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 20, height: 20)
                                            .foregroundStyle(Color.botPrimaryLight)
                                        
                                    }
                                    .buttonStyle(.plain)
                                }
                                .padding(.trailing)
                            }
                        }
                        
                        // Buttons
                        HStack {
                            Button(action: {
                                // Share action
                                if let image = mainImage {
                                    AttachmentUtils.shared.shareImage(image)
                                }
                                
                            }) {
                                Text("Share Image")
                                    .foregroundStyle(Color.botPrimaryLight)
                                    .font(.semiboldFont(16))
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(RoundedRectangle(cornerRadius: 10).stroke(Color.botPrimaryLight, lineWidth: 1))
                            }
                            .buttonStyle(.plain)
                            
                            Button(action: {
                                // Download action
                                AttachmentUtils.shared.saveImage(mainImage) { path in
                                    ToastManager.shared.show(message: "Image saved successfully at \(path)")
                                }
                            }) {
                                Text("Download Image")
                                    .font(.semiboldFont(16))
                                    .foregroundStyle(Color.botPrimary)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.botPrimaryLight)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                            .buttonStyle(.plain)
                        }
                        
                        Button(action: {
                            // Generate more action
                            
                            if let image = mainImage {
                                
                                viewModel.reqModel.prompt = nil
                                viewModel.reqModel.type = ImageRequestType.imageToImage.rawValue
                                viewModel.reqModel.imageBase64 = AttachmentUtils.shared.imageToBase64(nsImage: image)
                                
                                self.generateArt()
                            }
                            
                            
                        }) {
                            HStack {
                                Image(systemName: "plus")
                                Text("Generate More")
                            }
                            .foregroundStyle(Color.botPrimaryLight)
                            .font(.semiboldFont(16))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 10).stroke(Color.botPrimaryLight, lineWidth: 1))
                        }
                        .buttonStyle(.plain)
                    }
                }
                
                
                
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 12)
//            .background(Color.red)
            
            if generatingImages {
                Spacer()
            }

        }
        .padding(5)
        .frame(width: 1000, height: 610)
        .background(Color.botPrimary)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(radius: 10)
        .onAppear(perform: {
            self.promptText = viewModel.reqModel.prompt ?? ""
            self.generateArt()
        })
        .overlay {
            ToastView()
        }
        
    }
    
    
    private func generateArt() {
        self.generatingImages = true
        viewModel.fetchArtResponse {
            self.mainImage = viewModel.artResponse.first
            self.generatingImages = false
        }
    }
}

#Preview {
    ArtResponseView(viewModel:ArtResponseViewModel(reqModel: ImageRequestModel(type: "", n: 5, size: "")) )
        .frame(width: 1000, height: 480)
}

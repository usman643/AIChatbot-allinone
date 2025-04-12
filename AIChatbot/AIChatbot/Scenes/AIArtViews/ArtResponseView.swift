//
//  ArtResponseView.swift
//  AIChatbot
//
//  Created by Muhammad Usman on 29/03/2025.
//

import SwiftUI

struct ArtResponseView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State private var promptText: String = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim"
    
    let mainImage: String = "artprompt3" // Replace with your actual image name
    let thumbnails: [String] = ["artprompt1", "artprompt1", "artprompt1", "artprompt1", "artprompt1"] // Replace with actual thumbnail image names
    
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
//            .background(Color.black)
            
            // Main Content
            HStack(alignment: .top, spacing: 10) {
                // Main Image
                Spacer()
                VStack(alignment: .leading, spacing: 10) {
                    
                    Image(mainImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 300)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        
                    
                    ZStack {
                        Rectangle()
                            .fill(Color.appGray)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        
                        // Thumbnails Section
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(thumbnails, id: \.self) { imageName in
                                    ZStack(alignment: .topTrailing) {
                                        Image(imageName)
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 75, height: 75)
                                            .clipShape(RoundedRectangle(cornerRadius: 8))
                                        
                                        Button(action: {
                                            // Remove thumbnail action
                                        }) {
                                            RoundedRectangle(cornerRadius: 4)
                                                .fill(Color.botPrimary)
                                                .frame(width: 30, height: 20)
                                                .overlay {
                                                    Image("downloadIcon")
                                                        .resizable()
                                                        .scaledToFit()
                                                        .foregroundColor(.botPrimaryLight)
                                                }
                                            
                                        }
                                        .padding(4)
                                        .buttonStyle(.plain)
                                    }
                                }
                            }

                        }
                        .padding(8)
                
                    }
                    .padding(.leading, 5)
                    .padding(.bottom, 30)
                    
                    
                    
                    
                }
                .frame(width: 400)
                Spacer()
                // Prompt & Buttons
                VStack(alignment: .leading, spacing: 10) {
                    Text("Here’s your image of scientists working in a futuristic plant lab! Let me know if you want any tweaks or a different version. 🌿🔬👨‍🔬")
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

                                }) {
                                    Image(systemName: "pencil.line")
                                }
                                .buttonStyle(.plain)
                                
                                
                                Button(action: {
                                    
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
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 12)
//            .background(Color.red)
            
            
        }
        .padding(5)
        .frame(width: 1000, height: 480)
        .background(Color.botPrimary)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(radius: 10)
    }
}

#Preview {
    ArtResponseView()
        .frame(width: 1000, height: 480)
}

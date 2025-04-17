//
//  ExploreAIDetailView.swift
//  AIChatbot
//
//  Created by Muhammad Usman on 16/04/2025.
//

import SwiftUI

struct ExploreAIDetailView: View {
    
    @Binding var selectedCategory : ExploreAISubcategoryModel?
    @State var promtText : String = ""
    @StateObject var viewModel = ExploreAIDetailViewModel()
    
    @State var showLoader : Bool = false
    
    
    var body: some View {
        
        ZStack(alignment: .center) {
            Color.clear.ignoresSafeArea(edges: .all)
            
            VStack(alignment:.leading, spacing: 0) {
                
                DetailHeaderView(ttile: selectedCategory?.toolTitle ?? "", onBackPressed: {
                    self.selectedCategory = nil
                })
                
                DetailPromtView(promtText: $promtText, title: selectedCategory?.toolSubtitle ?? "")
                    .disabled(showLoader)
                
                HStack(alignment:.center){
                    Spacer()
                    Button(action: {
                        // Download action
                        viewModel.responseText = ""
                        self.sendPrompt()
                    }) {
                        Text("Send Prompt")
                            .font(.semiboldFont(16))
                            .foregroundStyle(Color.botPrimary)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.botPrimaryLight)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    .buttonStyle(.plain)
                    .frame(width: 200)
                }
                .padding(.trailing)
                
                if viewModel.responseText.isEmpty{
                    Spacer()
                }else{
                    DetailResponseView(responseText: $viewModel.responseText)
                }
                
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.chatbg)
            
            
            if showLoader {
                ProgressView()
            }
            
        }
        .overlay {
            ToastView()
        }
        
        Spacer()
    }
    
    
    private func sendPrompt() {
        var promptText = ""
        if let prompt = selectedCategory?.toolPrompt {
            promptText = "\(prompt)\n"
        }
        promptText += self.promtText.trimmingCharacters(in: .whitespacesAndNewlines)
        if let prompt = selectedCategory?.systemInstruction {
            promptText = "\(promptText)\n\(prompt)"
        }
        
        let message = ChatMessageModel(text: promptText, isUserMessage: true, modelType: .chatGPT4O)
        
        self.showLoader = true
        viewModel.sendMessage(message) { error in
            self.showLoader = false
        }
    }
}

fileprivate struct DetailResponseView: View {
    
    @Binding var responseText : String
    
    var body: some View {
        
        VStack(alignment:.leading, spacing:20) {
            Text("AI Response")
                .font(.boldFont(18))
                .foregroundStyle(Color.botPrimaryLight)
            
            
            TextEditor(text: $responseText)
                .lineSpacing(8)
                .font(.regularFont(16))
                .frame(maxWidth: .infinity)
                .padding(.trailing)
                .padding()
                .padding(.bottom)
                .overlay(content: {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.botPrimaryLight, lineWidth: 1)
                    ZStack(alignment:.bottomTrailing) {
                        Color.clear.ignoresSafeArea()
                        Button(action: {
                            responseText.copyToClipboard()
                            ToastManager.shared.show(message: "Copied to clipboard!")
                        }) {
                            Image("copyIcon")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                                .padding(5)
                                .foregroundStyle(Color.botPrimaryLight)
                            
                        }
                        .buttonStyle(.plain)
                        
                    }
                    
                })
                .scrollContentBackground(.hidden)
            
        }
        .padding(20)
        .padding(.leading)
        
    }
}


fileprivate struct DetailPromtView: View {
    @Binding var promtText : String
    var title : String = ""
    
    var body: some View {
        
        VStack(alignment:.leading, spacing:20) {
            Text(title)
                .foregroundStyle(Color.botPrimaryLight)
                .font(.boldFont(16))
            
            
            TextEditor(text: $promtText)
                .font(.regularFont(16))
                .frame(height: 150)
                .frame(maxWidth: .infinity)
                .padding(.trailing)
                .padding()
                .overlay(content: {
                    if promtText.isEmpty {
                        ZStack(alignment: .topLeading) {
                            Color.clear.ignoresSafeArea(edges: .all)
                            Text("Enter your prompt here...")
                                .foregroundStyle(Color.gray)
                                .padding()
                                .padding(.leading, 5)
                        }
                    }
                    
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.botPrimaryLight, lineWidth: 1)
                })
            
                .scrollContentBackground(.hidden)
            
        }
        .padding(20)
        .padding(.leading)
        
    }
}


fileprivate struct DetailHeaderView: View {
    var ttile : String
    var onBackPressed : (() -> Void)
    
    var body: some View {
        HStack(spacing:10) {
            Rectangle()
                .fill(Color.red.opacity(0.001))
                .overlay {
                    Image(systemName: "chevron.backward")
                        .resizable()
                        .scaledToFit()
                        .imageScale(.small)
                        .foregroundStyle(Color.botPrimaryLight)
                        .frame(width: 20, height: 20)
                }
                .frame(width: 40, height: 40)
                .onTapGesture {
                    onBackPressed()
                }
            
            Text(ttile)
                .foregroundStyle(Color.primaryGreen)
                .font(.boldFont(18))
            Spacer()
        }
        .padding()
    }
}

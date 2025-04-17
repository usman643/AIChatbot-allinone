//
//  ChatDefaultPromptsView.swift
//  AIChatbot
//
//  Created by Muhammad Usman on 25/03/2025.
//

import SwiftUI

struct ChatDefaultPromptsView: View {
    
    let prompts: [String] = [
        "Summarize this business idea like you're pitching to an investor in 30 seconds.",
        "Write a professional email that sounds confident, clear, and polite.",
        "Act like a genius inventor—what’s a wild new gadget the world needs?",
        "Give me 3 fun facts that’ll blow my mind in under 10 seconds."
    ]
    
    var onPromptSelected: ((String) -> Void)?
    
    var body: some View {
        VStack(spacing:20) {
            Text("Hello!\nHow can I assist you today?")
                .font(.mediumFont(40))
                .foregroundStyle(Color.botPrimaryLight)
                .multilineTextAlignment(.center)
            
            
            HStack(spacing: 20) {
                PromtStackView(text: prompts.first ?? "")
                    .onTapGesture {
                        onPromptSelected?(prompts.first ?? "")
                    }
                
                PromtStackView(text: prompts[1])
                    .onTapGesture {
                        onPromptSelected?(prompts[1])
                    }
            }
            
            
            HStack(spacing: 20) {
                PromtStackView(text: prompts[2])
                    .onTapGesture {
                        onPromptSelected?(prompts[2])
                    }
                
                PromtStackView(text: prompts[3])
                    .onTapGesture {
                        onPromptSelected?(prompts[3])
                    }
            }
            
            
                
        }
    }
}

#Preview {
    ChatDefaultPromptsView()
        .frame(width: 600, height: 600)
}


fileprivate struct PromtStackView : View {
    var text: String
    
    var body: some View {
        VStack {
            Text(text)
                .font(.lightFont(18))
                .foregroundStyle(Color.botPrimaryLight)
            Spacer()
            
            HStack {
                Spacer()
                Circle()
                    .fill(Color.botPrimaryLight)
                    .frame(width: 40, height: 40)
                    .overlay {
                        Image("promtDumyIcon")
                            .scaledToFit()
                            .foregroundStyle(Color.botPrimary)
                    }
            }
        }
        .padding()
        .frame(width: 280, height: 170)
        .background(
            Color.botPrimary.opacity(0.4)
        )
        .overlay(content: {
            RoundedRectangle(cornerRadius: 14)
                .stroke(.botPrimaryLight, lineWidth: 0.5)
            
        })
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}

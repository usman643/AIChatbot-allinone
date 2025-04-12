//
//  ChatDefaultPromptsView.swift
//  AIChatbot
//
//  Created by Muhammad Usman on 25/03/2025.
//

import SwiftUI

struct ChatDefaultPromptsView: View {
    var body: some View {
        VStack(spacing:20) {
            Text("Hello!\nHow can I assist you today?")
                .font(.mediumFont(40))
                .foregroundStyle(Color.botPrimaryLight)
                .multilineTextAlignment(.center)
            
            
            HStack(spacing: 20) {
                PromtStackView(text: .constant("I am designing a web so, write a case study for this and provide the content for home Page"))
                
                PromtStackView(text: .constant("I am designing a web so, write a case study for this and provide the content for home Page"))
            }
            
            
            HStack(spacing: 20) {
                PromtStackView(text: .constant("I am designing a web so, write a case study for this and provide the content for home Page"))
                
                PromtStackView(text: .constant("I am designing a web so, write a case study for this and provide the content for home Page"))
            }
            
            
                
        }
    }
}

#Preview {
    ChatDefaultPromptsView()
        .frame(width: 600, height: 600)
}


fileprivate struct PromtStackView : View {
    @Binding var text: String
    
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

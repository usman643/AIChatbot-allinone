//
//  MessageErrorView.swift
//  AIChatbot
//
//  Created by Muhammad Usman on 12/04/2025.
//

import SwiftUI

struct MessageErrorView: View {
    
    var onRetry: (() -> Void)?
    
    var body: some View {
        HStack(spacing:0) {
            
            Text("An error occurred. Either the engine you requested does not exist or there was another issue processing your request.")
                .font(.title3)
                .foregroundColor(.red)
                .padding(.horizontal)
                .padding(.trailing)
            
            
            Button(action: {
                self.onRetry?()
            }) {
                
                HStack {
                    Image("rePrompt")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 18, height: 18)
                    
                    Text("Retry")
                        .font(.title3)
                    
                }
                .foregroundColor(.white)
                .padding(5)
                .padding(.horizontal, 20)
                .background(Color.black.opacity(0.2))
                .overlay(content: {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.clear)
                        .stroke(Color.gray, lineWidth: 1)
                })
                .clipShape(RoundedRectangle(cornerRadius: 10))
                
                
                
            }
            .buttonStyle(.borderless)
            
        }
    }
}

#Preview {
    MessageErrorView()
}

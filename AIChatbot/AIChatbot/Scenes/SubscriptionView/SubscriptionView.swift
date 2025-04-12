//
//  SubscriptionView.swift
//  AIChatbot
//
//  Created by Muhammad Usman on 29/03/2025.
//

import SwiftUI

fileprivate struct AIModelView : View {
    let name : String
    let fgColor : Color
    
    var body: some View {
        Rectangle()
            .fill(Color.selectedMenuBack)
            .frame(width: 250, height: 50)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay {
                Text(name)
                    .font(.mediumFont(25)).foregroundColor(fgColor)
            }
    }
}

struct SubscriptionView: View {
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack(alignment:.topLeading) {
            Color.clear.ignoresSafeArea()
            
            HStack(spacing: 0) {
                // Left Side Illustration
                VStack(spacing:10) {
                    Image("subscriptionImage")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 250, height: 250)
                    
                    
                    Text("Powered by")
                        .font(.regularFont(34))
                        .foregroundColor(.botPrimaryLight)
                    
                    AIModelView(name: "ChatGPT", fgColor: .green)
                    AIModelView(name: "DeepSeek", fgColor: .blue)
                    
                }
                .frame(width: 350)
                .frame(maxHeight: .infinity)
                .background(Color.lightGreen)
                
                // Right Side Subscription Options
                
                SubscriptionPlanView()
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                
            }
            
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
        }
        .frame(width: 1000, height: 650)
    }
}



#Preview {
    SubscriptionView()
        .frame(width: 1000, height: 650)
}

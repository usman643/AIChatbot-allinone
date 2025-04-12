//
//  SubscriptionPlanView.swift
//  AIChatbot
//
//  Created by Muhammad Usman on 29/03/2025.
//

import SwiftUI

struct SubscriptionPlanView: View {
    
    @State private var selectedPlan: Int = 2 // Default selected plan
    
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Spacer()
                Button(action: {}) {
                    Text("Restore")
                        .foregroundColor(.white)
                        .padding(10)
                        .padding(.horizontal)
                        .background(Color.black)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                .buttonStyle(.plain)
            }
            
            VStack {
                Text("Unlock Premium Benefits – Elevate")
                    .foregroundStyle(Color.botPrimaryLight)
                Text("Your Experience!")
                    .foregroundStyle(Color.primaryGreen)
                
            }
            .lineLimit(1)
            .font(.semiboldFont(25))
            .padding(.bottom, 20)
            
            HStack(spacing: 18) {
                SubscriptionCard(title: "Basic Plan", price: "$5.99", duration: "Weekly", isSelected: selectedPlan == 0) {
                    selectedPlan = 0
                }
                SubscriptionCard(title: "Standard Plan", price: "$5.99", duration: "Monthly", isSelected: selectedPlan == 1) {
                    selectedPlan = 1
                }
                SubscriptionCard(title: "Premium Plan", price: "$5.99", duration: "Weekly", footer: "Per year plan", isSelected: selectedPlan == 2, highlight: true) {
                    selectedPlan = 2
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 5)
            
            Button(action: {}) {
                Text("Buy Premium Plan")
                    .foregroundColor(.white)
                    .font(.semiboldFont(18))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.primaryGreen)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .frame(width: 250)
            .buttonStyle(.plain)
//            .padding(.horizontal, 40)
            
            Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.")
                .font(.lightFont(13))
                .foregroundColor(.gray)
                .lineLimit(3)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
            
            HStack {
                Button("Privacy Policy", action: {})
                    .buttonStyle(.plain)
                    .underline()
                Text("|").foregroundColor(.gray)
                Button("Terms & Conditions", action: {})
                    .buttonStyle(.plain)
                    .underline()
            }
            .font(.regularFont(16))
            .foregroundColor(.botPrimaryLight)
            
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.botPrimary)
    }
}

#Preview {
    SubscriptionPlanView()
}


struct SubscriptionCard: View {
    let title: String
    let price: String
    let duration: String
    let footer: String?
    let isSelected: Bool
    let highlight: Bool
    let action: () -> Void
    
    init(title: String, price: String, duration: String, footer: String? = nil, isSelected: Bool, highlight: Bool = false, action: @escaping () -> Void) {
        self.title = title
        self.price = price
        self.duration = duration
        self.footer = footer
        self.isSelected = isSelected
        self.highlight = highlight
        self.action = action
    }
    
    var body: some View {
        VStack(spacing: 8) {
            Text(title)
                .foregroundColor(isSelected ?  .primaryGreen : .botPrimaryLight)
                .font(.lightFont(16))
                .padding(8)
                .padding(.top,8)
            Divider()
            
            
            Text(price)
                .font(.semiboldFont(35))
                .foregroundColor(isSelected ?  .primaryGreen : .botPrimaryLight)
                .padding(8)
            
            
            Text(duration)
                .foregroundStyle(isSelected ? Color.primaryGreen : Color.botPrimaryLight)
                .font(.regularFont(14))
                .padding(8)
                .padding(.horizontal, 40)
                .background(Color.chatbg)
                .clipShape(RoundedRectangle(cornerRadius: 6))
                .padding(.bottom,8)
            
            Text("Per week Plan")
                .font(.regularFont(14))
                .foregroundStyle(Color.white)
                .frame(maxWidth: .infinity)
                .padding(13)
                .background(isSelected ? Color.primaryGreen : Color.black)
                
                
           
        }
        .background(Color.botSecondry)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(isSelected ? Color.primaryGreen : Color.clear, lineWidth: 1)
        )
        .shadow(color: isSelected ? .primaryGreen : .gray.opacity(0.3), radius: 3)
        .onTapGesture {
            action()
        }
    }
}

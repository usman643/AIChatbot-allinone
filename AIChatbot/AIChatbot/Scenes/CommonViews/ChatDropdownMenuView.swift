//
//  ChatDropdownMenuView.swift
//  AIChatbot
//
//  Created by Muhammad Usman on 24/03/2025.
//

import SwiftUI

struct ChatDropdownMenuView<T: Hashable & CustomStringConvertible>: View {
    @Binding var selectedOption: T
    let options: [T]
    var menuTitle : String = ""
    let btnBGColor: Color
    let btnTextColor: Color
    var padding: CGFloat = 10
    var btnAlignment: HorizontalAlignment = .leading
    var minMenuWidth: CGFloat = 120
    
    var onOptionSelected: ((T) -> Void)?
    
    @State private var isMenuOpen = false
    
    var body: some View {
        
        VStack(alignment: btnAlignment, spacing: 0) {
            // Button for menu
            
            HStack {
                if !menuTitle.isEmpty {
                    Text(menuTitle)
                        .font(.regularFont(14))
                        .foregroundColor(btnTextColor)
                }
                
                Button(action: {
                    withAnimation(.easeInOut) {
                        isMenuOpen.toggle()
                    }
                }) {
                    HStack {
                        Text(selectedOption.description)
                            .foregroundColor(btnTextColor)
                        Image(systemName: "chevron.down")
                            .foregroundColor(btnTextColor)
                            .rotationEffect(.degrees(isMenuOpen ? 180 : 0)) // Animate arrow
                    }
                    .padding(padding)
    //                .frame(width: 180)
                    .background(btnBGColor)
                    .cornerRadius(padding <= 10 ? padding : 10)
                }
                .buttonStyle(PlainButtonStyle()) // Remove default button styling
            }
            
            // Dropdown menu
            if isMenuOpen {
                VStack(spacing: 0) {
                    ForEach(options, id: \.self) { option in
                        Button(action: {
                            selectedOption = option
                            isMenuOpen = false
                            onOptionSelected?(option)
                        }) {
                            HStack {
                                Image(systemName: "checkmark")
                                    .foregroundColor(selectedOption == option ? .white : .clear)
                                Text(option.description)
                                    .font(.regularFont(15))
                                    .foregroundColor(.white)
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .background(btnBGColor.opacity(0.3))
                        .buttonStyle(.borderless)

                        if option != options.last {
                            Divider().background(Color.white.opacity(0.5))
                                .frame(height: 0.4)
                        }
                    }
                }
                .frame(width:minMenuWidth)
                .background(btnBGColor)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .shadow(radius: 5)
                .offset(y: 5) // Push dropdown below the button
                .zIndex(1) // Ensure it stays on top of other views
            }
        }
    }
}




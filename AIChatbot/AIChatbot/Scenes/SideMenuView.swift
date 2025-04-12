//
//  SideMenuView.swift
//  AIChatbot
//
//  Created by Muhammad Usman on 23/03/2025.
//

import SwiftUI

enum ChatMenuOptions {
    case aiChat
    case aiArt
    
    func getMenuTitle()->String{
        switch self {
        case .aiChat:
            return "AI Chat Model"
        case .aiArt:
            return "AI Art Generator"
        }
    }
    
    func getMenuIcon()->String {
        switch self {
        case .aiChat:
            return "menuChatIcon"
        case .aiArt:
            return "menuArtIcon"
        }
    }
}



struct SideMenuView: View {
    @Environment(\.colorScheme) var colorScheme
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    @Binding var selectedMenu : ChatMenuOptions
    let menuOptions : [ChatMenuOptions] = [.aiChat, .aiArt]
    
//    var menuDidTapped : (ChatMenuOptions)-> Void = {_ in }
    var upgradeProDidTapped : ()-> Void = { }
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 30) {
            HStack {
                Text("AI Chatbot")
                    .font(.boldFont(32))
                    .foregroundStyle(Color.botPrimaryLight)
                Spacer()
                Image("menuIcon")
                    .foregroundStyle(Color.botPrimaryLight)
            }
            .padding(.horizontal, 25)
            
            
            VStack(spacing:5) {
                ForEach(menuOptions, id: \.self) { menuOption in
                    Rectangle()
                        .fill(Color.red.opacity(0.001))
                        .frame(height: 50)
                        .overlay {
                            SideMenuContentView(menuOption: .constant(menuOption) , selectedMenu: $selectedMenu)
                        }
                        .onTapGesture {
                            selectedMenu = menuOption
//                            menuDidTapped(menuOption)
                        }
                }
            }
            .padding(.horizontal, 25)
            
            Spacer()
            
            VStack(alignment: .leading, spacing: 15) {
                Text("Additional Settings")
                    .font(.regularFont(18))
                    .foregroundColor(.gray)
                
                HStack {
                    Text("Dark Mode")
                        .font(.regularFont(18))
                        .foregroundStyle(Color.botPrimaryLight)
                    
                    Spacer()
                    
                    Toggle("", isOn: $isDarkMode)
                        .toggleStyle(.switch)
                        .tint(Color.botPrimaryLight)
                        .onChange(of: isDarkMode) {
                            let newTheme: ColorScheme? = (colorScheme == .dark) ? .light : .dark
                            NSApp.appearance = newTheme == .dark ? NSAppearance(named: .darkAqua) : NSAppearance(named: .aqua)
                        }
                        
                    
                }
                
                Text("Privacy Policy")
                    .font(.regularFont(18))
                    .foregroundStyle(Color.botPrimaryLight)
                    .underline()
                
                Text("Terms & Conditions")
                    .font(.regularFont(18))
                    .foregroundStyle(Color.botPrimaryLight)
                    .underline()
                
            }
            .padding(.horizontal, 25)
            
            
            VStack(alignment: .leading) {
                Image("upgradeProBanner")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .onTapGesture {
                        self.upgradeProDidTapped()
                    }
            }
            .padding(.top, 25)
            .frame(height: 143)
            .frame(maxWidth: .infinity)
            .background(Color.black)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding(.horizontal, 25)
            .padding(.bottom, 30)
            
        }
        .padding(.top, 10)
        .background(Color.botPrimary)
        
    }
}

struct SidebarView_Previews: PreviewProvider {
    static var previews: some View {
        SideMenuView(selectedMenu: .constant(.aiChat))
            .frame(width: 300)
            .previewLayout(.sizeThatFits)
    }
}



fileprivate struct SideMenuContentView : View {
    
    @Binding var menuOption: ChatMenuOptions
    @Binding var selectedMenu : ChatMenuOptions
    
    var body: some View {
        Group {
            HStack(spacing:20) {
                Image(menuOption.getMenuIcon())
                    .foregroundStyle(
                        menuOption == selectedMenu ? Color.primaryWhite : Color.botPrimaryLight
                    )
                    .padding(.leading, 10)
                Text(menuOption.getMenuTitle())
                    .font(menuOption == selectedMenu ? .semiboldFont(16) : .regularFont(16))
                Spacer()
            }
            .padding(10)
            .frame(maxWidth: .infinity)
            .background(menuOption == selectedMenu ? Color.selectedMenuBack : Color.clear)
            .foregroundColor(menuOption == selectedMenu ? Color.primaryWhite : Color.botPrimaryLight)
            .clipShape(RoundedRectangle(cornerRadius: 13))
        }
    }
}

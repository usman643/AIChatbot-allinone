//
//  ContentView.swift
//  AIChatbot
//
//  Created by Muhammad Usman on 23/03/2025.
//

import SwiftUI

struct ContentView: View {
    @State var selectedMenuItem: ChatMenuOptions = .aiChat
//    @State var showUpgradePro: Bool = false
    
    var chatViewModel: ChatViewModel = ChatViewModel()
    
    var body: some View {
        
        HStack(spacing:1) {
            SideMenuView(selectedMenu: $selectedMenuItem, upgradeProDidTapped: {
//                    self.showUpgradePro =  true
            })
            .frame(width: 300, alignment: .leading)
            .frame(maxHeight: .infinity)
            .background(Color.botPrimary)
            
            
            if selectedMenuItem == .aiChat {
                ChatContentView(viewModel: chatViewModel)
            }else if selectedMenuItem == .aiArt{
                ArtContentView()
            }else if selectedMenuItem == .explore{
                NavigationStack {
                    ExploreAIContentView()
                }

            }
            
        }
        
        
//        NavigationStack {
//            
//        }
//        .sheet(isPresented: $showUpgradePro) {
//            SubscriptionView()
//                .frame(maxWidth: .infinity)
//                .presentationBackground(.clear)
//        }
    }
}

#Preview {
    ContentView()
}

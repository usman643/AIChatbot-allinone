//
//  ArtContentView.swift
//  AIChatbot
//
//  Created by Muhammad Usman on 26/03/2025.
//

import SwiftUI

struct ArtContentView: View {
    
    @State var showResponseSheet : Bool = false
    
    var body: some View {
        
        NavigationStack {
            VStack(spacing: 0) {
                
                ArtDefaultPromptsView()
                    .padding(.top)
                
                Spacer()
                
                ChatTextBoxView(messageState: .constant(.noState), promtMessage: .constant(nil) ,sendMessageDidTapped: { message, attachments in
                    self.showResponseSheet = true
                })
                .padding(.bottom)
                .padding(.horizontal, 100)
            }
            .background(Color.chatbg)
        }
        .sheet(isPresented: $showResponseSheet) {
            ArtResponseView()
                .presentationBackground(.clear)
        }
    }
}

#Preview {
    ArtContentView()
        .frame(width: 800, height: 800)
}

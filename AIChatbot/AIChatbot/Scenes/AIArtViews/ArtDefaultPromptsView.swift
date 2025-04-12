//
//  ArtDefaultPromptsView.swift
//  AIChatbot
//
//  Created by Muhammad Usman on 26/03/2025.
//

import SwiftUI

struct ArtDefaultPromptsView: View {
    var body: some View {
        VStack(spacing:20) {
            Text("Let’s start generating with AI")
                .font(.mediumFont(40))
                .foregroundStyle(.botPrimaryLight)
            
            HStack(spacing:20) {
                ArtPromptView(imageName: "artprompt1", title: "Imagine 2 lines standing in a beautiful jungle in a rock")
                
                ArtPromptView(imageName: "artprompt2", title: "Imagine 2 lines standing in a beautiful jungle in a rock")
                
                ArtPromptView(imageName: "artprompt3", title: "Imagine 2 lines standing in a beautiful jungle in a rock")
            }
            
            HStack(spacing:20) {
                ArtPromptView(imageName: "artprompt1", title: "Imagine 2 lines standing in a beautiful jungle in a rock")
                
                ArtPromptView(imageName: "artprompt2", title: "Imagine 2 lines standing in a beautiful jungle in a rock")
                
                ArtPromptView(imageName: "artprompt3", title: "Imagine 2 lines standing in a beautiful jungle in a rock")
            }
            
        }
    }
}

#Preview {
    ArtDefaultPromptsView()
        .frame(width: 600, height: 600)
}



fileprivate struct ArtPromptView : View {
    
    let imageName : String
    let title : String
    
    var body: some View {
        VStack(alignment:.leading,spacing:3) {
            Image(imageName)
                .resizable()
                .scaledToFit()
                .padding(.bottom, 5)
            
            Text(title)
                .font(.regularFont(16))
                .foregroundStyle(Color.botPrimaryLight)
                .padding(.horizontal, 5)
                .lineLimit(2)
                .lineSpacing(5)
                
        }
        .frame(width: 250, height: 230)
        .padding(0)
//        .background(Color.red)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}


#Preview {
    ArtPromptView(imageName: "artprompt3", title: "Imagine 2 lines standing in a beautiful jungle in a rock")
        .frame(width: 600, height: 600)
}

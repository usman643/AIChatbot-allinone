//
//  ArtDefaultPromptsView.swift
//  AIChatbot
//
//  Created by Muhammad Usman on 26/03/2025.
//

import SwiftUI

fileprivate struct ArtPrompts {
    let title: String
    let image : String
}



struct ArtDefaultPromptsView: View {
    
    fileprivate let promts : [ArtPrompts] = [
        ArtPrompts(title: "Cyberpunk-style illustration of a glowing purple robotic hand holding golden Bitcoin coins, with a neon digital background and circuit patterns.", image: "artprompt1"),
        
        ArtPrompts(title: "Futuristic city skyline with towering skyscrapers, glowing lights, and a dramatic sunset sky.", image: "artprompt2"),
        
        ArtPrompts(title: "Futuristic learning meets nature—students immersed in digital education with high-tech headgear in a lush, green environment.", image: "artprompt3"),
        
        ArtPrompts(title: "A beautiful and serene landscape with a combination of nature and modern design elements, perfect for use as a place image in a macOS app. The setting should be tranquil, showcasing a peaceful outdoor scene with trees, water, and a clear sky, blended with a hint of contemporary architecture. The color palette should be soft and calming, featuring shades of green, blue, and earthy tones. The image should have a sense of harmony and balance, ideal for a suggestion in an app focused on relaxation, productivity, or creativity.", image: "artprompt4"),
        
        ArtPrompts(title: "A sleek and professional workspace setup featuring a modern desk with a laptop, a stylish chair, and minimalistic decor. The desk should be organized with a few essential items, such as a plant, a notebook, and a cup of coffee. The background should have large windows with a cityscape view, showcasing a bright and clean atmosphere. The color palette should be neutral with shades of white, grey, and light wood, evoking a sense of calm, productivity, and sophistication.", image: "artprompt5"),
        
        ArtPrompts(title: "A beautiful and serene landscape with a combination of nature and modern design elements, perfect for use as a place image in a macOS app. The setting should be tranquil, showcasing a peaceful outdoor scene with trees, water, and a clear sky, blended with a hint of contemporary architecture. The color palette should be soft and calming, featuring shades of green, blue, and earthy tones. The image should have a sense of harmony and balance, ideal for a suggestion in an app focused on relaxation, productivity, or creativity.", image: "artprompt6")
    ]
    
    var onPromtMsg: ((ChatMessageModel) -> Void)?
    
    var body: some View {
        VStack(spacing:20) {
            Text("Let’s start generating with AI")
                .font(.mediumFont(40))
                .foregroundStyle(.botPrimaryLight)
                .padding(.top)
            
            Spacer()
            
            HStack(spacing:20) {
                ArtPromptView(imageName: promts[0].image, title: promts[0].title)
                    .onTapGesture {
                        setupPromtmessage(index: 0)
                    }
                
                ArtPromptView(imageName: promts[1].image, title: promts[1].title)
                    .onTapGesture {
                        setupPromtmessage(index: 1)
                    }
                
                ArtPromptView(imageName: promts[2].image, title: promts[2].title)
                    .onTapGesture {
                        setupPromtmessage(index: 2)
                    }
            }
            
            HStack(spacing:20) {
                ArtPromptView(imageName: promts[3].image, title: promts[3].title)
                    .onTapGesture {
                        setupPromtmessage(index: 3)
                    }
                
                ArtPromptView(imageName: promts[4].image, title: promts[4].title)
                    .onTapGesture {
                        setupPromtmessage(index: 4)
                    }
                
                ArtPromptView(imageName: promts[5].image, title: promts[5].title)
                    .onTapGesture {
                        setupPromtmessage(index: 5)
                    }
            }
            

            Spacer()
            
        }
    }
    
    private func setupPromtmessage(index:Int) {
        if let attachment = self.getPromtImageUrl(name: promts[index].image){
            let message = ChatMessageModel(text: promts[index].title, attachments: [attachment], isUserMessage: true, modelType: .chatGPT3_5)
            onPromtMsg?(message)
        }
    }
        
    
    private func getPromtImageUrl(name: String) -> String? {
        if let url = Bundle.main.url(forResource: name, withExtension: "png") {
            return url.absoluteString
        }
        return nil
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
        VStack(alignment:.leading,spacing:12) {
            if let imagUrl = getPromtImageUrl(name: imageName), let nsImage = NSImage(contentsOf: imagUrl) {
                Image(nsImage: nsImage)
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 10))
//                    .padding(.bottom, 8)
            }
            
            Text(title)
                .font(.regularFont(16))
                .foregroundStyle(Color.botPrimaryLight)
                .padding(.horizontal, 5)
                .lineLimit(2)
                .lineSpacing(5)
                
        }
        .frame(width: 250, height: 220)
        .padding(0)
//        .background(Color.red)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    private func getPromtImageUrl(name: String) -> URL? {
        if let url = Bundle.main.url(forResource: name, withExtension: "png") {
            return url
        }
        return nil
    }
}


#Preview {
    ArtPromptView(imageName: "artprompt3", title: "Imagine 2 lines standing in a beautiful jungle in a rock")
        .frame(width: 600, height: 600)
}

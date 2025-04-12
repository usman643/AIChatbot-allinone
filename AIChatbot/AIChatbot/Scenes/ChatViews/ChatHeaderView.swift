//
//  ChatContentView.swift
//  AIChatbot
//
//  Created by Muhammad Usman on 24/03/2025.
//

import SwiftUI

struct ChatHeaderView: View {
    
    let headerSelection: [HeaderOptions]
    
    var onModelSelection: ((ChatModelType) -> Void)?
    var onFontSelection: ((FontType) -> Void)?
    
    var body: some View {
        NavigationStack {
            HStack(alignment: .center) {
                
                if headerSelection.contains(.modelSelection) {
                    
                    ChatModelSelectionView(btnBGColor: .selectedMenuBack, btnTextColor: .primaryWhite, padding: 15,onOptionSelected: { model in
                        self.onModelSelection?(model)
                    })
                    .frame(height: 50, alignment: .top)
                    .padding(.horizontal, 15)
                }
                
                
                Spacer()
                
                if headerSelection.contains(.languageSelection) {
                    LanguageSelectionView(menuTitle:"Language : " ,btnBGColor: .appGray, btnTextColor: .botPrimaryLight, padding: 5, btnAlignment:.trailing, onOptionSelected: { model in
                        
                    })
                    .frame(height: 50, alignment: .top)
                    .padding(.trailing, 15)
                    .padding(.top)
                }
                
                if headerSelection.contains(.fontSelection) {
                    FontSelectionView(menuTitle:"Font Size : " ,btnBGColor: .appGray, btnTextColor: .botPrimaryLight, padding: 5, btnAlignment:.trailing, onOptionSelected: { model in
                        self.onFontSelection?(model)
                    })
                    .frame(height: 50, alignment: .top)
                    .padding(.trailing, 5)
                    .padding(.top)
                }
                
                if headerSelection.contains(.exportChat) {
                    Button {
                       //Action for export chat
                    } label: {
                        Image("exportChat")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.botPrimaryLight)
                            .padding(.bottom, 15)
                    }
                    .padding(.trailing, 5)
                    .frame(width: 40, height: 70)
                    .buttonStyle(.plain)
                }
                
                if headerSelection.contains(.shareChat) {
                    Button {
                       //Action for share button
                    } label: {
                        Image("shareIcon")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.botPrimaryLight)
                            .padding(.bottom, 7)
                    }
                    .padding(.trailing, 15)
                    .frame(width: 40, height: 70)
                    .buttonStyle(.plain)
                }
                
            }
        }
    }
}

#Preview {
    
    ChatHeaderView(headerSelection: [.modelSelection, .languageSelection, .fontSelection,.exportChat, .shareChat])
        .frame(width:700, height: 400)
}

struct ChatModelSelectionView: View {
    @State private var selectedModel: ChatModelType = .chatGPT3_5
    var menuTitle : String = ""
    let btnBGColor: Color
    let btnTextColor: Color
    var padding: CGFloat = 10
    var btnAlignment : HorizontalAlignment = .leading
    
    var onOptionSelected: ((ChatModelType) -> Void)?
    
    var body: some View {
        ChatDropdownMenuView(selectedOption: $selectedModel, options: ChatModelType.allCases, menuTitle: menuTitle, btnBGColor: btnBGColor, btnTextColor: btnTextColor, padding: padding, btnAlignment: btnAlignment, minMenuWidth: 200, onOptionSelected: onOptionSelected)
    }
}


enum LanguageType: String, CaseIterable, CustomStringConvertible {
    case english = "English"
    case spanish = "Spanish"
    case french = "French"
    case german = "German"
    
    var description: String { self.rawValue }
}

struct LanguageSelectionView: View {
    @State private var selectedLanguage: LanguageType = .english
    var menuTitle : String = ""
    let btnBGColor: Color
    let btnTextColor: Color
    var padding: CGFloat = 10
    var btnAlignment : HorizontalAlignment = .leading
    
    var onOptionSelected: ((LanguageType) -> Void)?
    
    var body: some View {
        ChatDropdownMenuView(selectedOption: $selectedLanguage, options: LanguageType.allCases, menuTitle: menuTitle, btnBGColor: btnBGColor, btnTextColor: btnTextColor, padding: padding, btnAlignment: btnAlignment, onOptionSelected: onOptionSelected)
    }
}


enum FontType: String, CaseIterable, CustomStringConvertible {
    case px12 = "12 px"
    case px14 = "14 px"
    case px16 = "16 px"
    case px18 = "18 px"
    case px20 = "20 px"
    case px22 = "22 px"
    case px24 = "24 px"
    
    var description: String { self.rawValue }
    
    func getFontSize() -> CGFloat {
        switch self {
        case .px12:
            return 12.0
        case .px14:
            return 14.0
        case .px16:
            return 16.0
        case .px18:
            return 18.0
        case .px20:
            return 20.0
        case .px22 :
            return 22.0
        case .px24 :
            return 24.0
        }
    }
    
}

struct FontSelectionView: View {
    @State private var selectedLanguage: FontType = .px16
    var menuTitle : String = ""
    let btnBGColor: Color
    let btnTextColor: Color
    var padding: CGFloat = 10
    var btnAlignment : HorizontalAlignment = .leading
    
    var onOptionSelected: ((FontType) -> Void)?
    
    var body: some View {
        ChatDropdownMenuView(selectedOption: $selectedLanguage, options: FontType.allCases, menuTitle: menuTitle, btnBGColor: btnBGColor, btnTextColor: btnTextColor, padding: padding, btnAlignment: btnAlignment, onOptionSelected: onOptionSelected)
    }
}

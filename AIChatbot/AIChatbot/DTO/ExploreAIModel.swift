//
//  ExploreAIModel.swift
//  AIChatbot
//
//  Created by Muhammad Usman on 16/04/2025.
//

import Foundation

struct ExploreAICategoryModel : Codable, Identifiable, Equatable, Hashable {
    
    var id = UUID().uuidString
    
    let category: String
    let subcategories: [ExploreAISubcategoryModel]
    
    enum CodingKeys: String, CodingKey {
        case category
        case subcategories
    }
}


struct ExploreAISubcategoryModel: Codable, Hashable, Identifiable {
    var id = UUID().uuidString
    let toolIcon: String
    let toolTitle: String
    let toolSubtitle: String
    let placeholderQuestion: String
    let actionButtonText: String
    let toolPrompt: String
    let systemInstruction: String
    
    enum CodingKeys: CodingKey {
        case toolIcon
        case toolTitle
        case toolSubtitle
        case placeholderQuestion
        case actionButtonText
        case toolPrompt
        case systemInstruction
    }
}

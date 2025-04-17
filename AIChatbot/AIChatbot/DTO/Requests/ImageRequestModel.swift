//
//  ImageRequestModel.swift
//  AIChatbot
//
//  Created by Muhammad Usman on 14/04/2025.
//

import Foundation

enum ImageRequestType: String, Codable {
    case textToImage = "generation"
    case imageToImage = "variation"
    
    func getImageSize() -> String {
        return "1024x1024"
    }
    
    func getImagesQuantity() -> Int {
        return 2
    }
}

struct ImageRequestModel: Codable, Identifiable {
    var id : String = UUID().uuidString
    
    var prompt: String?
    var imageBase64: String?
    var type: String
    let n: Int
    let size: String
    
    
    init(prompt: String? = nil, imageBase64: String? = nil, type: String, n: Int, size: String) {
        self.prompt = prompt
        self.imageBase64 = imageBase64
        self.type = type
        self.n = n
        self.size = size
    }
    
    enum CodingKeys: CodingKey {
        case prompt
        case imageBase64
        case type
        case n
        case size
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.prompt = try container.decodeIfPresent(String.self, forKey: .prompt)
        self.imageBase64 = try container.decodeIfPresent(String.self, forKey: .imageBase64)
        self.type = try container.decode(String.self, forKey: .type)
        self.n = try container.decode(Int.self, forKey: .n)
        self.size = try container.decode(String.self, forKey: .size)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.prompt, forKey: .prompt)
        try container.encodeIfPresent(self.imageBase64, forKey: .imageBase64)
        try container.encode(self.type, forKey: .type)
        try container.encode(self.n, forKey: .n)
        try container.encode(self.size, forKey: .size)
    }
    
}

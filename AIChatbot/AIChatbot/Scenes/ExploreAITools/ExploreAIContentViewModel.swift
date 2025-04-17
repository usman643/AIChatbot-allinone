//
//  ExploreAIContentViewModel.swift
//  AIChatbot
//
//  Created by Muhammad Usman on 16/04/2025.
//

import Foundation

final class ExploreAIContentViewModel : ObservableObject {
    
    @Published var exploreModel : [ExploreAICategoryModel] = []
    
    
    init() {
        getExploreJson()
    }
    
    
    func getExploreJson(){
        let url = Bundle.main.url(forResource: "explore", withExtension: "json")!
        do {
            let jsonData = try Data(contentsOf: url)
            let result = try JSONDecoder().decode([ExploreAICategoryModel].self,from: jsonData)
            
            self.exploreModel = result
            
        }
        catch {
            print(error)
        }
    }
}

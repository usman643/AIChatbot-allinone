//
//  ExploreAIDetailViewModel.swift
//  AIChatbot
//
//  Created by Muhammad Usman on 16/04/2025.
//

import Foundation

class ExploreAIDetailViewModel : ObservableObject {
    @Published var responseText: String = ""
    
    
    
    func sendMessage(_ message: ChatMessageModel, completion: ((_ error:String?) -> Void)? = nil) {

        //send message to server
        APIClient.shared.sendMessage(message: message) { response in
            switch response {
            case .success(let reply):
                DispatchQueue.main.async{
                    self.responseText = reply
                    completion?(nil)
                }
            case .failure(let error):
                print(error)
                completion?("Something went wrong, please try reloading the conversation.")
            }
        }
    }
    
    
    
}

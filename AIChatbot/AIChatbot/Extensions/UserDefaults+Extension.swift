//
//  UserDefaults+Extension.swift
//  AIChatbot
//
//  Created by Muhammad Usman on 08/04/2025.
//

import Foundation

fileprivate let keyUserChat = "key_user_chat"


extension UserDefaults {
    
    var chatModelStorage : [ChatModel]? {
        get{
            do {
                if let object = object(forKey: keyUserChat) as? Data{
                    let status = try JSONDecoder().decode([ChatModel].self, from: object)
                    return status
                }
            } catch {
                print(error)
            }
            return nil
        }
        
        set{
            if let newValue = newValue{
                do {
                    let encodeData = try JSONEncoder().encode(newValue)
                    set(encodeData, forKey: keyUserChat)
                    // synchronize is not needed
                } catch {
                    print(error)
                }
            }else{
                removeObject(forKey: keyUserChat)
            }
            
        }
    }
    
    
    
}

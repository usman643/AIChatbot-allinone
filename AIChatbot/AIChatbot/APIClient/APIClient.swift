//
//  APIClient.swift
//  AIChatbot
//
//  Created by Muhammad Usman on 02/04/2025.
//

import Foundation

class APIClient {
    static let shared = APIClient()
    
    private init() {}
    
    func sendMessage(message: ChatMessageModel, completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: message.modelType.baseUrl) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 400, userInfo: nil)))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        var body: [String: Any] = ["message": message.text ?? "", "model":message.modelType.rawValue]
        
        if let attachments = message.attachments, attachments.count > 0, message.modelType == .chatGPT4Turbo {
            //convert Images to base64
            let base64Arr = attachments.compactMap {
                AttachmentUtils.shared.imageToBase64($0)
            }
            
            body["attachments"] = base64Arr
        }
        
        
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
        } catch {
            completion(.failure(error))
            return
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NSError(domain: "Invalid Response", code: 500, userInfo: nil)))
                return
            }

            guard (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(NSError(domain: "Server Error", code: httpResponse.statusCode, userInfo: nil)))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "No Data Received", code: 500, userInfo: nil)))
                return
            }

            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let reply = json["reply"] as? String {
                    completion(.success(reply))
                } else {
                    completion(.failure(NSError(domain: "Invalid JSON Structure", code: 500, userInfo: nil)))
                }
            } catch {
                completion(.failure(error))
            }
        }

        task.resume()
    }

}

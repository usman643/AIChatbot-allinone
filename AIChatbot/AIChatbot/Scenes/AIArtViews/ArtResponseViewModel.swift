//
//  ArtResponseViewModel.swift
//  AIChatbot
//
//  Created by Muhammad Usman on 14/04/2025.
//

import Foundation
import AppKit

class ArtResponseViewModel : ObservableObject {
    
    var reqModel : ImageRequestModel
    @Published var artResponse : [NSImage] = []
    
    init(reqModel: ImageRequestModel) {
        self.reqModel = reqModel
    }
    
    func fetchArtResponse(completion: @escaping(() -> Void)) {
        APIClient.shared.generateImages(request: reqModel) { response in
            switch response {
            case .success(let imageUrls):
                
                DispatchQueue.global().async {
                    let images: [NSImage] = imageUrls.compactMap { urlStr in
                        if let url = URL(string: urlStr) {
                            var fetchedImage: NSImage? = nil
                            let group = DispatchGroup()
                            group.enter()
                            AttachmentUtils.shared.downloadPNGImage(from: url) { image in
                                fetchedImage = image
                                group.leave()
                            }
                            group.wait()
                            return fetchedImage
                        }
                        return nil
                    }

                    DispatchQueue.main.async {
                        
                        if let model = self.reqModel.imageBase64, model.count > 0 {
                            self.artResponse.insert(contentsOf: images, at: 0)
                        }else{
                            self.artResponse = images
                        }
                        
                        completion()
                    }
                }
                
            case .failure(let error):
                print(error)
//                completion?("Something went wrong, please try reloading the conversation.")
            }
        }
    }
    
    
    
}

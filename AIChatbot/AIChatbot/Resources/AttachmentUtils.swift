//
//  AttachmentUtils.swift
//  AIChatbot
//
//  Created by Muhammad Usman on 11/04/2025.
//

import Foundation
import AppKit

final class AttachmentUtils {
    static let shared = AttachmentUtils()
    let imageFolderURL = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!.appendingPathComponent("AIChatbot/Images")
    
    private init(){
        self.createImageDirectory()
    }
    
    private func createImageDirectory(){
        if !FileManager.default.fileExists(atPath: imageFolderURL.path) {
            try? FileManager.default.createDirectory(at: imageFolderURL, withIntermediateDirectories: true, attributes: nil)
        }
    }
    
    func openImagePicker(completion: ((URL) -> Void)) {
        let panel = NSOpenPanel()
        panel.allowedContentTypes = [.image]
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = false
        panel.title = "Choose a photo"
        
        if panel.runModal() == .OK {
            if let url = panel.url {
                // Save the image to the local directory
                completion(saveImageToLocalDirectory(imageURL: url))
            }
        }
    }
    
    
    
    private func saveImageToLocalDirectory(imageURL: URL)->URL {
        let fileManager = FileManager.default
        let fileName = imageURL.lastPathComponent
        let newFileURL = imageFolderURL.appendingPathComponent(fileName)
        
        do {
            // If the image already exists in the directory, remove the old file
            if fileManager.fileExists(atPath: newFileURL.path) {
                try fileManager.removeItem(at: newFileURL)
            }
            try fileManager.copyItem(at: imageURL, to: newFileURL)
        }catch {
            print("Error saving image: \(error.localizedDescription)")
        }
        
        return newFileURL
        
    }
    
    
    func imageToBase64(_ imageUrlStr: String) -> String? {

        if let imageUrl = URL(string: imageUrlStr), let nsImage = NSImage(contentsOf: imageUrl) {
            
            guard let tiffData = nsImage.tiffRepresentation,
                  let bitmap = NSBitmapImageRep(data: tiffData),
                  let pngData = bitmap.representation(using: .png, properties: [:]) else {
                return nil
            }
            return pngData.base64EncodedString()
        }
        
        return nil
        
    }
    
}

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
            
            return imageToBase64(nsImage: nsImage)
        }
        
        return nil
        
    }
    
    func imageToBase64(nsImage: NSImage)->String?{
        guard let tiffData = nsImage.tiffRepresentation,
              let bitmap = NSBitmapImageRep(data: tiffData),
              let pngData = bitmap.representation(using: .png, properties: [:]) else {
            return nil
        }
        return pngData.base64EncodedString()
    }
    
    
    
    func resizeImage(image: NSImage, size: ImageSize = .square, customSize:NSSize? = nil) -> NSImage {
        var newSize: NSSize
        switch size {
        case .wide:
            newSize = NSSize(width: 600, height: 400)
        case .square:
            newSize = NSSize(width: 465, height: 469)
        case .tall:
            newSize = NSSize(width: 400, height: 600)
        }
        
        if let customSize = customSize {
            newSize = customSize
        }
        
        let resizedImage = NSImage(size: newSize)
        resizedImage.lockFocus()
        image.draw(in: NSRect(origin: .zero, size: newSize),
                   from: NSRect(origin: .zero, size: image.size),
                   operation: .copy,
                   fraction: 1.0)
        resizedImage.unlockFocus()
        return resizedImage
    }
    
    
    func downloadPNGImage(from url: URL, completion: @escaping (NSImage?) -> Void) {
        DispatchQueue.global().async {
            do {
                let imageData = try Data(contentsOf: url)
                if let image = NSImage(data: imageData) {
                    DispatchQueue.main.async {
                        completion(image)
                    }
                } else {
                    print("Failed to create image from data")
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                }
            } catch {
                print("Error downloading image: \(error)")
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }
    
    func shareImage(_ image: NSImage) {
        guard let window = NSApp.keyWindow else { return }
        
        let sharingServicePicker = NSSharingServicePicker(items: [image])
        
        // Show the share sheet anchored to the share button
        if let buttonView = NSApp.keyWindow?.contentView?.superview {
            sharingServicePicker.show(relativeTo: .zero, of: buttonView, preferredEdge: .minY)
        }
    }
    
    func saveImage(_ image: NSImage?, completion:@escaping ((_ path:String) -> Void)) {
        guard let image = image else {
            print("No image to save.")
            return
        }
        
        DispatchQueue.main.async {
            let panel = NSSavePanel()
            panel.allowedContentTypes = [.image] // add other file types if needed, e.g., ["png", "jpg"]
            panel.nameFieldStringValue = "generated_image.png" // Default file name
            
            panel.begin { response in
                if response == .OK, let url = panel.url {
                    do {
                        // Convert the NSImage to PNG data
                        if let tiffData = image.tiffRepresentation,
                           let bitmap = NSBitmapImageRep(data: tiffData),
                           let pngData = bitmap.representation(using: .png, properties: [:]) {
                            
                            try pngData.write(to: url, options: .atomic)
                            print("Image saved successfully at \(url.path)")
                            completion(url.path)
                        } else {
                            print("Failed to convert image to PNG format.")
                        }
                    } catch {
                        print("Error saving the image: \(error.localizedDescription)")
                    }
                } else {
                    print("Save panel was cancelled or failed to return a URL.")
                }
            }
        }
    }
    
}


extension NSImage {
    var pngData: Data? {
        guard let tiffData = self.tiffRepresentation,
              let bitmap = NSBitmapImageRep(data: tiffData) else {
            return nil
        }
        return bitmap.representation(using: .png, properties: [:])
    }
}

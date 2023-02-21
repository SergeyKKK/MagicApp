//
//  DatabaseService.swift
//  Magic
//
//  Created by Nodir on 10/11/22.
//

import UIKit

protocol DatabaseProtocol {
    func retrievePhotos(callback: ([ImageData]) -> ())
}

struct DatabaseService: DatabaseProtocol {
    
    func saveImageToDocumentDirectory(image: UIImage, filemame: String) {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileName = filemame
        let fileURL = documentsDirectory.appendingPathComponent("").appendingPathComponent(fileName)
        
        if let data = image.jpegData(compressionQuality: 1.0) {
            do {
                try data.write(to: fileURL)
            } catch {
                print("error saving file:", error)
            }
        }
    }
    
    func files(for key: String) -> [ImageData] {
        var fileData: Data
        var images: [ImageData] = []
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let directoryURL = documentsURL.appendingPathComponent("")
        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: directoryURL, includingPropertiesForKeys: nil)

            // process files
            for imagePath in fileURLs {

                guard let index = (imagePath.path.range(of: "Documents/")?.upperBound) else {
                    return []
                }
                let afterEqualsTo = String(imagePath.path.suffix(from: index))
                
                fileData = fileManager.contents(atPath: imagePath.path)!
                images.append(ImageData(imageName: afterEqualsTo, image: UIImage(data: fileData)!))
                
            }
            return images
            
        } catch {
            print(error)
            return []
        }
    }
    
    func retrievePhotos(callback: ([ImageData]) -> ()) {
        callback(files(for: "Magic"))
    }
    
    //MARK:- Delete image
    
    func deleteDirectory(name file: String) {
        let fileManager = FileManager.default
        let documentUrl = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let directoryUrl = documentUrl.appendingPathComponent("").appendingPathComponent(file)
        
        if fileManager.fileExists(atPath: directoryUrl.path) {
            
            try! fileManager.removeItem(atPath: directoryUrl.path)
        }
    }
    
    
    //MARK:- NOT USED BUT KEPT FOR FURTHER DEVELOPMENT IN FUTURE
    func store(image: UIImage, forKey key: String) {
        if let pngRepresentation = image.pngData() {
            if let filePath = filePath(forKey: key) {
                do  {
                    try pngRepresentation.write(to: filePath, options: .atomic)
                } catch let err {
                    print("Saving file resulted in error: ", err)
                }
            }
        }
    }
    
    func retrieveImage(forKey key: String) -> UIImage? {
        
        if let filePath = self.filePath(forKey: key),
            let fileData = FileManager.default.contents(atPath: filePath.path),
            let image = UIImage(data: fileData) {
            return image
        }
        
        return nil
    }
    
    private func filePath(forKey key: String) -> URL? {
        let fileManager = FileManager.default
        guard let documentURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        
        return documentURL.appendingPathComponent(key + ".png")
    }
    
}

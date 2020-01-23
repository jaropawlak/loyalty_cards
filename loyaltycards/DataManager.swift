//
//  DataManager.swift
//  loyaltycards
//
//  Created by Jarosław Pawlak on 18/01/2020.
//  Copyright © 2020 MAJATECH Jarosław Pawlak. All rights reserved.
//

import Foundation
import UIKit

class DataManager {
    func addNewImage(_ image: UIImage) {
        let fileManager = FileManager.default
        let fileName = UUID().uuidString
        let thumbName =  fileName + "thumbnail"
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        let f1 = fileManager.createFile(atPath: documentsURL.appendingPathComponent(fileName).path, contents: image.pngData()!, attributes:nil)
        let thumbnail = resizeImage(image: image, targetSize: CGSize(width: 80, height: 80))
        let f2 = fileManager.createFile(atPath: documentsURL.appendingPathComponent(thumbName).path, contents: thumbnail.pngData()!, attributes: nil)
        assert(f1 && f2)
        
    }
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size

        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height

        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }

        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0,y: 0,width: newSize.width,height: newSize.height)

        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in:rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
    }
    func getThumbnail(for url: URL) -> UIImage? {
        return getImage(for: url)
    }
    func getImage(for url: URL) -> UIImage? {
        let fileManager = FileManager.default
        if let data = fileManager.contents(atPath: url.path) {
            return UIImage(data: data)
        }
        return nil
    }
    func getFullImage(for url: URL) -> UIImage? {
        let newUrl = URL(fileURLWithPath: url.path.replacingOccurrences(of: "thumbnail", with: ""))
        return getImage(for: newUrl)
    }
    func deleteImage(at url: URL) {
        let fileManager = FileManager.default
        let fullImageUrl = URL(fileURLWithPath: url.path.replacingOccurrences(of: "thumbnail", with: ""))
        
        try? fileManager.removeItem(at: url)
        try? fileManager.removeItem(at: fullImageUrl)
    }
    
    func getFileNames() -> [URL] {
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
            return fileURLs.filter({ url -> Bool in
                url.lastPathComponent.contains("thumbnail")
            })
            // process files
        } catch {
            print("Error while enumerating files \(documentsURL.path): \(error.localizedDescription)")
        }
        return []
    }
}

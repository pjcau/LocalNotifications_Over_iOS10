//
//  UIHelper.swift
//  iOS10_LocalNotifications
//
//  Created by Cau Pierre Jonny on 2017-09-26.
//  Copyright © 2017 Cau Pierre Jonny . All rights reserved.
//

import UIKit

/// `UIHelper` helper class.
///
final class UIHelper {
    
    class func storeImage(_ image: UIImage, _ name: String) -> URL? {
        let data = UIImagePNGRepresentation(image)
        
        let path = FileManager.default.urls(for: FileManager.SearchPathDirectory.cachesDirectory, in: FileManager.SearchPathDomainMask.userDomainMask)[0]
        
        do {
            
            let fileURL = path.appendingPathComponent("\(name)")
            _ = try data?.write(to: fileURL)
            
            return fileURL
            
        } catch {
            
            return nil
        }
    }
    
    
    class func saveImage(name: String, path: String?) -> URL? {
        
        guard let image = UIImage(named: name) else {
            guard let path = path, let image = UIImage(contentsOfFile: path) else {
                return nil
            }
            return storeImage(image, name)
        }
        return storeImage(image, name)
        
    }
    
}


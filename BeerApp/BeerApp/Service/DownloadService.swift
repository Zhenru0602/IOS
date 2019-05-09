//
//  DownloadService.swift
//  BeerApp
//
//  Created by mac on 5/9/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

typealias ImageHandler = (UIImage?) -> Void

let DLService = DownloadService.shared

final class DownloadService {
    
    static let shared = DownloadService()
    private init() {}
    
    
    let cache = NSCache<NSString, UIImage>()
    
    func downloadImage(url: String, completion: @escaping ImageHandler) {
        
        //check if the image is in the cache
        if let image = cache.object(forKey: url as NSString) {
            completion(image)
            print("Received Image From Cache")
            return
        }
        
        //construct URL from string
        guard let finalURL = URL(string: url) else {
            completion(nil)
            return
        }
        
        //create API Request
        URLSession.shared.dataTask(with: finalURL) { [unowned self] (dat, _, err) in
            
            if let error = err {
                print("Couldn't Retrieve Data: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            if let data = dat {
                
                guard let image = UIImage(data: data) else {
                    completion(nil)
                    return
                }
                
                //set the image with url in cache
                self.cache.setObject(image, forKey: url as NSString)
                
                //go to the main thread to pass the completion
                DispatchQueue.main.async {
                    completion(image)
                }
            }
        }.resume()
        
    }
    
    
    
    
    
    
    
    
}

//
//  URL+Extension.swift
//  LockBox
//
//  Created by mac on 5/31/19.
//  Copyright © 2019 mac. All rights reserved.
//

import AVFoundation
import UIKit

extension URL {
    
    func thumbnailForVideo() -> UIImage? {
        //URL MUST have .mov as a suffix
        
        //construct an AVAsset
        let asset = AVAsset(url: self)
        
        //image generator from AVAsset
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        
        //time stamp for image generator
        let time = CMTimeMake(value: 2, timescale: 1)
        
        do {
            let imageRef = try imageGenerator.copyCGImage(at: time, actualTime: nil)
            let image = UIImage(cgImage: imageRef)
            return image
        } catch {
            return nil
        }
    }
    
    
    
    
}

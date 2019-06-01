//
//  MediaCollectionCell.swift
//  LockBox
//
//  Created by mac on 5/31/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

class MediaCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var mediaImage: UIImageView!
    
    static let identifier = "MediaCollectionCell"
    
    
    func configure(with content: Content) {
        
        switch content.isVideo {
        case true:
            
            guard let url = FileService.loadWithFM(content.path!), let image = url.thumbnailForVideo() else {
                return
            }
            
            mediaImage.image = image
            
        case false:
            
            guard let url = FileService.loadWithFM(content.path!), let image = UIImage(contentsOfFile: url.path) else {
                return
            }
            
            mediaImage.image = image
        }
    }
    
    
}

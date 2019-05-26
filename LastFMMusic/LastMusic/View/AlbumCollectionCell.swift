//
//  AlbumCollectionCell.swift
//  LastMusic
//
//  Created by mac on 5/22/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

class AlbumCollectionCell: UICollectionViewCell {
    @IBOutlet weak var albumImage: UIImageView!
    @IBOutlet weak var albumLabel: UILabel!
    
    static let identifier = "AlbumCollectionCell"
    
    
    func configureCollection(with album: Album) {
        
        albumLabel.text = album.name
        
        guard let img = album.image.first(where: {$0.size == "extralarge"}) else {
            
            albumImage.image = #imageLiteral(resourceName: "ph")
            return
        }
        
        let url = img.text
        
        dlManager.download(url) { [unowned self] dat in
            
            if let data = dat, let image = UIImage(data: data) {
                
                self.albumImage.image = image
            }
        }
        
    } //end func
}

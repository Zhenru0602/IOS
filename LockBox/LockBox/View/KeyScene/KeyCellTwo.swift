//
//  KeyCellTwo.swift
//  LockBox
//
//  Created by mac on 5/30/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

class KeyCellTwo: UICollectionViewCell {
    @IBOutlet weak var keyImage: UIImageView!
    
    static let identifier = "KeyCellTwo"
    
    func configure(with image: String) {
        keyImage.image = UIImage(named: image)!
    }
}

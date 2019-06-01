//
//  KeyHeaderCell.swift
//  LockBox
//
//  Created by mac on 5/30/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

class KeyHeaderCell: UICollectionViewCell {

    @IBOutlet weak var keyHeaderLabel: UILabel!
    
    static let identifier = "KeyHeaderCell"

    
    func configureAsteriks(_ label: String) {
        keyHeaderLabel.text = label
    }
}


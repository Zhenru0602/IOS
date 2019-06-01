//
//  KeyCellOne.swift
//  LockBox
//
//  Created by mac on 5/30/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

class KeyCellOne: UICollectionViewCell {
    
    @IBOutlet weak var keyNumberLabel: UILabel!
    static let identifier = "KeyCellOne"

    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = layer.frame.height / 2
        backgroundColor = .cellGray
    }
    
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? .lightGray : .cellGray
            keyNumberLabel.textColor = isHighlighted ? .white : .darkGray
        }
    }
    
    
    func configure(with number: String) {
        keyNumberLabel.text = number
    }
}

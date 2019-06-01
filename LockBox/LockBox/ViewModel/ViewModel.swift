//
//  ViewModel.swift
//  LockBox
//
//  Created by mac on 5/31/19.
//  Copyright © 2019 mac. All rights reserved.
//

import Foundation

protocol ViewModelDelegate: class {
    func update()
}

class ViewModel {
    
    
    weak var delegate: ViewModelDelegate?
    
    var content = [Content]() {
        didSet {
            delegate?.update()
        }
    }
    
    var currentContent: Content!
    
    
    func getContent() {
        if let coreContent = core.fetch() {
            content = coreContent
        }
        print("Content Count: \(content.count)")
    }
    
    
}

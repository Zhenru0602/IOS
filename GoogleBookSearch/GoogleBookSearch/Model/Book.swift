//
//  Book.swift
//  GoogleBookSearch
//
//  Created by Admin on 5/10/19.
//  Copyright © 2019 mac. All rights reserved.
//

import Foundation
import UIKit

class Book{
    var bookName: String
    var bookAuthor: String
    var bookPublisher: String
    var bookDescription: String
    var bookImageUrl: String
    
    init(bookName: String, bookAuthor: String, bookPublisher: String, bookDescription: String, bookImageUrl: String) {
        self.bookName = bookName
        self.bookAuthor = bookAuthor
        self.bookPublisher = bookPublisher
        self.bookDescription = bookDescription
        self.bookImageUrl = bookImageUrl
    }
}

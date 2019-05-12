//
//  BookmarkTableViewCell.swift
//  GoogleBookSearch
//
//  Created by Admin on 5/12/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

class BookmarkTableViewCell: UITableViewCell {
    
    @IBOutlet weak var bookNameLabel: UILabel!
    @IBOutlet weak var bookAuthorLabel: UILabel!
    @IBOutlet weak var bookPublisherLabel: UILabel!
    @IBOutlet weak var bookImageView: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        bookImageView.image = nil
    }
    
    func cellConfig(bookname: String, bookAuthor: String, bookPublisher: String, bookImageUrl: String){
        bookNameLabel.text = bookname
        bookAuthorLabel.text = bookAuthor
        bookPublisherLabel.text = bookPublisher
        bookService.downloadImage(url: bookImageUrl){ image in
            DispatchQueue.main.async {
                self.bookImageView.image = image
            }
        }
    }

}

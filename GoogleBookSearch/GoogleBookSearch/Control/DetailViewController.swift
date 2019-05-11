//
//  DetailViewController.swift
//  GoogleBookSearch
//
//  Created by Admin on 5/12/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var bookNameLabel: UILabel!
    @IBOutlet weak var bookAuthorLabel: UILabel!
    @IBOutlet weak var bookDescriptionField: UITextView!
    @IBOutlet weak var bookImageView: UIImageView!
    
    var bookName: String!
    var bookAuthor: String!
    var bookDescription: String!
    var bookImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailInit()
    }
    
    func detailInit(){
        bookNameLabel.text = bookName
        bookAuthorLabel.text = bookAuthor
        bookDescriptionField.text = bookDescription
        bookImageView.image = bookImage
    }
    
    func detailConfig(bookName: String, bookAuthor: String, bookDescription: String, bookImage: UIImage){
        self.bookName = bookName
        self.bookAuthor = bookAuthor
        self.bookDescription = bookDescription
        self.bookImage = bookImage
    }
    

}

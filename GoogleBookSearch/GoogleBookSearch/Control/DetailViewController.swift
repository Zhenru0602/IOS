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
    @IBOutlet weak var bookmarkTabItem: UITabBarItem!
    @IBOutlet weak var bookmarkTabBar: UITabBar!
    
    var bookName: String!
    var bookAuthor: String!
    var bookDescription: String!
    var bookId: String!
    var bookImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailInit()
        if bookService.isInBookmark(id: self.bookId){
            bookmarkTabBar.isHidden = true
            print("In bookmark!")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        bookDescriptionField.isEditable = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func detailInit(){
        bookNameLabel.text = bookName
        bookAuthorLabel.text = bookAuthor
        bookDescriptionField.text = bookDescription
        bookImageView.image = bookImage
    }
    
    func detailConfig(bookName: String, bookAuthor: String, bookDescription: String, bookId: String, bookImage: UIImage){
        self.bookName = bookName
        self.bookAuthor = bookAuthor
        self.bookDescription = bookDescription
        self.bookId = bookId
        self.bookImage = bookImage
    }
    

}

extension DetailViewController: UITabBarDelegate{
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if bookService.isInBookmark(id: self.bookId) == false{
            bookService.addToBookmark(id: self.bookId)
            print("add to bookmark!")
        }
    }
}

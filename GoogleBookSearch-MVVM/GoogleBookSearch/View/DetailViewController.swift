//
//  DetailViewController.swift
//  GoogleBookSearch
//
//  Created by Admin on 5/12/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var viewModel: ViewModel!
    
    @IBOutlet weak var bookNameLabel: UILabel!
    @IBOutlet weak var bookAuthorLabel: UILabel!
    @IBOutlet weak var bookDescriptionField: UITextView!
    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var bookmarkTabItem: UITabBarItem!
    @IBOutlet weak var bookmarkTabBar: UITabBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailInit()
        if viewModel.isSelectedInBookmark() {
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
        bookNameLabel.text = viewModel.selectedBook.bookName
        bookAuthorLabel.text = viewModel.selectedBook.bookAuthor
        bookDescriptionField.text = viewModel.selectedBook.bookDescription
        bookService.downloadImage(url: viewModel.selectedBook.bookImageUrl) { img in
            self.bookImageView.image = img
        }
    }
}

extension DetailViewController: UITabBarDelegate{
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if viewModel.isSelectedInBookmark() == false{
            viewModel.addToBookmark()
            print("add to bookmark!")
        }
    }
}

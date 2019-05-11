//
//  SearchViewController.swift
//  GoogleBookSearch
//
//  Created by Admin on 5/10/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import Foundation

class SearchViewController: UIViewController {
    var books = [Book](){
        didSet {
            self.bookTableView.reloadData()
        }
    }
    
    
    @IBOutlet weak var bookSearchBar: UISearchBar!
    
    @IBOutlet weak var bookTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initBooks()
    }
    
    func initBooks(){
        let book = Book(bookName: "Harry Porter", bookAuthor: "JK", bookPublisher: "I Don't Know",bookDescription: "Good book", bookImageUrl: "https://books.google.com/books/content?id=tcSMCwAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api")
        books.append(book)
    }
}

extension SearchViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell", for: indexPath) as! SearchTableViewCell
        cell.cellConfig(bookname: books[indexPath.row].bookName, bookAuthor: books[indexPath.row].bookAuthor, bookPublisher: books[indexPath.row].bookPublisher, bookImageUrl: books[indexPath.row].bookImageUrl)
        return cell
    }
    
    
}

extension SearchViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let detailVC = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        let bookName = books[indexPath.row].bookName
        let bookAuthor = books[indexPath.row].bookAuthor
        let bookDescription = books[indexPath.row].bookDescription
        let bookImageUrl = books[indexPath.row].bookImageUrl
        bookService.downloadImage(url: bookImageUrl) { img in
            let bookImage = img
            DispatchQueue.main.async {
                detailVC.detailConfig(bookName: bookName, bookAuthor: bookAuthor, bookDescription: bookDescription, bookImage: bookImage)
                self.navigationController?.pushViewController(detailVC, animated: true)
            }
        }
    }
}

extension SearchViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard var text =  searchBar.text else {
            return
        }
        text = String(text.filter { !" \n\t\r".contains($0) })
        if !text.isEmpty{
            bookService.getBooks(bookName: text) {(books) in
                self.books = books
                self.bookTableView.reloadData()
            }
            
        } else{
            print("Empty String")
        }
    }
}

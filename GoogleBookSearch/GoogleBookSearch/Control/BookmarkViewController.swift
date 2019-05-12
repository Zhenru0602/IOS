//
//  BookmarkViewController.swift
//  GoogleBookSearch
//
//  Created by Admin on 5/12/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import CoreData

class BookmarkViewController: UIViewController {

    @IBOutlet weak var bookmarkTableView: UITableView!
    
    var books = [Book](){
        didSet {
            self.bookmarkTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initBooks()
    }
    
    func initBooks(){
        self.books = [Book]()
        let ids = bookService.getBookmarkIds()
        print(ids)
        for i in ids{
            bookService.getBooks(bookName: i) {(books) in
                if books.count != 0{
                    self.books.append(books[0])
                }
            }
            usleep(2000)
        }
    }
    

}

extension BookmarkViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookmarkTableViewCell", for: indexPath) as! BookmarkTableViewCell
        cell.cellConfig(bookname: books[indexPath.row].bookName, bookAuthor: books[indexPath.row].bookAuthor, bookPublisher: books[indexPath.row].bookPublisher, bookImageUrl: books[indexPath.row].bookImageUrl)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
            case .delete:
                let id = books[indexPath.row].bookId
                books.remove(at: indexPath.row)
                bookService.removeFromBookmark(id: id)
            default:
                break
        }
    }
    
    
}

extension BookmarkViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let detailVC = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        let bookName = books[indexPath.row].bookName
        let bookAuthor = books[indexPath.row].bookAuthor
        let bookDescription = books[indexPath.row].bookDescription
        let bookId = books[indexPath.row].bookId
        let bookImageUrl = books[indexPath.row].bookImageUrl
        bookService.downloadImage(url: bookImageUrl) { img in
            let bookImage = img
            DispatchQueue.main.async {
                detailVC.detailConfig(bookName: bookName, bookAuthor: bookAuthor, bookDescription: bookDescription, bookId: bookId ,bookImage: bookImage)
                self.navigationController?.pushViewController(detailVC, animated: true)
            }
        }
    }
}

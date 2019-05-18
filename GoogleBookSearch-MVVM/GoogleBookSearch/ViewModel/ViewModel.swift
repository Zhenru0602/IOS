//
//  ViewModel.swift
//  GoogleBookSearch
//
//  Created by Admin on 5/18/19.
//  Copyright © 2019 mac. All rights reserved.
//
import UIKit
import Foundation

protocol ViewModelDelegate: class {
    func updateView()
    func updateCore()
}

class ViewModel{
    weak var delegate: ViewModelDelegate?
    
    var books = [Book](){
        didSet {
            print("view model books are updaeted!")
            delegate?.updateView()
        }
    }
    
    var selectedBook: Book!
    
    var coreBooks = [Book](){
        didSet {
            print("core books are updaeted!")
            delegate?.updateCore()
        }
    }
    
    func getBooks(text :String){
        bookService.getBooks(bookName: text) {(books) in
            self.books = books
        }
    }
    
    func isSelectedInBookmark() -> Bool{
        if bookService.isInBookmark(id: self.selectedBook.bookId){
            return true
        }
        return false
    }
    
    func addToBookmark(){
        bookService.addToBookmark(id: self.selectedBook.bookId)
    }
    
    func initCoreBooks(){
        self.coreBooks = [Book]()
        let ids = bookService.getBookmarkIds()
        for i in ids{
            bookService.getBooks(bookName: i) {(books) in
                if books.count != 0{
                    self.coreBooks.append(books[0])
                }
            }
            usleep(2000)
        }
    }
    
    func removeFromBookmark(id: String){
        bookService.removeFromBookmark(id: id)
    }
}


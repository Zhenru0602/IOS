//
//  BookService.swift
//  GoogleBookSearch
//
//  Created by Admin on 5/10/19.
//  Copyright © 2019 mac. All rights reserved.
//

import Foundation
import UIKit

typealias BookHandler = ([Book]) -> Void
typealias JsonHandler = ([[String:Any]]) -> Void
typealias ImageHandler = (UIImage) -> Void

let bookService = BookService.shareInatance

final class BookService{
    static let shareInatance = BookService()
    private init(){}
    
    let cache = NSCache<NSString, UIImage>()
    
    func getBooks(bookName: String, completion: @escaping BookHandler){
        var books = [Book]()
        let url = "https://www.googleapis.com/books/v1/volumes?q=" + bookName
        self.getJson(url: url) { (bookJson) in
            var bookName = "Unknown"
            var bookAuthor = "Unknown"
            var bookPubliser = "Unknown"
            var bookDescription = "Unknown"
            var bookImageUrl = "Unknown"
            
            for i in bookJson{
                if let infoDict = i["volumeInfo"] as? [String:Any] {
                    if let name = infoDict["title"] as? String{
                        bookName = name
                    }
                    
                    if let authorArrray = infoDict["authors"] as? [String]{
                        bookAuthor = ""
                        for j in authorArrray{
                            bookAuthor += j+"; "
                        }
                    }
                    
                    if let publisher = infoDict["publisher"] as? String{
                        bookPubliser = publisher
                    }
                    
                    if let description = infoDict["description"] as? String{
                        bookDescription = description
                    }
                    
                    if let imgDict = infoDict["imageLinks"] as?[String: String]{
                        if let imgUrl = imgDict["thumbnail"]{
                            bookImageUrl = imgUrl
                            bookImageUrl.insert("s", at: bookImageUrl.index(bookImageUrl.startIndex, offsetBy: 4))
                            print(bookImageUrl)
                        }
                    }
                    
                }
                let book = Book(bookName: bookName, bookAuthor: bookAuthor, bookPublisher: bookPubliser, bookDescription: bookDescription, bookImageUrl: bookImageUrl)
                books.append(book)
            }
            completion(books)
        }
    }
    
    func getJson(url: String, completion: @escaping JsonHandler){
        guard let url = URL(string: url) else {
            print("cannnot get url")
            completion([])
            return
        }
        
        URLSession.shared.dataTask(with: url) { (dat, _, err) in
            if let error = err {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                    let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                    let SearchVC = storyboard.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
                    SearchVC.present(alert, animated: true)
                }
                completion([])
                return
            }
            if let data = dat {
                
                do {
                    guard let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any],
                        let bookJson = jsonObject["items"] as? [[String:Any]] else {
                            print("Bad JSON formatting")
                            completion([])
                            return
                    }
                    DispatchQueue.main.async {
                        completion(bookJson)
                    }
                    
                } catch {
                    completion([])
                    print("Couldn't Serialize Object: \(error.localizedDescription)")
                }
            }
            }.resume()
    }
    
    func downloadImage(url: String, completion: @escaping ImageHandler) {
        
        
        let image = UIImage(named: "book")!
        
        if let image = cache.object(forKey: url as NSString) {
            completion(image)
            print("Received Image From Cache")
            return
        }
        
        //construct URL from string
        guard let finalURL = URL(string: url) else {
            completion(image)
            return
        }
        
        //create API Request
        URLSession.shared.dataTask(with: finalURL) { [unowned self] (dat, _, err) in
            
            if let error = err {
                print("Couldn't Retrieve Data: \(error.localizedDescription)")
                completion(image)
                return
            }
            
            if let data = dat {
                
                if let image = UIImage(data: data){
                    //set the image with url in cache
                    self.cache.setObject(image, forKey: url as NSString)
                    
                    //go to the main thread to pass the completion
                    DispatchQueue.main.async {
                        completion(image)
                    }
                } else {
                    completion(image)
                    return
                }
            }
        }.resume()
    }
}

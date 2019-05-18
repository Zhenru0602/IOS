//
//  BookService.swift
//  GoogleBookSearch
//
//  Created by Admin on 5/10/19.
//  Copyright © 2019 mac. All rights reserved.
//

import Foundation
import UIKit
import CoreData

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
            if bookJson.count == 0{
                print("empty json")
                completion([])
                return
            }
            var bookName = "Unknown"
            var bookAuthor = "Unknown"
            var bookPubliser = "Unknown"
            var bookDescription = "Unknown"
            var bookId = "Unknown"
            var bookImageUrl = "Unknown"
            
            for i in bookJson{
                if (i["id"] as? String) != nil{
                    bookId = i["id"] as! String
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
                }
                let book = Book(bookName: bookName, bookAuthor: bookAuthor, bookPublisher: bookPubliser, bookDescription: bookDescription, bookId: bookId,  bookImageUrl: bookImageUrl)
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
                    return
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
    
    func isInBookmark(id: String) -> Bool{
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{return false}
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Bookmarks")
        fetchRequest.predicate = NSPredicate(format: "id = %@", id)
        
        var results: [NSManagedObject] = []
        
        do {
            results = try managedObjectContext.fetch(fetchRequest)
        }
        catch {
            print("error executing fetch request: \(error)")
            return false
        }
        
        return results.count > 0
    }
    
    func addToBookmark(id: String){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{return}
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        let bookmarkEntity = NSEntityDescription.entity(forEntityName: "Bookmarks", in: managedObjectContext)!
        let bookmark = NSManagedObject(entity: bookmarkEntity, insertInto: managedObjectContext)
        bookmark.setValue(id, forKey: "id")
        
        do{
            try managedObjectContext.save()
        }catch{
            return
        }
        
    }
    
    func getBookmarkIds() -> [String]{
        var bookmarkIds = [String]()
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{return bookmarkIds}
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Bookmarks")
        
        do{
            let result = try managedObjectContext.fetch(fetchRequest)
            for data in result as [NSManagedObject]{
                let id = data.value(forKey: "id") as! String
                bookmarkIds.append(id)
            }
            return bookmarkIds
        } catch{
            return []
        }
    }
    
    func removeFromBookmark(id: String){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{return}
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Bookmarks")
        fetchRequest.predicate = NSPredicate(format: "id = %@", id)
        
        do{
            let test = try managedObjectContext.fetch(fetchRequest)
            if test.count >= 1{
                let objectToDelete = test[0]
                managedObjectContext.delete(objectToDelete)
                do{
                    try managedObjectContext.save()
                }  catch{
                    print("cannot save deleted object")
                    return
                }
            } else{
                print("cannot save deleted object")
                return
            }
        } catch{
            print("failed to init deleted object")
        }
    }
}

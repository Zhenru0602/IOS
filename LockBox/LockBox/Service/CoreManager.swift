//
//  CoreManager.swift
//  LockBox
//
//  Created by mac on 5/31/19.
//  Copyright © 2019 mac. All rights reserved.
//

import Foundation
import CoreData

let core = CoreManager.shared

final class CoreManager {
    
    static let shared = CoreManager()
    private init() {}
    
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "LockBox")
        
        container.loadPersistentStores(completionHandler: { (persistentStore, err) in
            if let error = err {
                fatalError()
            }
        })
        
        return container
    }()
    
    
    //MARK: Fetch
    func fetch() -> [Content]? {
        
        let fetchRequest = NSFetchRequest<Content>(entityName: Constants.Core.Content.rawValue)
        
        var content = [Content]()
        
        do {
            content = try context.fetch(fetchRequest)
            print("Fetched Core Data: \(content.count)")
            return content
        } catch {
            print("Couldn't Fetch Core: \(error.localizedDescription)")
            return nil
        }
    }
    
    
    
    //MARK: Save
    func save(path: String, isVideo: Bool, dateTime: String) {
        
        let entity = NSEntityDescription.entity(forEntityName: Constants.Core.Content.rawValue, in: context)!
        
        let content = Content(entity: entity, insertInto: context)
        
        
        content.setValue(path, forKey: Constants.Core.path.rawValue)
        content.setValue(isVideo, forKey: Constants.Core.isVideo.rawValue)
        content.setValue(dateTime, forKey: Constants.Core.dateTime.rawValue)
        
        saveContext()
        
        print("Saved to Core Data: \(dateTime)")
    }
    
    
    
    //MARK: Delete
    func delete(_ content: Content) {
        
        context.delete(content)
        print("Deleted Content from Core: \(content.dateTime!)")
        saveContext()
        
    }
    
    
    //MARK: Helpers
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                fatalError()
            }
        }
    }
    
    
    
    
    
}

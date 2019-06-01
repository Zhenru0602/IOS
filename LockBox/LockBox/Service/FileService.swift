//
//  FileManager.swift
//  LockBox
//
//  Created by mac on 5/31/19.
//  Copyright © 2019 mac. All rights reserved.
//

import Foundation



struct FileService {
    
    static let fileManager = FileManager.default
    
    //MARK: Save
    
    static func saveWithFM(_ data: Data, isVideo: Bool) {
        
        let hash = String(data.hashValue)
        let path = isVideo ? hash + ".mov" : hash
        
        guard let url = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(path) else {
            return
        }
        
        do {
            try data.write(to: url)
            print("Saved Data to Disk")
        } catch {
            print("FM Error: \(error.localizedDescription)")
        }
    }
    
    
    //MARK: Load
    
    static func loadWithFM(_ path: String) -> URL? {
        
        let documentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let userDomain = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomain, true)
        
        guard let directoryPath = paths.first else {
            return nil
        }
        
        let url = URL(fileURLWithPath: directoryPath).appendingPathComponent(path)
        
        return url
        
    }
    
    
    
}

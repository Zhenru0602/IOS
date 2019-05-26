//
//  UserSetting.swift
//  LastMusic
//
//  Created by Zhenru on 5/26/19.
//  Copyright © 2019 mac. All rights reserved.
//

import Foundation


struct UserSetting {
    
    private enum Keys: String {
        case limit = "limit"
        case name = "name"
    }
    
    
    
    //MARK: Set User Name
    static func saveName(name: String) {
        UserDefaults.standard.set(name, forKey: UserSetting.Keys.name.rawValue)
    }
    
    
    
    //MARK: Get User Name
    static func getName() -> String {
        return UserDefaults.standard.value(forKey: UserSetting.Keys.name.rawValue) as? String ?? "Unknown"
    }
    
    //MARK: Set Search Limit
    static func saveLimit(limit: Int) {
        UserDefaults.standard.set(limit, forKey: UserSetting.Keys.limit.rawValue)
    }
    
    
    
    //MARK: Get Search Limit
    static func getLimit() -> Int {
        return UserDefaults.standard.value(forKey: UserSetting.Keys.limit.rawValue) as? Int ?? 30
    }
    
    
    
}

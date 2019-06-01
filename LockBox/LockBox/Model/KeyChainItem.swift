//
//  KeyChainItem.swift
//  LockBox
//
//  Created by mac on 5/30/19.
//  Copyright © 2019 mac. All rights reserved.
//

import Foundation
import Security


struct KeyChainItem {
    
    /*
     In order to save to KeyChain you must have a keychain Item. Items are saved in CFDictionary. Items have three attributes that can be used to access them: Service Name (App Name), Account Name (Individual Name for Keychain Item), and Access Group (allows you to access items in multiple apps).
 
    */
    
    
    //MARK: Properties
    let service = Constants.Keys.LockBox.rawValue
    private(set) var account = String() //only getter is accessible from outside
    
    
    init(account: String) {
        self.account = account
    }
    
    //MARK: Save
    
    func saveKeychain(with password: String) {
        
        //keychain item
        var item = createKeychainItem()
        
        //encode the password to save to our item
        let encodedPassword = password.data(using: .utf8)
        
        //add encoded password to item
        item[kSecValueData as String] = encodedPassword as AnyObject?
        
        //add Item to keychain
        SecItemAdd(item as CFDictionary, nil)
        
        print("Saved Item to Keychain")
        
    }
    
    //MARK: Validate User
    
    var isValid: Bool {
        
        //keychain item
        var item = createKeychainItem()
        
        //set return attributes, true == unencyrpted
        item[kSecReturnAttributes as String] = kCFBooleanTrue
        
        //set return type for data, true == return with Data.type
        item[kSecReturnData as String] = kCFBooleanTrue
        
        //container, to hold our returned KeyChain Item
        var result: AnyObject?
        
        //copy method, check if the item exists
        SecItemCopyMatching(item as CFDictionary, &result)
        
        //container, retrieved password
        var retrieved: String?
        
        if let existingItem = result as? [String:AnyObject],
            let encodedPassword = existingItem[kSecValueData as String] as? Data {
            
            retrieved = String(data: encodedPassword, encoding: .utf8)
        }
        
        if retrieved != nil && retrieved == account {
            print("Validated User From Keychain")
            return true
        }
        
        return false
    }
    
    
    //MARK: Helper
    
    private func createKeychainItem() -> [String:AnyObject] {
        
        //container
        var item = [String:AnyObject]()
        
        //set our password type
        item[kSecClass as String] = kSecClassGenericPassword
        
        //set our account name
        item[kSecAttrAccount as String] = account as AnyObject?
        
        //set our service name
        item[kSecAttrService as String] = service as AnyObject?
        
        return item
    }
    
}

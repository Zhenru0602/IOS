//
//  Beer.swift
//  BeerApp
//
//  Created by mac on 5/9/19.
//  Copyright © 2019 mac. All rights reserved.
//

import Foundation

enum BeerErrors: Error {
    case missing(String)
}


class Beer {
    
    let name: String
    let id: String
    let description: String
    let imageUrl: String
    
    
    
    init?(json: [String:Any]) throws {
        
        guard let name = json["name"] as? String else {throw BeerErrors.missing("Missing Name")}
        guard let id = json["id"] as? String else {throw BeerErrors.missing("Missing ID")}
        
        var description = "No description"
        if let styeDict = json["style"] as? [String: Any]{
            description = styeDict["description"] as? String ?? "No description"
        }
        var imageUrl = "beer"
        if let imageDict = json["labels"] as? [String:String] {
            imageUrl = imageDict["large"] ?? "beer"
        }
        
        
        self.name = name
        self.id = id
        self.imageUrl = imageUrl
        self.description = description
        
    }
    
}

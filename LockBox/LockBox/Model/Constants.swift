//
//  Constants.swift
//  LockBox
//
//  Created by mac on 5/30/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit


struct Constants {
    
    
    enum Keys: String {
        case LockBox = "LockBox"
        case isUser = "isUser"
        case publicImage = "public.image"
        case publicMovie = "public.movie"
    }
    
    enum Core: String {
        case dateTime
        case isVideo
        case path
        case Content
    }
    
    static var isIpad: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
    
}

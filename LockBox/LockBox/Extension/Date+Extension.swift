//
//  Date+Extension.swift
//  LockBox
//
//  Created by mac on 5/31/19.
//  Copyright © 2019 mac. All rights reserved.
//

import Foundation


extension Date {
   
    private struct Format {
        
        static let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .medium
            return formatter
        }()
        
    }
    
    var dateTime: String {
        return Format.dateFormatter.string(from: self)
    }
    
}

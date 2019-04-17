//
//  ToDoItem.swift
//  ToDo
//
//  Created by vijay on 15/12/2018.
//  Copyright © 2018 vijay. All rights reserved.
//

import Foundation

struct ToDoItem : Equatable {
    let title: String
    let itemDescription: String?
    let timeStamp: Double?
    let location: Location?
    
    private let titleKey = "titleKey"
    private let itemDescriptionKey = "itemDescriptionKey"
    private let timeStampKey = "timeStampKey"
    private let locationKey = "locationKey"
    
    var plistDictionary: [String:Any] {
        var dict = [String:Any]()
        dict[titleKey] = title
        if let itemDesc = itemDescription {
            dict[itemDescriptionKey] = itemDesc
        }
        if let tmStamp = timeStamp {
            dict[timeStampKey] = tmStamp
        }
        if let loc = location {
            let locationDict = loc.plistDictionary
            dict[locationKey] = locationDict
        }
        return dict
    }
    
    init(title: String,
         itemDescription: String? = nil,
         timeStamp: Double? = nil,
         location: Location? = nil) {
        self.title = title
        self.itemDescription = itemDescription
        self.timeStamp = timeStamp
        self.location = location
    }
    
    init?(dict: [String:Any]) {
        guard let ttl = dict[titleKey] as? String else { return nil }
        title = ttl
        itemDescription = dict[itemDescriptionKey] as? String
        timeStamp = dict[timeStampKey] as? Double
        if let loc = dict[locationKey] as? [String:Any]  {
            location = Location(dictionary: loc)
        } else {
            location = nil
        }
    }
    
    public static func == (lhs: ToDoItem, rhs: ToDoItem) -> Bool {
        
        if lhs.location != rhs.location {
            return false
        }
        if lhs.timeStamp != rhs.timeStamp {
            return false
        }
        if lhs.itemDescription != rhs.itemDescription {
            return false
        }
        if lhs.title != rhs.title {
            return false
        }
        return true
    }

}

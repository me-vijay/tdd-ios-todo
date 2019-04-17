//
//  ItemManager.swift
//  ToDo
//
//  Created by vijay on 10/01/2019.
//  Copyright © 2019 vijay. All rights reserved.
//

import Foundation

class ItemManager: NSObject {
    var toDoCount : Int { return toDoItems.count }
    var doneCount : Int { return doneItems.count }
    private var toDoItems : [ToDoItem] = []
    private var doneItems : [ToDoItem] = []
    
    var todoPathURL: URL {
        let fileURLs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        guard let documentURL = fileURLs.first else {
            print("something went wrong. Documents URL could not be found")
            fatalError()
        }
        return documentURL.appendingPathComponent("todoItems.plist")
    }
    
    override init() {
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(save), name: .UIApplicationWillResignActive, object: nil)
     
        if  let todoDictionaries = NSArray(contentsOf: todoPathURL) {
            
            for dictionary in todoDictionaries {
                if let item = ToDoItem(dict: dictionary as! [String:Any]) {
                    toDoItems.append(item)
                }
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        save()
    }
    
    func add(_ item: ToDoItem) {
        if !toDoItems.contains(item) {
            toDoItems.append(item)
        }
    }
    
    func item(at index: Int) -> ToDoItem {
        return toDoItems[index]
    }
    
    func doneItem(at index: Int) -> ToDoItem {
        return doneItems[index]
    }
    
    func checkItem(at index:Int) -> ToDoItem {        
        let item = toDoItems.remove(at: index)
        doneItems.append(item)
        
        return item
    }

    func uncheckItem(at index:Int) -> ToDoItem {
        let item = doneItems.remove(at: index)
        toDoItems.append(item)
        
        return item
    }

    func removeAll() {
        toDoItems.removeAll()
        doneItems.removeAll()
    }
    
    @objc func save() {
        let todoItemsDictionaries = toDoItems.map({ $0.plistDictionary })
        guard todoItemsDictionaries.count > 0 else {
            try? FileManager.default.removeItem(at: todoPathURL)
            return
        }
        do {
            let plistData = try PropertyListSerialization.data(
                fromPropertyList: todoItemsDictionaries,
                format: PropertyListSerialization.PropertyListFormat.xml,
                options: PropertyListSerialization.WriteOptions(0)
            )
            try plistData.write(to: todoPathURL, options: Data.WritingOptions.atomic)
        }
        catch {
            print(error)
        }
    }
}

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
}

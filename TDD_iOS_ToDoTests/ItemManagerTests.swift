//
//  ItemManagerTests.swift
//  ToDoTests
//
//  Created by vijay on 10/01/2019.
//  Copyright © 2019 vijay. All rights reserved.
//

import XCTest
@testable import TDD_iOS_ToDo
import CoreLocation

class ItemManagerTests: XCTestCase {
    var sut : ItemManager!
    
    override func setUp() {
        super.setUp()
        sut = ItemManager()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func test_ToDoCount_InitiallyIsZero() {
        XCTAssertEqual(sut.toDoCount, 0)
    }
    
    func test_DoneCount_InitiallyIsZero() {
        XCTAssertEqual(sut.doneCount, 0)
    }
    
    func test_Add_IncreasesToDoCountByOne() {
        let oldCount = sut.toDoCount
        
        sut.add(ToDoItem(title: ""))
        
        XCTAssertEqual(sut.toDoCount, oldCount + 1, "new count of toDoItems is invalid")
    }
    
    func test_ItemAt_ReturnsAddedItem() {
        let item = ToDoItem(title: "Foo")
        sut.add(item)
        
        let returnedItem = sut.item(at:sut.toDoCount-1)
        
        XCTAssertEqual(returnedItem.title, item.title, "returned item is not same as added")
    }
    
    func test_CheckItemAt_ChangesCount() {
        sut.add(ToDoItem(title: ""))
        let oldDoneCount = sut.doneCount
        let oldToDoCount = sut.toDoCount
        
        _ = sut.checkItem(at: 0)
        
        XCTAssertEqual(sut.doneCount, oldDoneCount+1, "checked items count is invalid")
        XCTAssertEqual(sut.toDoCount, oldToDoCount-1, "todo items count is invalid")
    }
    
    func test_CheckItemAt_RemovesCorrectItemFromToDoItems() {
        //arrange
        let firstItem = ToDoItem(title: "First")
        let secondItem = ToDoItem(title: "Second")
        let oldDoneCount = sut.doneCount
        sut.add(firstItem)
        sut.add(secondItem)
        
        //act
        let checkedItem = sut.checkItem(at: 0)
        
        //assert
        XCTAssertEqual(checkedItem.title, firstItem.title, "incorrect todo item removed")
        XCTAssertEqual(sut.item(at: 0).title, secondItem.title, "incorrect next todo item")
        XCTAssertEqual(sut.doneCount, oldDoneCount+1, "checked item not added to done items")
        XCTAssertEqual(sut.doneItem(at: sut.doneCount-1).title, firstItem.title, "incorrect checked item appended to done items")
    }
    
    func test_DoneItemAt_ReturnsCheckedItem() {
        let item = ToDoItem(title: "Foo")
        sut.add(item)
        _ = sut.checkItem(at: 0)
        
        let checkedItem = sut.doneItem(at: 0)
        
        XCTAssertEqual(checkedItem.title, item.title, "")
    }
    
    func test_RemoveAll_MakesCountsZero() {
        
        let item1 = ToDoItem(title: "Foo")
        let item2 = ToDoItem(title: "Bar")
        sut.add(item1)
        sut.add(item2)
        _ = sut.checkItem(at: 0)
        
        XCTAssertEqual(sut.toDoCount, 1)
        XCTAssertEqual(sut.doneCount, 1)
        
        sut.removeAll()
        
        XCTAssertEqual(sut.toDoCount, 0)
        XCTAssertEqual(sut.doneCount, 0)
    }
    
    
    //MARK: Ensuring Uniqueness
    func test_Add_WhenSimilarItemIsAlreadyAdded_DoesNotIncreaseCount() {
        sut.add(ToDoItem(title: "Item1",
                         itemDescription: "description",
                         timeStamp: 1.0,
                         location: Location(name: "location", coordinates: CLLocationCoordinate2D(latitude: 1.0, longitude: 2.0))
        ))
        sut.add(ToDoItem(title: "Item1",
                         itemDescription: "description",
                         timeStamp: 1.0,
                         location: Location(name: "location", coordinates: CLLocationCoordinate2D(latitude: 1.0, longitude: 2.0))
        ))
        XCTAssertEqual(sut.toDoCount, 1)

    }
}

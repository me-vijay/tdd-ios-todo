//
//  ToDoItemTests.swift
//  ToDoTests
//
//  Created by vijay on 15/12/2018.
//  Copyright © 2018 vijay. All rights reserved.
//

import XCTest
import CoreLocation

@testable import TDD_iOS_ToDo

class ToDoItemTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_Init_WhenGivenTitle_SetsTitle() {
        //arrange
        let title = "Foo"
        
        //act
        let item = ToDoItem(title: title)
        
        //assert
        XCTAssertEqual(item.title, title, "should set title")
    }
    
    func test_Init_WhenGivenDescription_SetsDescription() {
        //arrange
        let description = "Bar"
        
        //act
        let item = ToDoItem(title: "Foo",
                     itemDescription: description)

        //assert
        XCTAssertEqual(item.itemDescription, description, "should set description")
    }
    
    func test_Init_setsTimeStamp() {
        //arrange
        let timeStamp = 0.0
        
        //act
        let item = ToDoItem(title: "",
                            timeStamp: timeStamp)
        
        //assert
        XCTAssertEqual(item.timeStamp, timeStamp, "should set timestamp")
    }
    
    func test_Init_setsLocation() {
        //arrange
        let location = Location(name: "Foo")
        
        //act
        let item = ToDoItem(title: "", location: location)
        
        //assert
        XCTAssertEqual(item.location, location, "should set location")
    }
  
    // MARK: Equatable tests
    func test_EqualItems_AreEqual() {
        //arrange
        let firstItem = ToDoItem(title: "Item1",
                             itemDescription: "description",
                             timeStamp: 1.0,
                             location: Location(name: "location", coordinates: CLLocationCoordinate2D(latitude: 1.0, longitude: 2.0))
        )
        
        let secondItem = ToDoItem(title: "Item1",
                              itemDescription: "description",
                              timeStamp: 1.0,
                              location: Location(name: "location", coordinates: CLLocationCoordinate2D(latitude: 1.0, longitude: 2.0))
        )
        
        //act & assert
        XCTAssertEqual(firstItem, secondItem)
    }
    
    func test_Items_WhenLocationsDiffer_AreNotEqual() {
        //arrange
        let first = ToDoItem(title: "",
                             location: Location(name: "Foo"))
        let second = ToDoItem(title: "",
                              location: Location(name: "Bar"))
        
        //act & assert
        XCTAssertNotEqual(first, second)
    }
    
    func test_Items_WhenOneLocationIsNil_AreNotEqual() {
        
        var first = ToDoItem(title: "", location: Location(name: "Foo"))
        var second = ToDoItem(title: "", location: nil)        
        XCTAssertNotEqual(first, second)
        
        first = ToDoItem(title: "", location: nil)
        second = ToDoItem(title: "", location: Location(name: "Foo"))
        XCTAssertNotEqual(first, second)
    }
    
    func test_Items_WhenTimeStampsDiffer_AreNotEqual() {
        let first = ToDoItem(title: "Foo", timeStamp: 1.0)
        let second = ToDoItem(title: "Foo", timeStamp: 2.0)
        
        XCTAssertNotEqual(first, second)
    }
    
    func test_Items_WhenItemDescriptionsDiffer_AreNotEqual() {
        let first = ToDoItem(title: "Foo", itemDescription: "first Item")
        let second = ToDoItem(title: "Foo", itemDescription: "second Item")
        
        XCTAssertNotEqual(first, second)
    }
    
    func test_Items_WhenTitlesDiffer_AreNotEqual() {
        let first = ToDoItem(title: "Foo")
        let second = ToDoItem(title: "Bar")
        
        XCTAssertNotEqual(first, second)
    }
    
    func test_Item_HasPlistDictionaryProperty() {
        let item = ToDoItem(title: "Foo")
        let dictionary = item.plistDictionary
        
        XCTAssertNotNil(dictionary)
        XCTAssertTrue(dictionary is [String:Any])
    }
    
    func test_Item_CanBeCreatedFromPlistDictionary() {
        let location = Location(name: "test location")
        let item = ToDoItem(title: "Foo", itemDescription: "Bar", timeStamp: 1.0, location:location)
        
        let dict = item.plistDictionary
        let recreatedItem = ToDoItem(dict: dict)
        XCTAssertEqual(item, recreatedItem)
    }
}

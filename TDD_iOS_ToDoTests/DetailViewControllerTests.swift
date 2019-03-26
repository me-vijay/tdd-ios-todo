//
//  DetailViewControllerTests.swift
//  TDD_iOS_ToDoTests
//
//  Created by venD-vijay on 24/03/2019.
//  Copyright © 2019 venD-vijay. All rights reserved.
//

import XCTest
import CoreLocation
@testable import TDD_iOS_ToDo

class DetailViewControllerTests: XCTestCase {
    var sut : DetailViewController!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        sut = (storyboard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController)
        sut.loadViewIfNeeded()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_HasTitleLabel() {
        XCTAssertTrue(sut.titleLabel.isDescendant(of: sut.view))
    }
    
    func test_HasDateLabel() {
        XCTAssertTrue(sut.dateLabel.isDescendant(of: sut.view))
    }

    func test_HasDescriptionLabel() {
        XCTAssertTrue(sut.descriptionLabel.isDescendant(of: sut.view))
    }
    
    func test_HasLocationLabel() {
        XCTAssertTrue(sut.locationLabel.isDescendant(of: sut.view))
    }

    func test_HasMapView() {
        XCTAssertTrue(sut.mapView.isDescendant(of: sut.view))
    }
    
    func test_SettingItemTitle_SetsTitleLabel() {
        let item = ToDoItem(title: "Foo")
        let itemManager = ItemManager()
        itemManager.add(item)
        
        sut.itemInfo = (itemManager, 0)
        
        sut.beginAppearanceTransition(true, animated: true)
        sut.endAppearanceTransition()
        
        XCTAssertEqual(sut.titleLabel.text, item.title)
    }
    
    func test_SettingItemTimeStamp_SetsDateLabel() {
        let item = ToDoItem(title: "Foo", itemDescription: nil, timeStamp: 999999999, location: nil)
        let itemManager = ItemManager()
        itemManager.add(item)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let date = Date(timeIntervalSince1970: item.timeStamp!)
        
        sut.itemInfo = (itemManager, 0)
        
        sut.beginAppearanceTransition(true, animated: true)
        sut.endAppearanceTransition()
        
        XCTAssertEqual(sut.dateLabel.text, dateFormatter.string(from: date))
    }
    
    func test_SettingItemDescription_SetsDescriptionLabel() {
        let item = ToDoItem(title: "Foo", itemDescription: "Bar", timeStamp: nil, location: nil)
        let itemManager = ItemManager()
        itemManager.add(item)
        
        sut.itemInfo = (itemManager, 0)
        
        sut.beginAppearanceTransition(true, animated: true)
        sut.endAppearanceTransition()
        
        XCTAssertEqual(sut.descriptionLabel.text, item.itemDescription)
    }

    func test_SettingItemLocationTitle_SetsLocationLabel() {
        
        let location = Location(name: "Bar")
        let item = ToDoItem(title: "Foo", itemDescription: nil, timeStamp: nil, location: location)
        let itemManager = ItemManager()
        itemManager.add(item)
        
        sut.itemInfo = (itemManager, 0)
        
        sut.beginAppearanceTransition(true, animated: true)
        sut.endAppearanceTransition()
        
        XCTAssertEqual(sut.locationLabel.text, item.location?.name)
    }
    
    func test_SettingItemLocationCoordinate_SetsLocationInMap() {
        let location = Location(name: "Bar", coordinates: CLLocationCoordinate2DMake(51.2277, 6.7735))
        
        let item = ToDoItem(title: "Foo", itemDescription: nil, timeStamp: nil, location: location)
        let itemManager = ItemManager()
        itemManager.add(item)
        
        sut.itemInfo = (itemManager, 0)
        
        sut.beginAppearanceTransition(true, animated: true)
        sut.endAppearanceTransition()
        
        XCTAssertEqual(sut.mapView.centerCoordinate.latitude, (location.coordinates?.latitude)!, accuracy: 0.001)
        XCTAssertEqual(sut.mapView.centerCoordinate.longitude, (location.coordinates?.longitude)!, accuracy: 0.001)
    }
    
    func test_CheckItem_ChecksItemInItemManager() {
        let itemManager = ItemManager()
        itemManager.add(ToDoItem(title: "Foo"))
        sut.itemInfo = (itemManager, 0)
        
        sut.checkItem()
        
        
        XCTAssertEqual(itemManager.toDoCount, 0)
        XCTAssertEqual(itemManager.doneCount, 1)
    }
}

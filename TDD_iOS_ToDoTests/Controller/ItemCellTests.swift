//
//  ItemCellTests.swift
//  TDD_iOS_ToDoTests
//
//  Created by venD-vijay on 23/03/2019.
//  Copyright © 2019 venD-vijay. All rights reserved.
//

import XCTest
@testable import TDD_iOS_ToDo

class ItemCellTests: XCTestCase {

    var tableView : UITableView!
    let datasource = FakeDataSource()
    var cell : ItemCell!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ItemListViewController") as! ItemListViewController
        
        controller.loadViewIfNeeded()
        
        tableView = controller.tableView
        tableView?.dataSource = datasource
        
        cell = (tableView?.dequeueReusableCell(withIdentifier: "ItemCell", for: IndexPath(row: 0, section: 0)) as! ItemCell)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_HasNameLabel() {
        XCTAssertTrue(cell.titleLabel.isDescendant(of: cell.contentView))
    }
    
    func test_HasLocationLabel() {
        XCTAssertTrue(cell.locationLabel.isDescendant(of: cell.contentView) )
    }
    
    func test_HasDateLabel() {
        XCTAssertTrue(cell.dateLabel.isDescendant(of: cell.contentView))
    }
    
    func test_ConfigCell_SetsTitle() {
        let item = ToDoItem(title: "Foo")
        cell.configCell(with: item)
        XCTAssertEqual(cell.titleLabel.text, item.title)
    }
    
    func test_ConfigCell_SetsDate() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let dateString = "03/21/2019"
        let date = dateFormatter.date(from: dateString)
        let timeStamp = date?.timeIntervalSince1970
        let item = ToDoItem(title: "Foo", timeStamp: timeStamp)
        
        cell.configCell(with: item)
        
        XCTAssertEqual(cell.dateLabel.text, dateString)
    }
    
    func test_ConfigCell_SetsLocation() {
        let location = Location(name: "Foo")
        let item = ToDoItem(title: "Bar", location: location)
        cell.configCell(with: item)
        XCTAssertEqual(cell.locationLabel.text, item.location?.name)
    }
    
    func test_Title_WhenItemIsChecked_StrokeThrough() {
        let location = Location(name: "Foo")
        let item = ToDoItem(title: "Bar", itemDescription: nil, timeStamp: 999999, location: location)
        
        cell.configCell(with: item, checked: true)
        
        let attributedString = NSAttributedString(string: item.title, attributes: [NSAttributedStringKey.strikethroughStyle : NSUnderlineStyle.styleSingle.rawValue])
        
        XCTAssertEqual(cell.titleLabel.attributedText, attributedString)
        XCTAssertNil(cell.locationLabel.text)
        XCTAssertNil(cell.dateLabel.text)
    }
}

extension ItemCellTests {
    class FakeDataSource: NSObject, UITableViewDataSource {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 1
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            return UITableViewCell()
        }
    }
}

//
//  ItemListViewControllerTests.swift
//  TDD_iOS_ToDoTests
//
//  Created by venD-vijay on 25/01/2019.
//  Copyright © 2019 venD-vijay. All rights reserved.
//

import XCTest
@testable import TDD_iOS_ToDo

class ItemListViewControllerTests: XCTestCase {
    var sut: ItemListViewController!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "ItemListViewController")
        sut = viewController as! ItemListViewController
    }
    
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_TableView_IsNotNilAfterViewDidLoad() {
        sut.loadViewIfNeeded()
        XCTAssertNotNil(sut.tableView, "TableView for ItemList not initialized")
    }
    
    func test_LoadingView_SetsTableViewDataSource() {
        sut.loadViewIfNeeded()
        XCTAssertTrue(sut.tableView.dataSource is ItemListDataProvider)
    }
    
    func test_LoadingView_SetsTableViewDelegate() {
        sut.loadViewIfNeeded()
        XCTAssertTrue(sut.tableView.delegate is ItemListDataProvider)
    }
    
    func test_LoadingView_SetsDatasourceEqualDelegate() {
        sut.loadViewIfNeeded()
        XCTAssertEqual(sut.tableView.dataSource as? ItemListDataProvider,
                       sut.tableView.delegate as? ItemListDataProvider)
    }
}

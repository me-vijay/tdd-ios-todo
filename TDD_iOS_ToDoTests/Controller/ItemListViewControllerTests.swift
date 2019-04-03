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
    
    func test_ItemListViewController_HasAddBarButtonWithSelfAsTarget() {
        let target = sut.navigationItem.rightBarButtonItem?.target
        
        XCTAssertEqual(target as? UIViewController, sut)
    }
    
    func performAddButtonAction() {
        guard let addButton = sut.navigationItem.rightBarButtonItem else { XCTFail(); return }
        guard let action = addButton.action else { XCTFail(); return }
        
        //we have just instantiated the view controller, but it is not shown anywhere, so can't present a new controller.
        //add the view to view hierarchy by setting the view controller as our root view
        UIApplication.shared.keyWindow?.rootViewController = sut
        
        sut.performSelector(onMainThread: action, with: addButton, waitUntilDone: true)
    }
    
    func test_AddItem_PresentsInputViewController() {
        XCTAssertNil(sut.presentedViewController)
        performAddButtonAction()
        
        XCTAssertNotNil(sut.presentedViewController)
        XCTAssertTrue(sut.presentedViewController is InputViewController)
        
        let inputViewController = sut.presentedViewController as! InputViewController
        XCTAssertNotNil(inputViewController.titleTextField)
    }
    
    //To be able to add items to the list, ItemListViewController and InputViewController need to share the same item manager.
    func testItemListVC_SharesItemManagerWithInputVC() {
        performAddButtonAction()
        guard let inputViewController = sut.presentedViewController as? InputViewController else { XCTFail(); return }
        guard let inputItemManager = inputViewController.itemManager else { XCTFail(); return }
        
        XCTAssertTrue(sut.itemManager === inputItemManager)
    }
    
    func test_ViewDidLoad_SetsItemManagerToDataProvider() {
        //load view because dataprovider is set from UI(iboutlet)
        sut.loadViewIfNeeded()
        XCTAssertTrue(sut.itemManager === sut.dataProvider.itemManager)
    }
    
    func test_ViewWillAppear_ReloadsTableView() {
        //load view to initialize datasource
        sut.loadViewIfNeeded()
        
        let mockTableView = MockTableView()
        sut.tableView = mockTableView
        
        sut.beginAppearanceTransition(true, animated: true)
        sut.endAppearanceTransition()
        
        XCTAssertTrue(mockTableView.reloadDataWasCalled)
    }
}


extension ItemListViewControllerTests {
    class MockTableView: UITableView {
        var reloadDataWasCalled = false
        
        override func reloadData() {
            reloadDataWasCalled = true
        }
    }
}

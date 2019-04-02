//
//  StoryboardTests.swift
//  TDD_iOS_ToDoTests
//
//  Created by venD-vijay on 01/04/2019.
//  Copyright © 2019 venD-vijay. All rights reserved.
//

import XCTest
@testable import TDD_iOS_ToDo

class StoryboardTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_InitialViewController_IsItemListViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let navigationController = storyboard.instantiateInitialViewController() as! UINavigationController
        let rootViewController = navigationController.viewControllers[0]
        
        XCTAssertTrue(rootViewController is ItemListViewController)
    }
}

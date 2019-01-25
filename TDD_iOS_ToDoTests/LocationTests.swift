//
//  LocationTests.swift
//  ToDoTests
//
//  Created by vijay on 16/12/2018.
//  Copyright © 2018 vijay. All rights reserved.
//

import XCTest
import CoreLocation

@testable import TDD_iOS_ToDo

class LocationTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_Init_SetsCoordinates() {
        //arrange
        let coordinates = CLLocationCoordinate2D(latitude: 1.0,
                                                 longitude: 2.0)
        //act
        let location = Location(name: "", coordinates: coordinates)
        
        //assert
        XCTAssertEqual(location.coordinates?.latitude, coordinates.latitude, "should set location latitude")
        XCTAssertEqual(location.coordinates?.longitude, coordinates.longitude, "should set location longitude")
    }
    
    func test_Init_SetsName() {
        //arrange
        let name = "Foo"
        
        //act
        let location = Location(name: name)
        
        //assert
        XCTAssertEqual(location.name, name, "should set name")
    }
    
    //MARK: Equatable Tests
    func test_EqualLocations_AreEqual() {
        let name = "Foo"
        let coordinates = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
        
        let first = Location(name: name, coordinates: coordinates)
        let second = Location(name: name, coordinates: coordinates)
        
        XCTAssertEqual(first, second)
    }
    
    func assertLocationNotEqualWith(firstName: String,
                                    firstLatLong: (Double, Double)?,
                                    secondName: String,
                                    secondLatLong: (Double, Double)?,
                                    line: UInt = #line) {
        
        var firstCoord: CLLocationCoordinate2D? = nil
        var secondCoord: CLLocationCoordinate2D? = nil
        
        if let firstLtLng = firstLatLong {
            firstCoord = CLLocationCoordinate2D(latitude: firstLtLng.0, longitude: firstLtLng.1)
        }

        if let secondLtLng = secondLatLong {
            secondCoord = CLLocationCoordinate2D(latitude: secondLtLng.0, longitude: secondLtLng.1)
        }

        let firstLocation = Location(name: firstName,
                                     coordinates: firstCoord)
        let secondLocation = Location(name: secondName,
                                      coordinates: secondCoord)
        
        XCTAssertNotEqual(firstLocation, secondLocation, line:line)
    }

    func test_Locations_WhenLatitudeDiffers_AreNotEqual() {
        assertLocationNotEqualWith(firstName: "Foo",
                                   firstLatLong: (1.0, 0.0),
                                   secondName: "Foo",
                                   secondLatLong: (2.0, 0.0))
    }
    
    func test_Locations_WhenLongitudeDiffers_AreNotEqual() {
        assertLocationNotEqualWith(firstName: "Foo",
                                   firstLatLong: (0.0, 1.0),
                                   secondName: "Foo",
                                   secondLatLong: (0.0, 2.0))
    }
    
    func test_Locations_WhenOnlyOneHasCoordinate_AreNotEqual() {
        assertLocationNotEqualWith(firstName: "Foo", firstLatLong: (0.0, 0.0), secondName: "Foo", secondLatLong: nil)
    }
    
    func test_Locations_WhenNamesDiffer_AreNotEqual() {
        assertLocationNotEqualWith(firstName: "Foo",
                                   firstLatLong: nil,
                                   secondName: "Bar",
                                   secondLatLong: nil)
    }

}

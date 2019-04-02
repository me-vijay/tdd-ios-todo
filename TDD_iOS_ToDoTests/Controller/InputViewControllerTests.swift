//
//  InputViewControllerTests.swift
//  TDD_iOS_ToDoTests
//
//  Created by venD-vijay on 25/03/2019.
//  Copyright © 2019 venD-vijay. All rights reserved.
//

import XCTest
@testable import TDD_iOS_ToDo
import CoreLocation


class InputViewControllerTests: XCTestCase {
    var sut: InputViewController!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        sut = (storyboard.instantiateViewController(withIdentifier: "InputViewController") as! InputViewController)
        sut.loadViewIfNeeded()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_HasTitleTextField() {
        XCTAssertTrue(sut.titleTextField.isDescendant(of: sut.view))
    }
    
    func test_HasDateTextField() {
        XCTAssertTrue(sut.dateTextField.isDescendant(of: sut.view))
    }
    
    func test_HaslocationTextField() {
        XCTAssertTrue(sut.locationTextField.isDescendant(of: sut.view))
    }

    func test_HasAddressTextField() {
        XCTAssertTrue(sut.addressTextField.isDescendant(of: sut.view))
    }

    func test_HasDescriptionTextField() {
        XCTAssertTrue(sut.descriptionTextField.isDescendant(of: sut.view))
    }
    
    func test_HasSaveButton() {
        XCTAssertTrue(sut.saveButton.isDescendant(of: sut.view))
    }

    func test_HasCancelButton() {
        XCTAssertTrue(sut.cancelButton.isDescendant(of: sut.view))
    }
    
    func test_Save_UsesGeoCoderToGetCoordinatesFromAddress() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let dateString = "03/21/2019"
        let date = dateFormatter.date(from: dateString)
        let timeStamp = date?.timeIntervalSince1970
        
        sut.titleTextField.text = "Foo"
        sut.dateTextField.text = dateFormatter.string(from: (date)!)
        sut.locationTextField.text = "Bar"
        sut.addressTextField.text = "Infinite Loop 1, Cupertino"
        sut.descriptionTextField.text = "Foo Bar"
        
        let mockGeocoder = MockGeocoder()
        sut.geocoder = mockGeocoder
        sut.itemManager = ItemManager()
        
        //save method will call our mock geocoder's method - setting the completion handler
        sut.save()
        
        let placemark = MockPlacemark()
        placemark.mockCoordinate = CLLocationCoordinate2DMake(37.3316851, -122.0300674)
        
        //call sut completion handler, which will create the ToDoItem with returned placemark's coordinates
        mockGeocoder.completionHandler?([placemark], nil)
        
        let testItem = ToDoItem(title: "Foo", itemDescription: "Foo Bar", timeStamp: timeStamp, location: Location(name: "Bar", coordinates: placemark.location?.coordinate))
        let item = sut.itemManager?.item(at: 0)
        
        XCTAssertEqual(item, testItem)
    }
    
    func test_Geocoder_FetchesCoordinates() {
        let address = "Infinite Loop 1, Cupertino"
        let geocoderAnswered = expectation(description: "Geocoder")
        CLGeocoder().geocodeAddressString(address) { (placemarks, error) in
          
            let coordinate = placemarks?.first?.location?.coordinate
            guard let latitude = coordinate?.latitude else {
                XCTFail()
                return
            }
            guard let longitude = coordinate?.longitude else {
                XCTFail()
                return
            }
            
            XCTAssertEqual(latitude, 37.3316, accuracy: 0.001)
            XCTAssertEqual(longitude, -122.0300, accuracy: 0.001)
            geocoderAnswered.fulfill()
        }
        
        waitForExpectations(timeout: 3, handler: nil)
    }
    
    func testSave_DismissViewController() {
        let mockInputViewController = MockInputViewController()
        mockInputViewController.titleTextField = UITextField()
        mockInputViewController.dateTextField = UITextField()
        mockInputViewController.locationTextField = UITextField()
        mockInputViewController.addressTextField = UITextField()
        mockInputViewController.descriptionTextField = UITextField()
        mockInputViewController.titleTextField.text = "Test Title"
        
        mockInputViewController.save()
        XCTAssertTrue(mockInputViewController.dismissGotCalled)
    }
}

extension InputViewControllerTests {
    class MockGeocoder: CLGeocoder {
        var completionHandler: CLGeocodeCompletionHandler?
        
        override func geocodeAddressString(_ addressString: String, completionHandler: @escaping CLGeocodeCompletionHandler) {
            self.completionHandler = completionHandler
        }
    }
    
    class MockPlacemark: CLPlacemark {
        var mockCoordinate: CLLocationCoordinate2D?
        
        override var location: CLLocation? {
            guard let coordinate = mockCoordinate else { return CLLocation() }
            return CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        }
    }
    
    class MockInputViewController: InputViewController {
        var dismissGotCalled = false
        
        override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
            dismissGotCalled = true
        }
    }
}

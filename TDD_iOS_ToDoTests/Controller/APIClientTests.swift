//
//  APIClientTests.swift
//  TDD_iOS_ToDoTests
//
//  Created by venD-vijay on 28/03/2019.
//  Copyright © 2019 venD-vijay. All rights reserved.
//

import XCTest
@testable import TDD_iOS_ToDo

class APIClientTests: XCTestCase {
    
    var sut : APIClient!
    var mockURLSession: MockURLSession!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = APIClient()
        mockURLSession = MockURLSession(data: nil, urlResponse: nil, responseError: nil)
        sut.session = mockURLSession
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_LoginUsesExpectedHost() {
        let completion = { (token: Token?, error: Error?) in }
        
        sut.loginUser(withName:"", password:"", completion: completion)
       
        XCTAssertEqual(mockURLSession.urlComponents?.host, "awesometodos.com")
    }
    
    func test_LoginUsesExpectedPath() {
        let completion = { (token: Token?, error: Error?) in }
        
        sut.loginUser(withName:"", password:"", completion: completion)
        
        XCTAssertEqual(mockURLSession.urlComponents?.path, "/login")
    }
    
    func test_LoginUsesExpectedQuery() {
        let completion = { (token: Token?, error: Error?) in }
        
        sut.loginUser(withName:"dasdÖm", password:"%&34", completion: completion)
        let queryItems = mockURLSession.urlComponents?.queryItems
        let expectedItems: [String:String] = ["username": "dasd%C3%96m", "password": "%25%2634"]
        
        for queryItem in queryItems! {
            guard let value = expectedItems[queryItem.name] else {
                XCTFail()
                return
            }
            XCTAssertEqual(queryItem.value, value.removingPercentEncoding, "\(queryItem.name) has unexpected value")
        }
//        XCTAssertEqual(queryItems[], "username=dasd%C3%96m&password=%25%2634")
    }
    
    func test_Login_WhenSuccessful_CreatesToken() {
        let jsonData = "{\"token\": \"1234567890\"}".data(using: .utf8)
        mockURLSession = MockURLSession(data: jsonData, urlResponse: nil, responseError: nil)
        sut.session = mockURLSession
        
        let tokenExpectation = expectation(description: "Token")
        var receivedToken : Token? = nil
        
        sut.loginUser(withName: "Foo", password: "Bar") { (token, _) in
            receivedToken = token
            tokenExpectation.fulfill()
        }
        waitForExpectations(timeout: 1) { (_) in
            XCTAssertEqual(receivedToken?.id, "1234567890")
        }
    }
    
    func test_Login_WhenJSONIsInvalid_ReturnsError() {
        mockURLSession = MockURLSession(data: Data(), urlResponse: nil, responseError: nil)
        sut.session = mockURLSession
        
        let errorExpectation = expectation(description: "Error")
        var receivedError : Error? = nil
        
        sut.loginUser(withName: "Foo", password: "Bar") { (token, error) in
            receivedError = error
            errorExpectation.fulfill()
        }
        waitForExpectations(timeout: 1) { (error) in
            XCTAssertNotNil(receivedError)
        }
    }
    
    func test_Login_WhenJSONIsNil_ReturnsError() {
        mockURLSession = MockURLSession(data: nil, urlResponse: nil, responseError: nil)
        sut.session = mockURLSession
        
        let errorExpectation = expectation(description: "Error")
        var receivedError: Error? = nil
        
        sut.loginUser(withName: "Foo", password: "Bar") { (token, error) in
            receivedError = error
            errorExpectation.fulfill()
        }
        waitForExpectations(timeout: 1) { (error) in
            XCTAssertNotNil(receivedError)
        }
    }
    
    func test_Login_WhenResponseHasError_ReturnsError() {
        let error = NSError(domain: "SomeError", code: 1234, userInfo: nil)
        let jsonData = "{\"token\": \"1234567890\"}".data(using: .utf8)

        mockURLSession = MockURLSession(data: jsonData, urlResponse: nil, responseError: error)
        sut.session = mockURLSession
        
        let errorExpectation = expectation(description: "Error")
        var receivedError: Error? = nil
        
        sut.loginUser(withName: "Foo", password: "Bar") { (token, error) in
            receivedError = error
            errorExpectation.fulfill()
        }
        waitForExpectations(timeout: 1) { (error) in
            XCTAssertNotNil(receivedError)
        }
    }
}

class MockURLSession: SessionProtocol {
    var url: URL?
    private let dataTask: MockTask
    
    var urlComponents: URLComponents? {
        guard let url = url else { return nil }
        return URLComponents(url: url, resolvingAgainstBaseURL: true)
    }
    
    init(data: Data?, urlResponse: URLResponse?, responseError: Error?) {
        dataTask = MockTask(data: data, urlResponse: urlResponse, responseError: responseError)
    }
    
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        self.url = url
        dataTask.completionHandler = completionHandler
        return dataTask
    }
}

class MockTask: URLSessionDataTask {
    private let data: Data?
    private let urlResponse: URLResponse?
    private let responseError: Error?
    
    typealias completionHandler = (Data?, URLResponse?, Error?) -> Void
    var completionHandler : completionHandler?
    
    init(data: Data?, urlResponse: URLResponse?, responseError: Error?) {
        self.data = data
        self.urlResponse = urlResponse
        self.responseError = responseError
    }
    
    override func resume() {
        DispatchQueue.main.async {
            
            self.completionHandler?(self.data, self.urlResponse, self.responseError)
        }
    }
    
}

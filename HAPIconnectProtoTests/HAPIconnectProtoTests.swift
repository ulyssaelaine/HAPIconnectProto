//
//  HAPIconnectProtoTests.swift
//  HAPIconnectProtoTests
//
//  Created by Elaine Reyes on 5/11/18.
//  Copyright © 2018 Anxa Europe Limited. All rights reserved.
//

@testable import HAPIconnectProto
import XCTest

class HAPIconnectProtoTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // MARK: - Login
    
    func testLoginWithEmptyEmail()
    {
        let expec = expectation(description: "login with empty email")
        let loginPresenter = LoginPresenter(delegate: TestLoginViewController(expectation: expec))
        loginPresenter.login(name: "", password: "123456789")
        wait(for: [expec], timeout: 3)
    }
}

// MARK: - Login

class TestLoginViewController : LoginPresenterDelegate
{
    var expec: XCTestExpectation
    
    init(expectation: XCTestExpectation)
    {
        self.expec = expectation
    }
    
    func showProgress(){}
    func hideProgress(){}
    func loginDidSucceed(){}
    
    func loginDidFail(message: String)
    {
        XCTAssertEqual(message, "E-mail can't be blank")
        self.expec.fulfill()
    }
}

//
//  CybridSDKTestAppUITests.swift
//  CybridSDKTestAppUITests
//
//  Created by Erick Sanchez Perez on 29/09/22.
//

import XCTest

class CybridSDKTestAppUITests: XCTestCase {
    
    let app = XCUIApplication()

    func test_init() throws {
        
        app.launch()
        
        // -- Given
        let clientID = app.textFields["clientID"]
        let clientIDText = "Test ClientID"
        
        let clientSecret = app.textFields["clientSecret"]
        let clientSecretText = "Test ClientSecret"
        
        let customerGUID = app.textFields["customerGUID"]
        let customerGUIDText = "Test customerGUID"
        
        
        // -- Login Screen
        XCTAssertTrue(app.images["login_image"].exists)
        
        XCTAssertTrue(clientID.exists)
        tapElementAndWaitForKeyboardToAppear(clientID)
        clientID.typeText(clientIDText)
        XCTAssertEqual(clientID.value as? String, clientIDText)
        
        XCTAssertTrue(clientSecret.exists)
        tapElementAndWaitForKeyboardToAppear(clientSecret)
        clientSecret.typeText(clientSecretText)
        XCTAssertEqual(clientSecret.value as? String, clientSecretText)
        
        XCTAssertTrue(customerGUID.exists)
        tapElementAndWaitForKeyboardToAppear(customerGUID)
        customerGUID.typeText(customerGUIDText)
        XCTAssertEqual(customerGUID.value as? String, customerGUIDText)
        
        XCTAssertTrue(app.buttons["login_button"].exists)
        app.buttons["login_button"].tap()
        
        // -- Accounts
        app.staticTexts["Accounts Component"].tap()
        sleep(4)
        
        let btc = app.staticTexts["Bitcoin BTC"]
        XCTAssertTrue(btc.exists)
        btc.tap()
        sleep(2)
    }
}

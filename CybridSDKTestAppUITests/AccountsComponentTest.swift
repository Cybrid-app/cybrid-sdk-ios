//
//  AccountsComponentTest.swift
//  CybridSDKTestAppUITests
//
//  Created by Erick Sanchez Perez on 05/10/22.
//

import Foundation
import XCTest

class AccountsComponentTest: XCTestCase {

    let app = XCUIApplication()
    let clientIDText = "Test ClientID"
    let clientSecretText = "Test ClientSecret"
    let customerGUIDText = "Test customerGUID"

    func test_flow() throws {

        app.launch()

        // -- Given
        let clientID = app.textFields["clientID"]
        let clientSecret = app.textFields["clientSecret"]
        let customerGUID = app.textFields["customerGUID"]
        let loginButton = app.buttons["login_button"]
        let demoMode = app.buttons["demo_mode"]

        // -- Login Screen Basics
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

        dismissKeyboardIfPresent()
        XCTAssertTrue(loginButton.exists)
        XCTAssertTrue(demoMode.exists)
        demoMode.tap()

        // -- Accounts
        let accounts = app.staticTexts["Accounts Component"]
        if accounts.waitForExistence(timeout: 5) {
            accounts.tap()
        }

        let btc = app.staticTexts["Bitcoin BTC"]
        if btc.waitForExistence(timeout: 6) {
            XCTAssertTrue(btc.exists)
        }
        btc.tap()
    }
}

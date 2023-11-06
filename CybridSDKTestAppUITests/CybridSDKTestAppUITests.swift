//
//  CybridSDKTestAppUITests.swift
//  CybridSDKTestAppUITests
//
//  Created by Erick Sanchez Perez on 29/09/22.
//

import XCTest

class CybridSDKTestAppUITests: XCTestCase {

    let app = XCUIApplication()
    let clientIDText = "Test ClientID"
    let clientSecretText = "Test ClientSecret"
    let customerGUIDText = "Test customerGUID"

    func test_login_error_all_fields_empty() throws {

        app.launch()

        // -- Given
        let clientID = app.textFields["clientID"]
        let clientSecret = app.textFields["clientSecret"]
        let customerGUID = app.textFields["customerGUID"]
        let loginButton = app.buttons["login_button"]

        // -- When
        XCTAssertFalse(app.staticTexts["login_error"].exists)
        loginButton.tap()

        // -- Then
        XCTAssertTrue(clientID.exists)
        XCTAssertTrue(clientSecret.exists)
        XCTAssertTrue(customerGUID.exists)
        XCTAssertTrue(app.staticTexts["login_error"].exists)
    }

    func test_login_error_id_empty() throws {

        app.launch()

        // -- Given
        let clientID = app.textFields["clientID"]
        let clientSecret = app.textFields["clientSecret"]
        let customerGUID = app.textFields["customerGUID"]
        let loginButton = app.buttons["login_button"]

        // -- When
        tapElementAndWaitForKeyboardToAppear(clientSecret)
        clientSecret.typeText(clientSecretText)

        tapElementAndWaitForKeyboardToAppear(customerGUID)
        customerGUID.typeText(customerGUIDText)

        XCTAssertFalse(app.staticTexts["login_error"].exists)
        loginButton.tap()

        // -- Then
        XCTAssertTrue(clientID.exists)
        XCTAssertTrue(clientSecret.exists)
        XCTAssertTrue(customerGUID.exists)
        XCTAssertEqual(clientSecret.value as? String, clientSecretText)
        XCTAssertEqual(customerGUID.value as? String, customerGUIDText)
        XCTAssertTrue(app.staticTexts["login_error"].exists)
    }

    func test_login_error_secret_empty() throws {

        app.launch()

        // -- Given
        let clientID = app.textFields["clientID"]
        let clientSecret = app.textFields["clientSecret"]
        let customerGUID = app.textFields["customerGUID"]
        let loginButton = app.buttons["login_button"]

        // -- When
        tapElementAndWaitForKeyboardToAppear(clientID)
        clientID.typeText(clientIDText)

        tapElementAndWaitForKeyboardToAppear(customerGUID)
        customerGUID.typeText(customerGUIDText)

        XCTAssertFalse(app.staticTexts["login_error"].exists)
        loginButton.tap()

        // -- Then
        XCTAssertTrue(clientID.exists)
        XCTAssertTrue(clientSecret.exists)
        XCTAssertTrue(customerGUID.exists)
        XCTAssertEqual(clientID.value as? String, clientIDText)
        XCTAssertEqual(customerGUID.value as? String, customerGUIDText)
        XCTAssertTrue(app.staticTexts["login_error"].exists)
    }

    func test_login_error_customer_empty() throws {

        app.launch()

        // -- Given
        let clientID = app.textFields["clientID"]
        let clientSecret = app.textFields["clientSecret"]
        let customerGUID = app.textFields["customerGUID"]
        let loginButton = app.buttons["login_button"]

        // -- When
        tapElementAndWaitForKeyboardToAppear(clientID)
        clientID.typeText(clientIDText)

        tapElementAndWaitForKeyboardToAppear(clientSecret)
        clientSecret.typeText(clientSecretText)

        XCTAssertFalse(app.staticTexts["login_error"].exists)
        loginButton.tap()

        // -- Then
        XCTAssertTrue(clientID.exists)
        XCTAssertTrue(clientSecret.exists)
        XCTAssertTrue(customerGUID.exists)
        XCTAssertEqual(clientID.value as? String, clientIDText)
        XCTAssertEqual(clientSecret.value as? String, clientSecretText)
        XCTAssertTrue(app.staticTexts["login_error"].exists)
    }

    func test_login_error_bad_credentials() throws {

        app.launch()

        // -- Given
        let clientID = app.textFields["clientID"]
        let clientSecret = app.textFields["clientSecret"]
        let customerGUID = app.textFields["customerGUID"]
        let loginButton = app.buttons["login_button"]

        // -- When
        tapElementAndWaitForKeyboardToAppear(clientID)
        clientID.typeText(clientIDText)

        tapElementAndWaitForKeyboardToAppear(clientSecret)
        clientSecret.typeText(clientSecretText)

        tapElementAndWaitForKeyboardToAppear(customerGUID)
        customerGUID.typeText(customerGUIDText)
        dismissKeyboardIfPresent()

        XCTAssertFalse(app.staticTexts["login_error"].exists)
        loginButton.tap()

        // -- Then
        XCTAssertTrue(clientID.exists)
        XCTAssertTrue(clientSecret.exists)
        XCTAssertTrue(customerGUID.exists)
        XCTAssertEqual(clientSecret.value as? String, clientSecretText)
        XCTAssertEqual(customerGUID.value as? String, customerGUIDText)

        if app.staticTexts["login_error"].waitForExistence(timeout: 5) {
            XCTAssertTrue(app.staticTexts["login_error"].exists)
        }
    }
}

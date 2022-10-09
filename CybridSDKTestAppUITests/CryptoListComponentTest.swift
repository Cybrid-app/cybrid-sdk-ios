//
//  CryptoListComponentTest.swift
//  CybridSDKTestAppUITests
//
//  Created by Erick Sanchez Perez on 05/10/22.
//

import Foundation
import XCTest

class CryptoListComponentTest: XCTestCase {
    
    let app = XCUIApplication()
    let clientIDText = "Test ClientID"
    let clientSecretText = "Test ClientSecret"
    let customerGUIDText = "Test customerGUID"
    
    func login() {
        
        // -- Given
        let clientID = app.textFields["clientID"]
        let clientSecret = app.textFields["clientSecret"]
        let customerGUID = app.textFields["customerGUID"]
        let loginButton = app.buttons["login_button"]
        
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
        
        XCTAssertTrue(loginButton.exists)
        loginButton.tap()
    }
    
    func test_flow() throws {
        
        app.launch()
        
        // -- Login
        login()
        
        // -- Crypto List
        app.staticTexts["Crypto List"].tap()
        
        // -- Enter in BTC
        let btc = app.staticTexts["Bitcoin BTC"]
        if btc.waitForExistence(timeout: 4) {
            XCTAssertTrue(btc.exists)
        }
        btc.tap()
    }
    
    func test_flow_buy() throws {
        
        app.launch()
        
        // -- Given
        let asset = "Bitcoin BTC"
        
        // -- Login
        login()
        
        // -- Crypto List
        app.staticTexts["Crypto List"].tap()
        
        // -- Enter in BTC
        let btc = app.staticTexts[asset]
        if btc.waitForExistence(timeout: 4) {
            XCTAssertTrue(btc.exists)
        }
        btc.tap()
        
        // -- Check UISegmentedControl
        XCTAssertTrue(app.buttons["BUY"].exists)
        XCTAssertTrue(app.buttons["SELL"].exists)
        let segmented = app.segmentedControls.element(boundBy: 0)
        XCTAssertTrue(segmented.buttons.element(boundBy: 0).isSelected)
        
        // -- Check Static Labels
        XCTAssertTrue(app.staticTexts["Currency"].exists)
        XCTAssertTrue(app.staticTexts["Amount"].exists)
        XCTAssertTrue(app.staticTexts["BTC"].exists)
        XCTAssertFalse(app.staticTexts["cryptoExchangePriceLabel"].exists)
        
        // -- Check TextFields
        let cryptoPickerTextField = app.textFields["cryptoPickerTextField"]
        XCTAssertTrue(cryptoPickerTextField.exists)
        XCTAssertEqual(cryptoPickerTextField.value as? String, asset)
        
        let amountTextField = app.textFields["amountTextField"]
        XCTAssertTrue(amountTextField.exists)
        
        // -- Check Action Buttons
        XCTAssertTrue(app.buttons["switchButton"].exists)
        XCTAssertTrue(app.buttons["Buy"].exists)
        
        // -- Enter Amount as 1
        tapElementAndWaitForKeyboardToAppear(amountTextField)
        amountTextField.typeText("100000000")
        XCTAssertEqual(amountTextField.value as? String, "1.00000000")
        
        // -- cryptoExchangePriceLabel has to be changed
        XCTAssertTrue(app.staticTexts["cryptoExchangePriceLabel"].exists)
        
        // -- Switch button click
        app.buttons["switchButton"].tap()
        XCTAssertTrue(app.staticTexts["USD"].exists)
        app.buttons["switchButton"].tap()
        XCTAssertTrue(app.staticTexts["BTC"].exists)
        
        // -- Click Buy Button
        app.buttons["Buy"].tap()
        
        // -- Check Order Quote
        checkBuyOrderQuote()
    }
    
    func test_flow_sell() throws {
        
        app.launch()
        
        // -- Given
        let asset = "Bitcoin BTC"
        
        // -- Login
        login()
        
        // -- Crypto List
        app.staticTexts["Crypto List"].tap()
        
        // -- Enter in BTC
        let btc = app.staticTexts[asset]
        if btc.waitForExistence(timeout: 4) {
            XCTAssertTrue(btc.exists)
        }
        btc.tap()
        
        // -- Check UISegmentedControl
        XCTAssertTrue(app.buttons["BUY"].exists)
        XCTAssertTrue(app.buttons["SELL"].exists)
        app.buttons["SELL"].tap()
        let segmented = app.segmentedControls.element(boundBy: 0)
        XCTAssertTrue(segmented.buttons.element(boundBy: 1).isSelected)
        
        // -- Check Static Labels
        XCTAssertTrue(app.staticTexts["Currency"].exists)
        XCTAssertTrue(app.staticTexts["Amount"].exists)
        XCTAssertTrue(app.staticTexts["BTC"].exists)
        XCTAssertFalse(app.staticTexts["cryptoExchangePriceLabel"].exists)
        
        // -- Check TextFields
        let cryptoPickerTextField = app.textFields["cryptoPickerTextField"]
        XCTAssertTrue(cryptoPickerTextField.exists)
        XCTAssertEqual(cryptoPickerTextField.value as? String, asset)
        
        let amountTextField = app.textFields["amountTextField"]
        XCTAssertTrue(amountTextField.exists)
        
        // -- Check Action Buttons
        XCTAssertTrue(app.buttons["switchButton"].exists)
        XCTAssertTrue(app.buttons["Sell"].exists)
        
        // -- Enter Amount as 1
        tapElementAndWaitForKeyboardToAppear(amountTextField)
        amountTextField.typeText("100000000")
        XCTAssertEqual(amountTextField.value as? String, "1.00000000")
        
        // -- cryptoExchangePriceLabel has to be changed
        XCTAssertTrue(app.staticTexts["cryptoExchangePriceLabel"].exists)
        
        // -- Switch button click
        app.buttons["switchButton"].tap()
        XCTAssertTrue(app.staticTexts["USD"].exists)
        app.buttons["switchButton"].tap()
        XCTAssertTrue(app.staticTexts["BTC"].exists)
        
        // -- Click Buy Button
        app.buttons["Buy"].tap()
        
        // -- Check Order Quote
        checkSellOrderQuote()
    }
    
    func checkBuyOrderQuote() {
        
        let title = app.staticTexts["Order Quote"]
        
        // -- Check Static Texts
        if title.waitForExistence(timeout: 4) {
            XCTAssertTrue(title.exists)
        }
        XCTAssertTrue(app.staticTexts["Purchase amount"].exists)
        XCTAssertTrue(app.staticTexts["Purchase quantity"].exists)
        XCTAssertTrue(app.staticTexts["1.00000000 BTC"].exists)
        XCTAssertTrue(app.staticTexts["Transaction Fee"].exists)
        
        // -- Check Buttons
        XCTAssertTrue(app.buttons["Cancel"].exists)
        XCTAssertTrue(app.buttons["Confirm"].exists)
        app.buttons["Confirm"].tap()
    }
    
    func checkSellOrderQuote() {
        
        let title = app.staticTexts["Order Quote"]
        
        // -- Check Static Texts
        if title.waitForExistence(timeout: 4) {
            XCTAssertTrue(title.exists)
        }
        XCTAssertTrue(app.staticTexts["Sell amount"].exists)
        XCTAssertTrue(app.staticTexts["Sell quantity"].exists)
        XCTAssertTrue(app.staticTexts["Transaction Fee"].exists)
        
        // -- Check Buttons
        XCTAssertTrue(app.buttons["Cancel"].exists)
        XCTAssertTrue(app.buttons["Confirm"].exists)
        app.buttons["Confirm"].tap()
        sleep(4)
    }
}

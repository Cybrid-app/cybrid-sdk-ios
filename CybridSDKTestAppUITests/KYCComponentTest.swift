//
//  KYCComponentTest.swift
//  CybridSDKTestAppUITests
//
//  Created by Erick Sanchez Perez on 08/11/22.
//

import Foundation
import XCTest

class KYCComponentTest: XCTestCase {
    
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
    }
    
    func test_flow() throws {
        
        app.launch()
        login()
        
        // -- KYC
        let kyc = app.staticTexts["KYC Component"]
        if kyc.waitForExistence(timeout: 6) {
            kyc.tap()
        }
        
        // -- Begin
        let kyc_begin = app.buttons["Begin"]
        if kyc_begin.waitForExistence(timeout: 12) {
            kyc_begin.tap()
        }
        
        // -- Begin Verifiying
        let kyc_begin_verifying = app.buttons["Begin verifying"]
        if kyc_begin_verifying.waitForExistence(timeout: 5) {
            kyc_begin_verifying.tap()
        }
        
        // -- Visa
        let kyc_visa = app.staticTexts["Visa"]
        if kyc_visa.waitForExistence(timeout: 4) {
            kyc_visa.tap()
        }
        
        // -- Allow cmera permissions
        let camera_perms = app.staticTexts["Allow"]
        if camera_perms.waitForExistence(timeout: 3) {
            camera_perms.tap()
        }
        
        let torch_button = app.buttons["torch-button"]
        if torch_button.waitForExistence(timeout: 8) {
            torch_button.tap()
        }
        
        let shutter_button = app.buttons["shutter-button"]
        if shutter_button.waitForExistence(timeout: 8) {
            shutter_button.tap()
        }
        
        let use_this_photo = app.buttons["Use this photo"]
        if use_this_photo.waitForExistence(timeout: 3) {
            use_this_photo.tap()
        }
        
        let basicTitle = app.textViews["Just the basics"]
        if basicTitle.waitForExistence(timeout: 10) {
            basicTitle.tap()
        }
        
        let continueButton = app.buttons["button_submit"]
        if continueButton.waitForExistence(timeout: 3) {
            continueButton.tap()
        }
        
        let getStarted = app.buttons["Get started"]
        if getStarted.waitForExistence(timeout: 5) {
            getStarted.tap()
        }
        
        let shutter_button_2 = app.buttons["shutter-button"]
        if shutter_button_2.waitForExistence(timeout: 8) {
            shutter_button_2.tap()
        }
        
        let shutter_button_3 = app.buttons["shutter-button"]
        if shutter_button_3.waitForExistence(timeout: 8) {
            shutter_button_3.tap()
        }
        
        let shutter_button_4 = app.buttons["shutter-button"]
        if shutter_button_4.waitForExistence(timeout: 8) {
            shutter_button_4.tap()
        }
        
        let done = app.buttons["Done"]
        if done.waitForExistence(timeout: 10) {
            done.tap()
        }
        print(app.debugDescription)
    }
}

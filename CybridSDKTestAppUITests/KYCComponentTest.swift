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
        let kycBegin = app.buttons["Begin"]
        if kycBegin.waitForExistence(timeout: 12) {
            kycBegin.tap()
        }

        // -- Begin Verifiying
        let kycBeginVerifying = app.buttons["Begin verifying"]
        if kycBeginVerifying.waitForExistence(timeout: 5) {
            kycBeginVerifying.tap()
        }

        // -- Visa
        let kycVisa = app.staticTexts["Visa"]
        if kycVisa.waitForExistence(timeout: 4) {
            kycVisa.tap()
        }

        // -- Allow cmera permissions
        let cameraPerms = app.staticTexts["Allow"]
        if cameraPerms.waitForExistence(timeout: 3) {
            cameraPerms.tap()
        }

        let torchButton = app.buttons["torch-button"]
        if torchButton.waitForExistence(timeout: 8) {
            torchButton.tap()
        }

        let shutterButton = app.buttons["shutter-button"]
        if shutterButton.waitForExistence(timeout: 8) {
            shutterButton.tap()
        }

        let useThisPhoto = app.buttons["Use this photo"]
        if useThisPhoto.waitForExistence(timeout: 3) {
            useThisPhoto.tap()
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

        let shutterButton2 = app.buttons["shutter-button"]
        if shutterButton2.waitForExistence(timeout: 8) {
            shutterButton2.tap()
        }

        let shutterButton3 = app.buttons["shutter-button"]
        if shutterButton3.waitForExistence(timeout: 8) {
            shutterButton3.tap()
        }

        let shutterButton4 = app.buttons["shutter-button"]
        if shutterButton4.waitForExistence(timeout: 8) {
            shutterButton4.tap()
        }

        let done = app.buttons["Done"]
        if done.waitForExistence(timeout: 10) {
            done.tap()
        }
        print(app.debugDescription)
    }
}

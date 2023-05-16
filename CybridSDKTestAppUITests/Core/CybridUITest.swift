//
//  CybridUITest.swift
//  CybridSDKTestAppUITests
//
//  Created by Erick Sanchez Perez on 15/05/23.
//

import Foundation
import XCTest

class CybridUITest: XCTestCase {
    
    let app = XCUIApplication()
    
    func returnTap() {
        
        app.navigationBars.buttons.element(boundBy: 0).tap()
    }
    
    func login() {
        
        // -- Given
        let demoMode = app.buttons["demo_mode"]
        demoMode.tap()
    }
}

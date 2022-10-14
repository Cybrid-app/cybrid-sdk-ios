//
//  XCTestCase+Extensions.swift
//  CybridSDKTestAppUITests
//
//  Created by Erick Sanchez Perez on 04/10/22.
//

import Foundation
import XCTest

extension XCTestCase {
    
    func tapElementAndWaitForKeyboardToAppear(_ element: XCUIElement) {
        
        let keyboard = XCUIApplication().keyboards.element
        while (true) {
            element.tap()
            if keyboard.exists {
                break;
            }
            RunLoop.current.run(until: Date(timeIntervalSinceNow: 0.5))
        }
    }
    
    func dismissKeyboardIfPresent() {
        
        let app = XCUIApplication()
        if app.keys.element(boundBy: 0).exists {
            app.typeText("\n")
        }
        
        /*let app = XCUIApplication()
        if app.keyboards.element(boundBy: 0).exists {
            if UIDevice.current.userInterfaceIdiom == .pad {
                app.keyboards.buttons["Hide keyboard"].tap()
            } else {
                app.toolbars.buttons["aceptar"].tap()
            }
        }*/
    }
}

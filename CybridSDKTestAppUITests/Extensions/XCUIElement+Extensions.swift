//
//  XCUIElement+Extensions.swift
//  CybridSDKTestAppUITests
//
//  Created by Erick Sanchez Perez on 04/10/22.
//

import Foundation
import XCTest

extension XCUIElement {

    func setText(_ text: String, _ application: XCUIApplication) {

        tap()
        UIPasteboard.general.string = text
        doubleTap()
        application.menuItems.element(boundBy: 0).tap()
    }
}

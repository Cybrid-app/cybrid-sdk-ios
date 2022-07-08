//
//  UIViewConstraintsTests.swift
//  CybridSDKTests
//
//  Created by Cybrid on 29/06/22.
//

@testable import CybridSDK
import UIKit
import XCTest

class UIViewConstraintsTests: XCTestCase {
  func testConstraint() {
    // Given
    let parentView = UIView()
    let viewA = UIView()
    let viewB = UIView()

    // When
    parentView.addSubview(viewA)
    parentView.addSubview(viewB)
    viewA.translatesAutoresizingMaskIntoConstraints = false
    viewB.translatesAutoresizingMaskIntoConstraints = false
    let expectedConstraint = viewA.constraint(attribute: .top, relatedBy: .equal, toItem: viewB, attribute: .top)

    // Then
    let actualConstraint = parentView.constraints.first { constraint in
      constraint == expectedConstraint
    }
    XCTAssertEqual(actualConstraint, expectedConstraint)
  }
}

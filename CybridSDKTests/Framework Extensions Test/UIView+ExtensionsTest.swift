//
//  UIView+ExtensionsTest.swift
//  CybridSDKTests
//
//  Created by Erick Sanchez on 27/07/23.
//

@testable import CybridSDK
import XCTest

class UIViewExtensionTests: XCTestCase {

    func test_parentViewController_ReturnsCorrectViewController() {

        // -- Given
        let viewController = UIViewController()
        let containerView = UIView()
        viewController.view.addSubview(containerView)
        containerView.addSubview(UIView())
        containerView.addSubview(UIView())
        containerView.addSubview(UIView())

        // -- When
        let foundViewController = containerView.parentViewController

        // -- Then
        XCTAssertEqual(foundViewController, viewController)
    }

    func test_parentViewController_ReturnsNilForRootView() {

        // -- Given
        let rootView = UIView()

        // -- When
        let foundViewController = rootView.parentViewController

        // -- Then
        XCTAssertNil(foundViewController)
    }

    func test_removeChilds() {

        let view = UIView()
        let subview1 = UIView()
        let subview2 = UIView()
        view.addSubview(subview1)
        view.addSubview(subview2)

        XCTAssertEqual(view.subviews.count, 2)
        view.removeChilds()
        XCTAssertEqual(view.subviews.count, 0)
    }
}

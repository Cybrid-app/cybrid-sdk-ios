//
//  URLImageViewTests.swift
//  CybridSDKTests
//
//  Created by Cybrid on 15/06/22.
//

@testable import CybridSDK
import XCTest

class URLImageViewTests: XCTestCase {
  func testInvalidURLImage() {
    let urlImage = URLImageView(urlString: "Hello World")
    XCTAssertNil(urlImage)
  }
}

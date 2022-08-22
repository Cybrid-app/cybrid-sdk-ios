//
//  UtilTest.swift
//  CybridSDKTests
//
//  Created by Erick Sanchez Perez on 22/08/22.
//

import Foundation
@testable import CybridSDK
import XCTest

class UtilTest: XCTestCase {

    func test_stringValueOfKey_withValidJSONData() throws {
      let listPricesData = getJSONData(from: "listLargestPricesResponse")
      XCTAssertNotNil(listPricesData)

      let stringValue = stringValue(forKey: "buy_price", in: listPricesData!)
      XCTAssertEqual(stringValue, "115792089237316195423570985008687907853269984665640564039457584007913129639935")
    }

    func test_stringValueOfKey_withInvalidJSONData() throws {
      let bundle = Bundle.init(for: Self.self)
      let testImage = UIImage(named: "placeholder", in: bundle, compatibleWith: nil)
      let testImageData = testImage?.jpegData(compressionQuality: 1)
      XCTAssertNotNil(testImageData)

      let stringValue = stringValue(forKey: "buy_price", in: testImageData!)
      XCTAssertNil(stringValue)
    }

    func test_stringValueOfKey_withInvalidJSON() throws {
      let invalidJSONData = "}".data(using: .utf8)
      XCTAssertNotNil(invalidJSONData)

      let stringValue = stringValue(forKey: "test", in: invalidJSONData!)
      XCTAssertNil(stringValue)
    }

    func test_stringValueOfKey_notFound() throws {
      let listPricesData = getJSONData(from: "listLargestPricesResponse")
      XCTAssertNotNil(listPricesData)

      let stringValue = stringValue(forKey: "not_found_key", in: listPricesData!)
      XCTAssertNil(stringValue)
    }

    func test_stringValueOfKey_withEmptyValue() throws {
      let json = """
      [
        {
          id: "example",
          test_key:
        }
      ]
      """
      let testData = json.data(using: .utf8)
      XCTAssertNotNil(testData)

      let stringValue = stringValue(forKey: "test_key", in: testData!)
      XCTAssertNil(stringValue)
    }
}

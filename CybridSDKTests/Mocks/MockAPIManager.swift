//
//  MockAPIManager.swift
//  CybridSDKTests
//
//  Created by Cybrid on 13/07/22.
//

import CybridApiBankSwift
@testable import CybridSDK

final class MockAPIManager: CybridAPIManager {
  static var mockHeaders: [String: String] = [:]

  static func setHeader(_ key: String, value: String) {
    mockHeaders[key] = value
  }

  static func hasHeader(_ key: String) -> Bool {
    return mockHeaders[key] != nil
  }

  static func clearHeaders() {
    mockHeaders.removeAll()
  }
}

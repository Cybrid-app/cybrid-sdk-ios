//
//  CybridAPIManager.swift
//  CybridSDK
//
//  Created by Cybrid on 13/07/22.
//

import CybridApiBankSwift

protocol CybridAPIManager {
  static func setHeader(_ key: String, value: String)
  static func hasHeader(_ key: String) -> Bool
  static func clearHeaders()
}

extension CybridApiBankSwiftAPI: CybridAPIManager {
  static func setHeader(_ key: String, value: String) {
    customHeaders[key] = value
  }

  static func hasHeader(_ key: String) -> Bool {
    return customHeaders[key] != nil
  }

  static func clearHeaders() {
    customHeaders.removeAll()
  }
}

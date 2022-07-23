//
//  CybridLocalizationKey.swift
//  CybridSDK
//
//  Created by Cybrid on 30/06/22.
//

import Foundation

protocol LocalizationKey {
  var stringValue: String { get }
}

enum CybridLocalizationKey: LocalizationKey {
  case cryptoPriceList(CryptoPriceList)

  private var prefix: String { "cybrid" }

  var stringValue: String {
    switch self {
    case .cryptoPriceList(let key):
      return "\(prefix).\(key.stringValue)"
    }
  }
}

extension CybridLocalizationKey: Equatable {
  static func == (lhs: CybridLocalizationKey, rhs: CybridLocalizationKey) -> Bool {
    lhs.stringValue == rhs.stringValue
  }
}

// MARK: CryptoPriceList Keys

extension CybridLocalizationKey {
  enum CryptoPriceList: String {
    case headerSearchPlaceholder
    case headerCurrency
    case headerPrice

    var prefix: String { "cryptoPriceList" }
    var stringValue: String { "\(prefix).\(rawValue)" }
  }
}

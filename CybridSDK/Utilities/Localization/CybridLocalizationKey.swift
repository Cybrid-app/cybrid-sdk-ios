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
  case trade(Trade)

  private var prefix: String { "cybrid" }

  var stringValue: String {
    switch self {
    case .cryptoPriceList(let key):
      return "\(prefix).\(key.stringValue)"
    case .trade(let key):
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

// MARK: Trade

extension CybridLocalizationKey {
  enum Trade {
    case buy(Buy)
    case sell(Sell)
    case confirmationModal(ConfirmationModal)
    case loadingModal(LoadingModal)
    case successModal(SuccessModal)

    var prefix: String { "trade" }
    var stringValue: String {
      switch self {
      case .buy(let key):
        return "\(prefix).\(key.stringValue)"
      case .sell(let key):
        return "\(prefix).\(key.stringValue)"
      case .confirmationModal(let key):
        return "\(prefix).\(key.stringValue)"
      case .loadingModal(let key):
        return "\(prefix).\(key.stringValue)"
      case .successModal(let key):
        return "\(prefix).\(key.stringValue)"
      }
    }

    enum Buy: String {
      case title
      case currency
      case selectCurrency
      case amount
      case cta

      var prefix: String { "buy" }
      var stringValue: String { "\(prefix).\(rawValue)" }
    }

    enum Sell: String {
      case title
      case cta

      var prefix: String { "sell" }
      var stringValue: String { "\(prefix).\(rawValue)" }
    }

    enum ConfirmationModal: String {
      case title
      case subtitle
      case purchaseAmount
      case purchaseQuantity
      case sellAmount
      case sellQuantity
      case transactionFee
      case confirm
      case cancel

      var prefix: String { "confirmationModal" }
      var stringValue: String { "\(prefix).\(rawValue)" }
    }

    enum LoadingModal: String {
      case processingMessage

      var prefix: String { "loadingModal" }
      var stringValue: String { "\(prefix).\(rawValue)" }
    }

    enum SuccessModal: String {
      case title
      case subtitle
      case transactionId
      case date
      case purchaseAmount
      case purchaseQuantity
      case sellAmount
      case sellQuantity
      case transactionFee
      case buyMore
      case sellMore

      var prefix: String { "successModal" }
      var stringValue: String { "\(prefix).\(rawValue)" }
    }
  }
}

//
//  CybridSession.swift
//  CybridSDK
//
//  Created by Cybrid on 8/07/22.
//

import CybridApiBankSwift
import Foundation

class CybridSession {
  static func setCredentials() {
    CybridApiBankSwift.customHeaders = [
      "Bearer": ""
    ]
  }
  static func getPricesList() {
    PricesAPI.listPrices(symbol: "BTC-USD") { result in
      switch result {
      case .success(let priceList):
        print(priceList)
      case .failure(let error):
        print(error)
      }
    }
  }
}

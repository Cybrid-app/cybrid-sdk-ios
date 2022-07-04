//
//  Double+Extensions.swift
//  CybridSDK
//
//  Created by Cybrid on 20/06/22.
//

import Foundation

extension Double {
  func currencyString(with currencyCode: String) -> String? {
    let currencyFormatter = NumberFormatter()
    currencyFormatter.numberStyle = .currency
    currencyFormatter.currencyCode = currencyCode
    currencyFormatter.maximumFractionDigits = 100
    let nsNumber = NSNumber(value: self)
    return currencyFormatter.string(from: nsNumber)
  }
}

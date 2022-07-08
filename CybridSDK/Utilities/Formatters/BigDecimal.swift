//
//  BigDecimal.swift
//  CybridSDK
//
//  Created by Cybrid on 8/07/22.
//

import BigInt

struct BigDecimal: Hashable {
  let value: BigInt
  let precision: Int

  /// Creates BigDecimal with Int
  ///
  /// - Parameters:
  ///   - value: BigInt number
  ///   - precision: Precision of the resulting decimal number
  /// - Returns:number parsed from BigInt to BigDecimal
  init(_ value: BigInt, precision: Int = 2) {
      self.value = value
      self.precision = precision
  }

  /// Creates BigDecimal with String Number
  ///
  /// Invalid numbers result in nil
  ///
  /// - Parameters:
  ///   - value: Stringified decimal number
  ///   - precision: Precision of the resulting decimal number
  /// - Returns:number parsed from value to BigDecimal, or nil if input is invalid number
  init?(_ value: String, precision: Int = 2) {
    guard let number = BigInt(value) else { return nil }
    self.init(number, precision: precision)
  }

  /// Creates BigDecimal with Int
  ///
  /// - Parameters:
  ///   - value: Int number
  ///   - precision: Precision of the resulting decimal number
  /// - Returns:number parsed from Int to BigDecimal
  init(_ value: Int, precision: Int = 2) {
    self.init(BigInt(value), precision: precision)
  }

  static func zero(withPrecision precision: Int) -> BigDecimal {
    return BigDecimal(0, precision: precision)
  }
}

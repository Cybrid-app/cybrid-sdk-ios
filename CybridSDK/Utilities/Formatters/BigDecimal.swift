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

  func multiply(with decimal: BigDecimal, targetPrecision: Int) -> BigDecimal {
    let resultInt = value * decimal.value
    let resultPrecision = precision + decimal.precision
    let resultDecimal = BigDecimal(resultInt, precision: resultPrecision)

    return resultDecimal.roundUp(to: targetPrecision)
  }

  func divide(by decimal: BigDecimal, targetPrecision: Int) -> BigDecimal {
    var (quotient, reminder) = value.quotientAndRemainder(dividingBy: decimal.value)

    let intString = String(abs(quotient))
    var decimalDigits: [Int] = []

    while decimalDigits.count <= targetPrecision {
      (quotient, reminder) = (reminder * 10).quotientAndRemainder(dividingBy: decimal.value)
      if let digit = Int(String(abs(quotient))) {
        decimalDigits.append(digit)
      }
    }

    var extraPrecision = 1
    // If last quotient is less than 4 it will be rounded down to 0, so we remove last decimal digit
    if quotient < 4 {
      decimalDigits.removeLast()
      extraPrecision = 0
    } else if quotient > 4 { // If last quotient is greater than 4, it will be rounded up by 1.
      extraPrecision = 1
    } else { // If last quotient is 4, we need to keep adding precision until we get a round up or down digit.
      while quotient == 4 {
        (quotient, reminder) = (reminder * 10).quotientAndRemainder(dividingBy: decimal.value)
        if let digit = Int(String(abs(quotient))) {
          decimalDigits.append(digit)
        }
        extraPrecision += 1
      }
    }

    let decimalString = decimalDigits.map { String($0) }.joined()
    let resultString = intString + decimalString

    // We create a decimal with all the extra precision needed
    guard let decimal = BigDecimal(resultString, precision: targetPrecision + extraPrecision) else { return self }

    // Finally we reduce the precision digits to the target precision
    return decimal.roundUp(to: targetPrecision)
  }

  func roundUp(to targetPrecision: Int) -> BigDecimal {
    guard precision > targetPrecision else { return self }
    let resultString = String(abs(value))
    // For small numbers we add leading zeros
    let resultStringWithLeadingZeros = String(repeating: "0", count: max(0, precision - resultString.count + 1)) + resultString

    // Array of digits
    let invertedDigits: [Int] = resultStringWithLeadingZeros.reversed().compactMap { Int(String($0)) }
    let precisionDiff = precision - targetPrecision
    guard precisionDiff < invertedDigits.count else { return self }

    // Round up with zeros
    var result: [Int] = []
    var carry: Int = 0
    for (index, digit) in invertedDigits.enumerated() {
      let evaluatedDigit = digit + carry
      if index < precisionDiff {
        if evaluatedDigit >= 5 {
          carry = 1
        } else {
          carry = 0
        }
      } else {
        carry = Int(evaluatedDigit / 10)
        result.append(evaluatedDigit % 10)
        if index == invertedDigits.count - 1 && carry > 0 {
          result.append(carry)
        }
      }
    }

    let finalNumberString = Array(result.reversed()).map { String($0) }.joined()

    guard let decimal = BigDecimal(finalNumberString, precision: targetPrecision) else { return self }

    return decimal
  }
}

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

  static func zero(withPrecision precision: Int = 2) -> BigDecimal {
    return BigDecimal(0, precision: precision)
  }
}

// MARK: - BigDecimal Operations

extension BigDecimal {
  typealias BigDecimalOperation = (BigDecimal, Int) throws -> BigDecimal

  func multiply(with decimal: BigDecimal, targetPrecision: Int) throws -> BigDecimal {
    let resultInt = value * decimal.value
    let resultPrecision = precision + decimal.precision
    let resultDecimal = BigDecimal(resultInt, precision: resultPrecision)
    try resultDecimal.performIntegrityCheck(with: resultInt)

    return resultDecimal.roundUp(to: targetPrecision)
  }

  func divide(by decimal: BigDecimal, targetPrecision: Int) throws -> BigDecimal {
    let divisor = decimal.addPrecision(max(0, String(abs(value)).count - String(abs(decimal.value)).count))
    var (quotient, reminder) = value.quotientAndRemainder(dividingBy: divisor.value)

    let intString = String(abs(quotient))
    var decimalDigits: [Int] = []

    var extraPrecision = 0
    // If quotient equals 4 we need to look for more precision.
    // We should not look for precision beyond 18, which is Ethereum's precision
    while (decimalDigits.count <= targetPrecision || quotient == 4) && extraPrecision < 18 {
      (quotient, reminder) = (reminder * 10).quotientAndRemainder(dividingBy: divisor.value)
      if let digit = Int(String(abs(quotient))) {
        decimalDigits.append(digit)
      }
      if decimalDigits.count > targetPrecision {
        extraPrecision += 1
      }
    }

    let decimalString = decimalDigits.map { String($0) }.joined()
    let resultString = intString + decimalString
    let bigInt = BigInt(stringLiteral: resultString)
    let resultDecimal = BigDecimal(bigInt, precision: targetPrecision + extraPrecision)
    try resultDecimal.performIntegrityCheck(with: bigInt)

    // We create a decimal with all the extra precision needed
    return resultDecimal.roundUp(to: targetPrecision)
  }

  func addPrecision(_ precision: Int) -> BigDecimal {
    let stringValue = String(abs(value)) + String(repeating: "0", count: precision)
    return BigDecimal(BigInt(stringLiteral: stringValue), precision: self.precision + precision)
  }

  func roundUp(to targetPrecision: Int) -> BigDecimal {
    guard precision > targetPrecision else { return self }
    let resultString = String(abs(value))
    // For small numbers we add leading zeros
    let resultStringWithLeadingZeros = String(repeating: "0", count: max(0, precision - resultString.count + 1)) + resultString

    // Array of digits
    let invertedDigits: [Int] = resultStringWithLeadingZeros.reversed().compactMap { Int(String($0)) }
    let precisionDiff = precision - targetPrecision

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

    return BigDecimal(BigInt(stringLiteral: finalNumberString), precision: targetPrecision)
  }
}

//
//  BigDecimalValidator.swift
//  CybridSDK
//
//  Created by Cybrid on 15/08/22.
//

import BigInt
import Foundation

extension BigDecimal {
  static func runOperation(_ operation: () throws -> BigDecimal, with errorHandler: @escaping (Error) -> Void) -> BigDecimal {
    do {
      return try operation()
    } catch {
      errorHandler(error)
      return BigDecimal.zero()
    }
  }

  func performIntegrityCheck(with bigInt: BigInt) throws {
    if self.value != bigInt {
      throw CybridError.dataError
    }
  }
}

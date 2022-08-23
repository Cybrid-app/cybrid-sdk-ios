//
//  BigDecimalValidator.swift
//  CybridSDK
//
//  Created by Cybrid on 15/08/22.
//

import BigInt
import Foundation

extension SBigDecimal {
  static func runOperation(_ operation: () throws -> SBigDecimal, errorEvent: CybridEvent) -> SBigDecimal {
    do {
      return try operation()
    } catch {
      Cybrid.logger?.log(errorEvent)
      return SBigDecimal.zero()
    }
  }

  func performIntegrityCheck(with bigInt: BigInt) throws {
    if self.value != bigInt {
      throw CybridError.dataError
    }
  }
}

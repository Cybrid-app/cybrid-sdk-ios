//
//  BigDecimalValidator.swift
//  CybridSDK
//
//  Created by Cybrid on 15/08/22.
//

import BigInt
import Foundation

extension OLDBigDecimal {
  static func runOperation(_ operation: () throws -> OLDBigDecimal, errorEvent: CybridEvent) -> OLDBigDecimal {
    do {
      return try operation()
    } catch {
      Cybrid.logger?.log(errorEvent)
      return OLDBigDecimal.zero()
    }
  }

  func performIntegrityCheck(with bigInt: BigInt) throws {
    if self.value != bigInt {
      throw CybridError.dataError
    }
  }
}

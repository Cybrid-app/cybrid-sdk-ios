//
//  _BigDecimal.swift
//  CybridSDK
//
//  Created by Erick Sanchez Perez on 22/03/23.
//

import Foundation
import BigInt

struct Decimal: Hashable {

    private(set) var value: BigInt

    init(_ value: BigInt) {

        self.value = value
    }

    init?(_ value: String) {

        guard let number = BigInt(value) else { return nil }
        self.init(number)
    }

    init(_ value: Int) {

        self.init(BigInt(value))
    }
}

extension Decimal {

    mutating func multiply(_ with: Decimal) {

        self.value *= with.value
    }

    mutating func divide(_ by: Decimal) {

        self.value /= by.value
    }
}

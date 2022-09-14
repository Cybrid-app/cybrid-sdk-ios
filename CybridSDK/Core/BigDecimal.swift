//
//  BigDecimal.swift
//  CybridSDK
//
//  Created by Erick Sanchez Perez on 14/09/22.
//

import Foundation
import BigNumber

struct BigDecimal: Hashable {

    internal var value: BDouble
    var scale: Int = 4

    init(_ value: Int) {

        self.value = BDouble(value)
    }

    init(_ value: Double) {

        self.value = BDouble(value)
    }

    init(_ value: String) {

        self.value = BDouble(value) ?? BDouble(0)
    }

    init(_ value: BDouble) {

        self.value = value
    }

    func plus(augend: BigDecimal) -> BigDecimal {
        return BigDecimal(self.value + augend.value)
    }

    func minus(subtrahend: BigDecimal) -> BigDecimal {
        return BigDecimal(self.value - subtrahend.value)
    }

    func times(multiplicand: BigDecimal) -> BigDecimal {
        return BigDecimal(self.value * multiplicand.value)
    }

    func div(divisor: BigDecimal) -> BigDecimal {
        return BigDecimal(self.value / divisor.value)
    }

    func pow(number: Int) -> BigDecimal {
        return BigDecimal(self.value ** number)
    }

    func pow(number: String) -> BigDecimal {
        return BigDecimal(self.value ** (BInt(number) ?? BInt(0)))
    }

    func toPlainString() -> String {
        return self.value.decimalExpansion(precisionAfterDecimalPoint: self.scale)
    }
}

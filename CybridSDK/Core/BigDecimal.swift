//
//  BigDecimal.swift
//  CybridSDK
//
//  Created by Erick Sanchez Perez on 14/09/22.
//

import Foundation
import BigNumber

struct FBigDecimal: Hashable {

    internal var value: BDouble
    var precision: Int = 2

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

    func plus(augend: FBigDecimal) -> FBigDecimal {
        return FBigDecimal(self.value + augend.value)
    }

    func minus(subtrahend: FBigDecimal) -> FBigDecimal {
        return FBigDecimal(self.value - subtrahend.value)
    }

    func times(multiplicand: FBigDecimal) -> FBigDecimal {
        return FBigDecimal(self.value * multiplicand.value)
    }

    func div(divisor: FBigDecimal) -> FBigDecimal {
        return FBigDecimal(self.value / divisor.value)
    }

    func pow(number: Int) -> FBigDecimal {
        return FBigDecimal(self.value ** number)
    }

    func pow(number: String) -> FBigDecimal {
        return FBigDecimal(self.value ** (BInt(number) ?? BInt(0)))
    }

    func toPlainString(scale: Int = 4) -> String {

        return self.value.decimalExpansion(precisionAfterDecimalPoint: scale)
    }
}

//
//  BigDecimalPipe.swift
//  CybridSDK
//
//  Created by Erick Sanchez Perez on 14/02/23.
//

import Foundation

class BigDecimalPipe {

    // rhs: 155578 Eth
    // lhs: 1 USD
    //      1.5 = 100.5
    
    // value: 1 * 100 = 100
    
    static func divide(lhs: BigDecimal, rhs: BigDecimal, precision: Int) -> String {

        let value = lhs.value * 100
        let (quotient, remainder) = value.quotientAndRemainder(dividingBy: rhs.value)
        let result = Decimal(string: String(quotient))! + Decimal(string: String(remainder))! / Decimal(string: String(rhs.value))!

        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = precision
        return formatter.string(for: result) ?? "0"
    }
}

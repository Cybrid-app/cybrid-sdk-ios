//
//  Decimal.swift
//  CybridSDK
//
//  Created by Erick Sanchez Perez on 28/03/23.
//

import BigInt

struct Decimal: Hashable {

    let originalValue: String
    let intValue: BigInt
    let decimalValue: String
    let newValue: String

    init(_ value: String) {

        self.originalValue = value
        if value.contains(".") {

            let parts = value.split(separator: ".")
            let intPart = parts[0]
            let decimalPart = parts[1]

            self.intValue = BigInt(intPart) ?? BigInt(0)

            if decimalPart.count < 2 {
                self.decimalValue = "\(String(decimalPart))0"
            } else {
                self.decimalValue = String(decimalPart)
            }
        } else {

            self.intValue = BigInt(value) ?? BigInt(0)
            self.decimalValue = String(repeating: "0", count: 2)
        }
        self.newValue = "\(self.intValue).\(self.decimalValue)"
    }
}

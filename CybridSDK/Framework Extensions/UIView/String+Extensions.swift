//
//  String+Extensions.swift
//  CybridSDK
//
//  Created by Erick Sanchez Perez on 15/09/22.
//

import Foundation

extension String {

    func currencyFormat() -> String {

        let separator = ","
        var result: String = ""
        var iterator = 1

        for character in self.stringValue.reversed() {
            if iterator < 4 {
                result = String(character) + result
                iterator += 1
            } else {
                result = String(character) + separator + result
                iterator = 2
            }
        }
        return result
    }

    func removeTrailingZeros() -> String {

        let parts = self.stringValue.split(separator: ".")
        if parts.count > 1 {

            let integer = String(parts[0])
            let decimal = String(parts[1])
            let result = integer + "."
            var charactersToRemove = 0
            for character in decimal.reversed() {
                if character == "0" {
                    charactersToRemove += 1
                } else {
                    break
                }
            }
            return result + decimal.dropLast(charactersToRemove)
        } else {
            return self.stringValue
        }
    }
}

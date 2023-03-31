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
        var intValue = self.stringValue
        var decimalValue = ""

        // Check if has dot
        if self.contains(".") {

            let parts = self.stringValue.split(separator: ".")
            intValue = String(parts[0])
            decimalValue = String(parts[1])
        }

        for character in intValue.reversed() {
            if iterator < 4 {
                result = String(character) + result
                iterator += 1
            } else {
                result = String(character) + separator + result
                iterator = 2
            }
        }

        if !decimalValue.isEmpty {
            result = "\(result).\(decimalValue)"
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
            var decimals = decimal.dropLast(charactersToRemove)
            if decimals.isEmpty { decimals = "0" }
            return result + decimals
        } else {
            return self.stringValue
        }
    }

    func removeLeadingZeros() -> String {
        return self.stringValue.replacingOccurrences(of: "^0+", with: "", options: .regularExpression)
    }

    func getParts() -> [String] {
        return self.stringValue.map { String($0) }
    }

    subscript(_ range: CountableRange<Int>) -> String {
        let start = index(startIndex, offsetBy: max(0, range.lowerBound))
        let end = index(start, offsetBy: min(self.count - range.lowerBound,
                                             range.upperBound - range.lowerBound))
        return String(self[start..<end])
    }

    subscript(_ range: CountablePartialRangeFrom<Int>) -> String {
        let start = index(startIndex, offsetBy: max(0, range.lowerBound))
        return String(self[start...])
    }
}

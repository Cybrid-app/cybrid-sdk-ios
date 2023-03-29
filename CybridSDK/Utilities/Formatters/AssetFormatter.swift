//
//  AssetFormatter.swift
//  CybridSDK
//
//  Created by Erick Sanchez Perez on 28/03/23.
//

import Foundation
import CybridApiBankSwift

struct AssetFormatter {

    /// Method to set amount in any asset in format to trade (the amount always handle in input)
    /// Example:
    /// - 10 USD --> 1000
    /// - 10.5 USD --> 1050
    /// Parameters:
    ///  - asset: AssetBankModel to take the decimals and symbol ($)
    ///  - amount: CDecimal object with preloaded amount
    static func forTrade(_ asset: AssetBankModel, amount: CDecimal) -> String {

        var decimalValue = amount.decimalValue

        // Validate that the decimal part of the CDecimal object
        // accomplish the decimals lenght, if not set neccesary decimals
        if amount.decimalValue.count < asset.decimals {
            let diff = asset.decimals - amount.decimalValue.count
            let extraZeros = String(repeating: "0", count: diff)
            decimalValue = "\(decimalValue)\(extraZeros)"
        } else if amount.decimalValue.count > asset.decimals {
            decimalValue = amount.decimalValue[0..<asset.decimals]
        }

        // Removing the dot
        let formatted = "\(amount.intValue)\(decimalValue)"
        return formatted
    }

    /// Method to set amount in base format (always come from api)
    /// Example:
    /// - 1000 --> 10.00
    /// - 1050 --> 10.50
    /// Parameters:
    ///  - asset: AssetBankModel to take the decimals and symbol ($)
    ///  - amount: CDecimal object with preloaded amount
    static func forBase(_ asset: AssetBankModel, amount: CDecimal) -> String {

        var value = amount.originalValue
        if amount.originalValue.count < asset.decimals {

            let diff = asset.decimals - amount.originalValue.count
            let extraZeros = String(repeating: "0", count: diff)
            value = "\(extraZeros)\(value)"
        }

        let valueParts = value.getParts().reversed()
        var intArray: [String] = []
        var decimalArray: [String] = []
        var counter = 1
        for part in valueParts {

            if counter > asset.decimals {
                intArray.append(part)
            } else {
                decimalArray.append(part)
            }
            counter += 1
        }

        intArray = intArray.reversed()
        decimalArray = decimalArray.reversed()
        var intString = intArray.joined()
        var decimalString = decimalArray.joined()

        if intString.isEmpty { intString = "0" }
        if decimalString.isEmpty { decimalString = "00" }

        let formatted = "\(intString).\(decimalString)"
        return formatted
    }
}

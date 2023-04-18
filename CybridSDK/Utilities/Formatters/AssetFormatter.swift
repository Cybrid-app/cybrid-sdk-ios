//
//  AssetFormatter.swift
//  CybridSDK
//
//  Created by Erick Sanchez Perez on 27/03/23.
//

import Foundation
import CybridApiBankSwift

struct AssetFormatter {

    /// Method to set amount in any asset in format to trade (the amount always handle in input)
    /// Example:
    /// - 10 USD --> 1000
    /// - 10.5 USD --> 1050
    /// - 0.064218090000000000 ETH --> 64218090000000000
    /// Parameters:
    ///  - asset: AssetBankModel to take the decimals and symbol ($)
    ///  - amount: CDecimal object with preloaded amount
    static func forInput(_ asset: AssetBankModel, amount: CDecimal) -> String {

        var intValue = String(amount.intValue)
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

        // Sanity check in intValue is zero, has to be removed
        if intValue == "0" { intValue = "" }
        /*if asset.type == .crypto {
            decimalValue = decimalValue.removeLeadingZeros()
        }*/

        // Removing the dot
        let formatted = "\(intValue)\(decimalValue)".removeLeadingZeros()
        return formatted
    }

    /// Method to set amount in base format (always come from api)
    /// Example:
    /// - 1000 --> 10.00
    /// - 1050 --> 10.50
    /// - 64218090000000000 --> 0.064218090000000000
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
        let decimalString = decimalArray.joined()

        if intString.isEmpty { intString = "0" }

        let formatted = "\(intString).\(decimalString)"
        return formatted
    }

    /// Method to format amount
    /// Only when comes form user input of `forBase`
    /// Example:
    /// - 10.00 --> $10.00 USD
    /// - 10.50 --> $10.50 USD
    /// - 1000 --> $1,000 USD
    /// - 90071992.54740991 --> ₿90,071,992.54740991
    /// Parameters:
    ///  - asset: AssetBankModel to take the decimals and symbol ($)
    ///  - amount: String of the amount to be formatted
    static func format(_ asset: AssetBankModel, amount: String) -> String {

        var amountFormatted = amount.currencyFormat()
        let code = asset.type == .fiat ? " \(asset.code)" : ""
        amountFormatted = "\(asset.symbol)\(amountFormatted)\(code)"
        return amountFormatted
    }
    
    static func 
}

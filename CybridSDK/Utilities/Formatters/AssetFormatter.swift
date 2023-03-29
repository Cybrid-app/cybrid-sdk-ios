//
//  AssetFormatter.swift
//  CybridSDK
//
//  Created by Erick Sanchez Perez on 28/03/23.
//

import CybridApiBankSwift

struct AssetFormatter {

    /// Method to set amount in any asset in format to trade
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
}

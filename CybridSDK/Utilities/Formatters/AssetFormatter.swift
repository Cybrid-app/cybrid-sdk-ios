//
//  AssetFormatter.swift
//  CybridSDK
//
//  Created by Erick Sanchez Perez on 28/03/23.
//

import CybridApiBankSwift

class AssetFormatter {

    /// Method to set amount in any asset in format to trade
    /// Example:
    /// - 10 USD --> 1000
    /// - 10.5 USD --> 1050
    /// Parameters:
    ///  - asset: AssetBankModel to take the decimals and symbol ($)
    ///  - amount: Decimal object with preloaded amount
    static func setForTrade(_ asset: AssetBankModel, amount: Decimal) {}
}

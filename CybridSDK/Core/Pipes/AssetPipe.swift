//
//  AssetPipe.swift
//  CybridSDK
//
//  Created by Erick Sanchez Perez on 14/09/22.
//

import Foundation
import BigNumber
import CybridApiBankSwift

public enum AssetPipeType: String {
    case trade = "TRADE"
    case base = "BASE"
}

struct AssetPipe {

    /*static func transform(value: BigDecimal, asset: AssetBankModel, unit: AssetPipeType) -> BigDecimal {
        return transformAny(value: value, asset: asset, unit: unit)
    }

    static func transform(value: String, asset: AssetBankModel, unit: AssetPipeType) -> BigDecimal {
        return transformAny(value: BigDecimal(value), asset: asset, unit: unit)
    }

    static func transform(value: BigDecimal, decimals: Int, unit: AssetPipeType) -> BigDecimal {
        return transformAny(value: value, decimals: decimals, unit: unit)
    }

    static func transform(value: String, decimals: Int, unit: AssetPipeType) -> BigDecimal {
        return transformAny(value: BigDecimal(value), decimals: decimals, unit: unit)
    }

    private static func transformAny(value: BigDecimal, asset: AssetBankModel, unit: AssetPipeType) -> BigDecimal {
        return transformAny(value: value, decimals: asset.decimals, unit: unit)
    }

    private static func transformAny(value: BigDecimal, decimals: Int, unit: AssetPipeType) -> BigDecimal {

        let divisor = BigDecimal(10).pow(number: decimals)
        let tradeUnit = value.div(divisor: divisor)
        let baseUnit = value.times(multiplicand: divisor)
        var returnValue = BigDecimal(0)
        switch unit {
        case .trade:
            returnValue = tradeUnit
        case .base:
            returnValue = baseUnit
        }
        return returnValue
    }

    static func transform(value: SBigDecimal, asset: AssetBankModel, unit: AssetPipeType) -> String {

        let divisor = String(pow(10, Double(asset.decimals)))
        let tradeUnit = try? value.divide(by: SBigDecimal(divisor) ?? SBigDecimal(0), targetPrecision: asset.decimals)
        let baseUnit = try? value.multiply(with: SBigDecimal(divisor) ?? SBigDecimal(0), targetPrecision: asset.decimals)
        var returnValue = ""
        switch unit {
        case .trade:
            returnValue = CybridCurrencyFormatter.formatInputNumber(tradeUnit ?? SBigDecimal(0))
        case .base:
            returnValue = CybridCurrencyFormatter.formatInputNumber(baseUnit ?? SBigDecimal(0))
        }
        return returnValue
    }
     
     */
    
    /*static func tttt(value: BigDecimal, asset: AssetBankModel, unit: AssetPipeType) -> String {

        let divisor = BigDecimal(10).pow(number: asset.decimals)
        let tradeUnit = value.div(divisor: divisor)
        print("*****")
        print(tradeUnit.toPlainString())
        print(tradeUnit.toPlainString(scale: 0))
        print("*****")
        let baseUnit = value.times(multiplicand: divisor)
        var returnValue = ""
        switch unit {
        case .trade:
            returnValue = CybridCurrencyFormatter.formatInputNumber(tradeUnit)
        case .base:
            returnValue = CybridCurrencyFormatter.formatInputNumber(baseUnit)
        }
        return returnValue
    }*/
}

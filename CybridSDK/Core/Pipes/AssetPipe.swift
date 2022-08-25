//
//  AssetPipe.swift
//  CybridSDK
//
//  Created by Erick Sanchez Perez on 22/08/22.
//

import Foundation
import BigInt
import CybridApiBankSwift
import CybridCore

public enum AssetPipeType: String {
    case trade = "TRADE"
    case base = "BASE"
}

class AssetPipe {

    static func transform(value: String, asset: AssetBankModel, unit: AssetPipeType) -> BigDecimal {
        return transformAny(value: BigDecimal(value___: value), asset: asset, unit: unit)
    }

    static func transform(value: BigDecimal, asset: AssetBankModel, unit: AssetPipeType) -> BigDecimal {
        return transformAny(value: value, asset: asset, unit: unit)
    }

    static func transform(value: SBigDecimal, decimals: Int, unit: AssetPipeType) -> BigInt {
        return transformAny(value: value.value, decimals: decimals, unit: unit)
    }

    static func transform(value: BigInt, decimals: Int, unit: AssetPipeType) -> BigInt {
        return transformAny(value: value, decimals: decimals, unit: unit)
    }

    static func transform(value: String, decimals: Int, unit: AssetPipeType) -> BigInt {
        return transformAny(value: BigInt(stringLiteral: value), decimals: decimals, unit: unit)
    }

    private static func transformAny(value: BigDecimal, asset: AssetBankModel, unit: AssetPipeType) -> BigDecimal {
   
        let divisor = BigDecimal(value: 10).pow(n_: UInt64(asset.decimals))
        let tradeUnit = value.div(divisor: divisor)
        let baseUnit = value.times(multiplicand: divisor)
        var returnValue = BigDecimal(value: 0)
        switch unit {
        case .trade:
            returnValue = tradeUnit
        case.base:
            returnValue = baseUnit
        }
        return returnValue
    }

    private static func transformAny(value: BigInt, decimals: Int, unit: AssetPipeType) -> BigInt {

        let divisor = BigInt(10).power(decimals)
        let tradeUnit = value / divisor
        let baseUnit = value * divisor
        var returnValue = BigInt(0)
        switch unit {
        case .trade:
            returnValue = tradeUnit
        case.base:
            returnValue = baseUnit
        }
        return returnValue
    }
}

//
//  AssetPipe.swift
//  CybridSDK
//
//  Created by Erick Sanchez Perez on 22/08/22.
//

import Foundation
import BigInt
import CybridApiBankSwift

public enum AssetPipeType: String {
    case trade = "TRADE"
    case base = "BASE"
}

class AssetPipe {
    
    static func transform(value: BigDecimal, asset: AssetBankModel, unit: AssetPipeType) -> BigInt {
        return transformAny(value: value.value, asset: asset, unit: unit)
    }

    static func transform(value: BigInt, asset: AssetBankModel, unit: AssetPipeType) -> BigInt {
        return transformAny(value: value, asset: asset, unit: unit)
    }

    static func transform(value: String, asset: AssetBankModel, unit: AssetPipeType) -> BigInt {
        return transformAny(value: BigInt(stringLiteral: value), asset: asset, unit: unit)
    }

    static func transform(value: BigDecimal, decimals: Int, unit: AssetPipeType) -> BigInt {
        return transformAny(value: value.value, decimals: decimals, unit: unit)
    }

    static func transform(value: BigInt, decimals: Int, unit: AssetPipeType) -> BigInt {
        return transformAny(value: value, decimals: decimals, unit: unit)
    }

    static func transform(value: String, decimals: Int, unit: AssetPipeType) -> BigInt {
        return transformAny(value: BigInt(stringLiteral: value), decimals: decimals, unit: unit)
    }

    private static func transformAny(value: BigInt, asset: AssetBankModel, unit: AssetPipeType) -> BigInt {

        let divisor = BigInt(10).power(2)
        let tradeUnit = value.magnitude / 100
        let baseUnit = value * divisor
        var returnValue = BigInt(0)
        switch unit {
        case .trade:
            print(tradeUnit)
            //returnValue = tradeUnit
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

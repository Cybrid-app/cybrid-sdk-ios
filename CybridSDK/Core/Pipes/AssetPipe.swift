//
//  AssetPipe.swift
//  CybridSDK
//
//  Created by Erick Sanchez Perez on 07/02/23.
//

import Foundation
import BigInt
import CybridApiBankSwift

class AssetPipe {

    static func transform(value: BigDecimal, asset: AssetBankModel, unit: String) -> BigDecimal {
        return transfromAny(value: value, asset: asset, unit: unit)
    }

    static func transfrom(value: String, asset: AssetBankModel, unit: String) -> BigDecimal {
        return transfromAny(value: BigDecimal(value) ?? BigDecimal(0), asset: asset, unit: unit)
    }

    private static func transfromAny(value: BigDecimal, asset: AssetBankModel, unit: String) -> BigDecimal {

        let divisor = BigInt(10).power(asset.decimals)
        let tradeUnit = try? value.divide(by: BigDecimal(divisor), targetPrecision: asset.decimals)
        let baseUnit = try? value.multiply(with: BigDecimal(divisor), targetPrecision: asset.decimals)

        switch unit {
        case "trade":
            return tradeUnit ?? BigDecimal(0)
        case "base":
            return baseUnit ?? BigDecimal(0)
        default:
            return BigDecimal(0)
        }
    }
}

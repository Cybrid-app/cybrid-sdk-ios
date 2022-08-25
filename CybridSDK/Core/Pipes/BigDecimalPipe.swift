//
//  BigDecimalPipe.swift
//  CybridSDK
//
//  Created by Erick Sanchez Perez on 22/08/22.
//

import Foundation
import CybridCore
import CybridApiBankSwift

class BigDecimalPipe {

    static func transform(value: BigDecimal, asset: AssetBankModel) -> String? {
        let divisor = BigDecimal(value: 10).pow(n_: UInt64(asset.decimals))
        let baseUnit = value.div(divisor: divisor)
        let prefix = (value == BigDecimal(value: 0)) ? "\(asset.symbol)0" : asset.symbol
        return transformAny(baseUnit: baseUnit, asset: asset, prefix: prefix)
    }

    static func transform(value: String, asset: AssetBankModel) -> String? {
        let divisor = BigDecimal(value: 10).pow(n_: UInt64(asset.decimals))
        let baseUnit = BigDecimal(value___: value).div(divisor: divisor)
        let prefix = (value == "0") ? "\(asset.symbol)0" : asset.symbol
        return transformAny(baseUnit: baseUnit, asset: asset, prefix: prefix)
    }

    static func transformAny(baseUnit: BigDecimal, asset: AssetBankModel, prefix: String) -> String? {

        let baseUnitString = baseUnit.toPlainString()
        if baseUnitString.contains(".") {
            let baseParts = baseUnitString.split(separator: ".")
            let integer = BigDecimal(value___: String(baseParts[0]))
            var decimal = String(baseParts[1])
            print("DECIMAL :: " + decimal)
            if decimal.count < 2 {
                decimal += "0"
            }
            print("DECIMAL 2 :: " + decimal)

            let formater = NumberFormatter()
            formater.numberStyle = .decimal
            formater.minimumFractionDigits = 0
            formater.decimalSeparator = "."
            formater.groupingSeparator = ","
            let valueFormatted = integer.format(numberFormat: formater)
            return valueFormatted ?? "" + "." + decimal
        } else {

            let formater = NumberFormatter()
            formater.minimumFractionDigits = 2
            formater.minimumIntegerDigits = 0
            formater.numberStyle = .decimal
            formater.decimalSeparator = "."
            formater.groupingSeparator = ","
            return baseUnit.format(numberFormat: formater)
        }
    }
}

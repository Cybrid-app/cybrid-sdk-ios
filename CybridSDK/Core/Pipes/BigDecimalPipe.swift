//
//  BigDecimalPipe.swift
//  CybridSDK
//
//  Created by Erick Sanchez Perez on 14/09/22.
//

import Foundation
import BigNumber
import CybridApiBankSwift

struct BigDecimalPipe {

    static func transform(value: BigDecimal, asset: AssetBankModel) -> String? {

        let divisor = BigDecimal(10).pow(number: asset.decimals)
        let baseUnit = value.div(divisor: divisor)
        let prefix = (value == BigDecimal(0)) ? "\(asset.symbol)0" : asset.symbol
        return transformAny(baseUnit: baseUnit, asset: asset, prefix: prefix)
    }

    static func transform(value: String, asset: AssetBankModel) -> String? {

        let divisor = BigDecimal(10).pow(number: asset.decimals)
        let baseUnit = BigDecimal(value).div(divisor: divisor)
        let prefix = (value == "0") ? "\(asset.symbol)0" : asset.symbol
        return transformAny(baseUnit: baseUnit, asset: asset, prefix: prefix)
    }

    private static func transformAny(baseUnit: BigDecimal, asset: AssetBankModel, prefix: String) -> String {

        baseUnit.value.rounded()
        let baseUnitString = baseUnit.toPlainString(scale: asset.decimals)
        if baseUnitString.contains(".") {

            let baseParts = baseUnitString.split(separator: ".")
            let integer = String(baseParts[0])
            var decimal = String(baseParts[1]).removeTrailingZeros()
            if decimal.count < 2 {
                decimal += "0"
            }

            let valueFormatted = integer.currencyFormat()
            return valueFormatted + "." + decimal

        } else {

            let formater = NumberFormatter()
            formater.minimumFractionDigits = 2
            formater.minimumIntegerDigits = 0
            formater.numberStyle = .decimal
            formater.decimalSeparator = "."
            formater.groupingSeparator = ","
            let number = NSNumber(pointer: baseUnit.value.rawData().numerator)
            return baseUnit.toPlainString(scale: asset.decimals)
            //return formater.string(from: number) ?? ""
        }
    }
}

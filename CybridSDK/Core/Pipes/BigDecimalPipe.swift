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

        let baseUnitString = baseUnit.toPlainString(scale: asset.decimals)
        if baseUnitString.contains(".") {

            let baseParts = baseUnitString.split(separator: ".")
            let integer = BigDecimal(String(baseParts[0]))
            var decimal = String(baseParts[1])
            if decimal.count < 2 {
                decimal += "0"
            }

            let formater = NumberFormatter()
            formater.numberStyle = .decimal
            formater.minimumFractionDigits = 0
            formater.decimalSeparator = "."
            formater.groupingSeparator = ","

            let number = NSNumber(pointer: integer.value.rawData().numerator)
            let valueFormatted = formater.string(from: number)
            return valueFormatted ?? "" + "." + decimal
        } else {

            let formater = NumberFormatter()
            formater.minimumFractionDigits = 2
            formater.minimumIntegerDigits = 0
            formater.numberStyle = .decimal
            formater.decimalSeparator = "."
            formater.groupingSeparator = ","
            let number = NSNumber(pointer: baseUnit.value.rawData().numerator)
            return formater.string(from: number) ?? ""
        }
    }
}

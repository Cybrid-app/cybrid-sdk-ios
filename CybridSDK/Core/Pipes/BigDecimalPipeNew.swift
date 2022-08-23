//
//  BigDecimalPipeNew.swift
//  CybridSDK
//
//  Created by Erick Sanchez Perez on 22/08/22.
//

import Foundation
import BigInt
import CybridApiBankSwift

class BigDecimalPipeNew {
    
    /*static func transform(value: BigInt, asset: AssetBankModel) -> String? {
        let divisor = BigInt(10).power(asset.decimals)
        let baseUnit = value / divisor
        let prefix = (value == BigInt(0)) ? "\(asset.symbol)0" : asset.symbol
        return transformAny(baseUnit: baseUnit, asset: asset, prefix: prefix)
    }
    
    static func transformAny(baseUnit: BigInt, asset: AssetBankModel, prefix: String) -> String? {
                
        let baseUnitString = String(baseUnit)
        if baseUnitString.contains(".") {
            let baseParts = baseUnitString.split(separator: ".")
            let integer = BigInt(String(baseParts[0]))
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
            //formater.currencyCode = "M"
            integer.
            let valueFormatted = integer.format(numberFormat: formater)
            return valueFormatted ?? "" + "." + decimal
        } else {

            let formater = NumberFormatter()
            formater.minimumFractionDigits = 2
            formater.minimumIntegerDigits = 0
            formater.numberStyle = .decimal
            formater.decimalSeparator = "."
            formater.groupingSeparator = ","
            //formater.currencyCode = "M"
            return baseUnit.format(numberFormat: formater)
        }
    }*/
}

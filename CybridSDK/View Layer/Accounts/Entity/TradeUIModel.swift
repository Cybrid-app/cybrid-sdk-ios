//
//  TradeUIModel.swift
//  CybridSDK
//
//  Created by Erick Sanchez Perez on 25/08/22.
//

import Foundation
import CybridApiBankSwift
import CybridCore

struct TradeUIModel {

    let tradeBankModel: TradeBankModel
    let feeValue: SBigDecimal
    let feeFormatted: String
    let asset: AssetBankModel
    let counterAsset: AssetBankModel

    init?(tradeBankModel: TradeBankModel, asset: AssetBankModel, counterAsset: AssetBankModel) {

        let emptyValue = SBigDecimal(0)
        let fee = SBigDecimal(tradeBankModel.fee ?? "0", precision: counterAsset.decimals)
        let feeString = CybridCurrencyFormatter.formatPrice(fee ?? emptyValue, with: counterAsset.symbol)

        self.tradeBankModel = tradeBankModel
        self.asset = asset
        self.counterAsset = counterAsset
        self.feeValue = fee ?? emptyValue
        self.feeFormatted = feeString
    }

    func getTradeAmount() -> String {

        var returnValue = ""
        if self.tradeBankModel.side == .sell {
            let deliverAmount = BigDecimal(value___: self.tradeBankModel.deliverAmount ?? "0")
            returnValue = AssetPipe.transform(value: deliverAmount, asset: self.asset, unit: .trade).toPlainString()
        } else {
            let receiveAmount = BigDecimal(value___: self.tradeBankModel.receiveAmount ?? "0")
            returnValue = AssetPipe.transform(value: receiveAmount, asset: self.asset, unit: .trade).toPlainString()
        }
        return returnValue
    }

    func getTradeFiarAmount() -> String {

        var returnValue = ""
        if self.tradeBankModel.side == .sell {
            let receiveAmount = SBigDecimal(self.tradeBankModel.receiveAmount ?? "0", precision: counterAsset.decimals) ?? SBigDecimal(0)
            returnValue = CybridCurrencyFormatter.formatPrice(receiveAmount, with: self.counterAsset.symbol)
        } else {
            let deliverAmount = SBigDecimal(self.tradeBankModel.deliverAmount ?? "0", precision: counterAsset.decimals) ?? SBigDecimal(0)
            returnValue = CybridCurrencyFormatter.formatPrice(deliverAmount, with: self.counterAsset.symbol)
        }
        return returnValue
    }
}

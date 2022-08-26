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
    let receiveAmountValue: SBigDecimal
    let receiveAmountBDValue: BigDecimal
    let deliverAmountValue: SBigDecimal
    let deliverAmountBDValue: BigDecimal
    let feeValue: SBigDecimal
    let feeFormatted: String
    let asset: AssetBankModel
    let counterAsset: AssetBankModel

    init?(tradeBankModel: TradeBankModel, asset: AssetBankModel, counterAsset: AssetBankModel) {

        let emptyValue = SBigDecimal(0)
        let receiveAmount = SBigDecimal(tradeBankModel.receiveAmount ?? "0", precision: asset.decimals)
        let receiveAmountBD = BigDecimal(value___: tradeBankModel.receiveAmount ?? "0")
        let deliverAmount = SBigDecimal(tradeBankModel.deliverAmount ?? "0", precision: asset.decimals)
        let deliverAmountBD = BigDecimal(value___: tradeBankModel.deliverAmount ?? "0")
        let fee = SBigDecimal(tradeBankModel.fee ?? "0", precision: counterAsset.decimals)
        let feeString = CybridCurrencyFormatter.formatPrice(fee ?? emptyValue, with: counterAsset.symbol)

        self.tradeBankModel = tradeBankModel
        self.asset = asset
        self.counterAsset = counterAsset
        self.receiveAmountValue = receiveAmount ?? emptyValue
        self.receiveAmountBDValue = receiveAmountBD
        self.deliverAmountValue = deliverAmount ?? emptyValue
        self.deliverAmountBDValue = deliverAmountBD
        self.feeValue = fee ?? emptyValue
        self.feeFormatted = feeString
    }

    func getTradeAmount() -> String {

        var returnValue = ""
        if self.tradeBankModel.side == .sell {
            returnValue = AssetPipe.transform(value: self.deliverAmountBDValue, asset: self.asset, unit: .trade).toPlainString()
        } else {
            returnValue = AssetPipe.transform(value: self.receiveAmountBDValue, asset: self.asset, unit: .trade).toPlainString()
        }
        return returnValue
    }

    func getTradeFiarAmount() -> String {

        var returnValue = ""
        if self.tradeBankModel.side == .sell {
            returnValue = CybridCurrencyFormatter.formatPrice(self.receiveAmountValue, with: counterAsset.symbol)
        } else {
            returnValue = CybridCurrencyFormatter.formatPrice(self.deliverAmountValue, with: counterAsset.symbol)
        }
        return returnValue
    }
}

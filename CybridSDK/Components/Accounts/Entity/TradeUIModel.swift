//
//  TradeUIModel.swift
//  CybridSDK
//
//  Created by Erick Sanchez Perez on 25/08/22.
//

import Foundation
import CybridApiBankSwift

struct TradeUIModel: Equatable {

    let tradeBankModel: TradeBankModel
    let feeValue: BigDecimal
    let feeFormatted: String
    let asset: AssetBankModel
    let counterAsset: AssetBankModel
    let accoountGuid: String

    init?(tradeBankModel: TradeBankModel, asset: AssetBankModel, counterAsset: AssetBankModel, accountGuid: String) {

        let emptyValue = BigDecimal(0)
        let fee = BigDecimal(tradeBankModel.fee ?? "0", precision: counterAsset.decimals)
        let feeString = CybridCurrencyFormatter.formatPrice(fee ?? emptyValue, with: counterAsset.symbol)

        self.tradeBankModel = tradeBankModel
        self.asset = asset
        self.counterAsset = counterAsset
        self.feeValue = fee ?? emptyValue
        self.feeFormatted = feeString
        self.accoountGuid = accountGuid
    }

    func getTradeAmount() -> String {

        var returnValue = ""
        if self.tradeBankModel.side == "sell" {
            let deliverAmount = BigDecimal(self.tradeBankModel.deliverAmount ?? "0", precision: asset.decimals)
            returnValue = CybridCurrencyFormatter.formatInputNumber(deliverAmount ?? BigDecimal(0)).removeTrailingZeros()
        } else {

            let receiveAmount = BigDecimal(self.tradeBankModel.receiveAmount ?? "0", precision: asset.decimals)
            returnValue = CybridCurrencyFormatter.formatInputNumber(receiveAmount ?? BigDecimal(0)).removeTrailingZeros()
        }
        return returnValue
    }

    func getTradeFiatAmount() -> String {

        var returnValue = ""
        if self.tradeBankModel.side == "sell" {
            let receiveAmount = BigDecimal(self.tradeBankModel.receiveAmount ?? "0", precision: counterAsset.decimals) ?? BigDecimal(0)
            returnValue = CybridCurrencyFormatter.formatPrice(receiveAmount, with: self.counterAsset.symbol)
        } else {

            let deliverAmount = BigDecimal(self.tradeBankModel.deliverAmount ?? "0", precision: counterAsset.decimals) ?? BigDecimal(0)
            returnValue = CybridCurrencyFormatter.formatPrice(deliverAmount, with: self.counterAsset.symbol)
        }
        return returnValue
    }
}

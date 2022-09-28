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
    let feeValue: SBigDecimal
    let feeFormatted: String
    let asset: AssetBankModel
    let counterAsset: AssetBankModel
    let accoountGuid: String

    init?(tradeBankModel: TradeBankModel, asset: AssetBankModel, counterAsset: AssetBankModel, accountGuid: String) {

        let emptyValue = SBigDecimal(0)
        let fee = SBigDecimal(tradeBankModel.fee ?? "0", precision: counterAsset.decimals)
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
        if self.tradeBankModel.side == .sell {
            let deliverAmount = BigDecimal(self.tradeBankModel.deliverAmount ?? "0")
            returnValue = AssetPipe.transform(value: deliverAmount, asset: self.asset, unit: .trade).toPlainString(scale: asset.decimals).removeTrailingZeros()
        } else {
            let receiveAmount = BigDecimal(self.tradeBankModel.receiveAmount ?? "0")
            returnValue = AssetPipe.transform(value: receiveAmount, asset: self.asset, unit: .trade).toPlainString(scale: asset.decimals).removeTrailingZeros()
        }
        return returnValue
    }

    func getTradeFiatAmount() -> String {

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

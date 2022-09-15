//
//  TradeUIModel.swift
//  CybridSDK
//
//  Created by Erick Sanchez Perez on 25/08/22.
//

import Foundation
import CybridApiBankSwift

struct TradeUIModel {

    let tradeBankModel: TradeBankModel
    let feeValue: BigDecimal
    let feeFormatted: String
    let asset: AssetBankModel
    let counterAsset: AssetBankModel
    let accoountGuid: String

    init?(tradeBankModel: TradeBankModel, asset: AssetBankModel, counterAsset: AssetBankModel, accountGuid: String) {

        let fee = BigDecimal(tradeBankModel.fee ?? "0")
        let feeString = BigDecimalPipe.transform(value: fee, asset: counterAsset)

        self.tradeBankModel = tradeBankModel
        self.asset = asset
        self.counterAsset = counterAsset
        self.feeValue = fee
        self.feeFormatted = feeString ?? ""
        self.accoountGuid = accountGuid
    }

    func getTradeAmount() -> String {

        var returnValue = ""
        if self.tradeBankModel.side == .sell {
            let deliverAmount = BigDecimal(self.tradeBankModel.deliverAmount ?? "0")
            returnValue = AssetPipe.transform(value: deliverAmount, asset: self.asset, unit: .trade).toPlainString()
        } else {
            let receiveAmount = BigDecimal(self.tradeBankModel.receiveAmount ?? "0")
            returnValue = AssetPipe.transform(value: receiveAmount, asset: self.asset, unit: .trade).toPlainString()
        }
        return returnValue
    }

    func getTradeFiatAmount() -> String {

        var returnValue = ""
        if self.tradeBankModel.side == .sell {
            let receiveAmount = BigDecimal(self.tradeBankModel.receiveAmount ?? "0")
            returnValue = BigDecimalPipe.transform(value: receiveAmount, asset: self.counterAsset) ?? ""
        } else {
            let deliverAmount = BigDecimal(self.tradeBankModel.deliverAmount ?? "0")
            returnValue = BigDecimalPipe.transform(value: deliverAmount, asset: self.counterAsset) ?? ""
        }
        return returnValue
    }
}

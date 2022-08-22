//
//  AccountAssetPriceModel.swift
//  CybridSDK
//
//  Created by Erick Sanchez Perez on 18/08/22.
//

import CybridApiBankSwift
import Foundation
import BigInt

struct AccountAssetPriceModel {

    let accountAssetCode: String // BTC
    let accountBalance: BigDecimal // 12
    let accountBalanceFormatted: BigDecimal
    let accountBalanceFormattedString: String
    let accountBalanceInFiat: BigDecimal
    let accountBalanceInFiatFormatted: String
    let accountGuid: String
    let accountType: AccountBankModel.TypeBankModel?
    let accountCreated: Date
    let assetName: String
    let assetSymbol: String
    let assetType: AssetBankModel.TypeBankModel
    let assetDecimals: BigDecimal
    let pairAsset: AssetBankModel?
    let buyPrice: BigDecimal
    let buyPriceFormatted: String
    let sellPrice: BigDecimal

    init?(
        account: AccountBankModel,
        asset: AssetBankModel,
        counterAsset: AssetBankModel,
        price: SymbolPriceBankModel
    ) {

        let balanceValue = account.platformBalance ?? BigInt(0)
        let balanceValueFormatted = AssetPipe.transform(
            value: balanceValue, asset: counterAsset, unit: .trade)

        self.accountAssetCode = account.asset ?? ""
        self.accountBalance = BigDecimal(balanceValue)
        self.accountBalanceFormatted = BigDecimal(balanceValueFormatted)
        self.accountBalanceFormattedString = String(balanceValueFormatted)
        self.accountBalanceInFiat = BigDecimal("0")
        self.accountBalanceInFiatFormatted = ""
        self.accountGuid = account.guid ?? ""
        self.accountType = account.type
        self.accountCreated = account.createdAt ?? Date()
        self.assetName = ""
        self.assetSymbol = ""
        self.assetType = AssetBankModel.TypeBankModel.crypto
        self.assetDecimals = BigDecimal("0")
        self.pairAsset = nil
        self.buyPrice = BigDecimal("0")
        self.buyPriceFormatted = ""
        self.sellPrice = BigDecimal("0")
    }
}

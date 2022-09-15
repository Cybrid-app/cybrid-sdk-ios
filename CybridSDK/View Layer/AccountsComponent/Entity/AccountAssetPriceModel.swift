//
//  AccountAssetPriceModel.swift
//  CybridSDK
//
//  Created by Erick Sanchez Perez on 18/08/22.
//

import CybridApiBankSwift
import Foundation

struct AccountAssetPriceModel {

    let accountAssetCode: String // BTC
    let accountAssetURL: String // http://
    let accountBalance: BigDecimal
    let accountBalanceFormatted: String
    let accountBalanceInFiat: BigDecimal
    let accountBalanceInFiatFormatted: String
    let accountGuid: String
    let accountType: AccountBankModel.TypeBankModel?
    let accountCreated: Date
    let assetName: String
    let assetSymbol: String
    let assetType: AssetBankModel.TypeBankModel
    let assetDecimals: Int
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

        let balanceAccountBigDecimal = BigDecimal(account.platformBalance ?? "0")

        let balanceValue = BigDecimal(account.platformBalance ?? "0")
        let balanceValueFormatted = AssetPipe.transform(value: balanceAccountBigDecimal, asset: asset, unit: .trade).toPlainString()

        let buyPrice = BigDecimal(price.buyPrice ?? "0")
        let buyPriceFormatted = BigDecimalPipe.transform(value: buyPrice, asset: counterAsset)

        let accountBalanceInFiat = balanceValue.times(multiplicand: buyPrice)
        let accountBalanceInFiatFormatted = BigDecimalPipe.transform(value: accountBalanceInFiat, asset: counterAsset)

        self.accountAssetCode = account.asset ?? ""
        self.accountAssetURL = Cybrid.getCryptoIconURLString(with: self.accountAssetCode)
        self.accountBalance = balanceValue
        self.accountBalanceFormatted = balanceValueFormatted
        self.accountBalanceInFiat = accountBalanceInFiat
        self.accountBalanceInFiatFormatted = accountBalanceInFiatFormatted ?? ""
        self.accountGuid = account.guid ?? ""
        self.accountType = account.type
        self.accountCreated = account.createdAt ?? Date()
        self.assetName = asset.name
        self.assetSymbol = asset.symbol
        self.assetType = asset.type
        self.assetDecimals = asset.decimals
        self.pairAsset = counterAsset
        self.buyPrice = buyPrice
        self.buyPriceFormatted = buyPriceFormatted ?? ""
        self.sellPrice = BigDecimal(0)
    }
}

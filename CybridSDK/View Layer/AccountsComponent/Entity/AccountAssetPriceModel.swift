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

        let emptyValue = SBigDecimal(0)
        let balanceAccountBigDecimal = BigDecimal(value___: account.platformBalance ?? "0")

        let balanceValue = SBigDecimal(account.platformBalance ?? "0", precision: asset.decimals)
        let balanceValueFormatted = AssetPipe.transform(value: balanceAccountBigDecimal, asset: asset, unit: .trade).toPlainString()

        let buyPrice = SBigDecimal(price.buyPrice ?? "0", precision: counterAsset.decimals)
        let buyPriceFormatted = CybridCurrencyFormatter.formatPrice(buyPrice, with: counterAsset.symbol)

        let accountBalanceInFiat = try? balanceValue?.multiply(with: buyPrice, targetPrecision: counterAsset.decimals)
        let accountBalanceInFiatFormatted = CybridCurrencyFormatter.formatPrice(
            accountBalanceInFiat ?? emptyValue, with: counterAsset.symbol)

        self.accountAssetCode = account.asset ?? ""
        self.accountAssetURL = Cybrid.getCryptoIconURLString(with: self.accountAssetCode)
        self.accountBalance = balanceValue ?? emptyValue
        self.accountBalanceFormatted = balanceValueFormatted
        self.accountBalanceInFiat = accountBalanceInFiat ?? emptyValue
        self.accountBalanceInFiatFormatted = accountBalanceInFiatFormatted
        self.accountGuid = account.guid ?? ""
        self.accountType = account.type
        self.accountCreated = account.createdAt ?? Date()
        self.assetName = asset.name
        self.assetSymbol = asset.symbol
        self.assetType = asset.type
        self.assetDecimals = BigDecimal(value: Int32(asset.decimals))
        self.pairAsset = counterAsset
        self.buyPrice = buyPrice
        self.buyPriceFormatted = buyPriceFormatted
        self.sellPrice = BigDecimal(value___: "0")
    }
}

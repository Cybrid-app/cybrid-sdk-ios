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
    let accountBalanceInFiat: SBigDecimal
    let accountBalanceInFiatFormatted: String
    let accountGuid: String
    let accountType: AccountBankModel.TypeBankModel?
    let accountCreated: Date
    let assetName: String
    let assetSymbol: String
    let assetType: AssetBankModel.TypeBankModel
    let assetDecimals: Int
    let pairAsset: AssetBankModel?
    let buyPrice: SBigDecimal
    let buyPriceFormatted: String
    let sellPrice: BigDecimal

    init?(
        account: AccountBankModel,
        asset: AssetBankModel,
        counterAsset: AssetBankModel,
        price: SymbolPriceBankModel
    ) {

        let empty = SBigDecimal(0)
        let balanceValue = BigDecimal(account.platformBalance ?? "0")
        let balanceValueSBD = SBigDecimal(account.platformBalance ?? "0", precision: asset.decimals)
        let balanceValueFormatted = CybridCurrencyFormatter.formatInputNumber(balanceValueSBD ?? empty).removeTrailingZeros()

        let buyPrice = SBigDecimal(price.buyPrice ?? "0", precision: counterAsset.decimals)
        let buyPriceFormatted = CybridCurrencyFormatter.formatPrice(buyPrice ?? empty, with: counterAsset.symbol)

        let accountBalanceInFiat = try? balanceValueSBD?.multiply(with: buyPrice ?? empty, targetPrecision: counterAsset.decimals)
        let accountBalanceInFiatFormatted = CybridCurrencyFormatter.formatPrice(accountBalanceInFiat ?? empty, with: counterAsset.symbol)

        self.accountAssetCode = account.asset ?? ""
        self.accountAssetURL = Cybrid.getCryptoIconURLString(with: self.accountAssetCode)
        self.accountBalance = balanceValue
        self.accountBalanceFormatted = balanceValueFormatted
        self.accountBalanceInFiat = accountBalanceInFiat ?? SBigDecimal(0)
        self.accountBalanceInFiatFormatted = accountBalanceInFiatFormatted
        self.accountGuid = account.guid ?? ""
        self.accountType = account.type
        self.accountCreated = account.createdAt ?? Date()
        self.assetName = asset.name
        self.assetSymbol = asset.symbol
        self.assetType = asset.type
        self.assetDecimals = asset.decimals
        self.pairAsset = counterAsset
        self.buyPrice = buyPrice ?? empty
        self.buyPriceFormatted = buyPriceFormatted
        self.sellPrice = BigDecimal(0)
    }
}

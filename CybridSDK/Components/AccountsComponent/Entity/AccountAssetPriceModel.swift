//
//  AccountAssetPriceModel.swift
//  CybridSDK
//
//  Created by Erick Sanchez Perez on 18/08/22.
//

import CybridApiBankSwift
import Foundation

struct AccountAssetPriceModel: Equatable {

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

        let empty = BigDecimal(0)
        let balanceValue = BigDecimal(account.platformBalance ?? "0")
        let balanceValueSBD = BigDecimal(account.platformBalance ?? "0", precision: asset.decimals)
        let balanceValueFormatted = CybridCurrencyFormatter.formatInputNumber(balanceValueSBD ?? empty).removeTrailingZeros()

        let buyPrice = BigDecimal(price.buyPrice ?? "0", precision: counterAsset.decimals)
        let buyPriceFormatted = CybridCurrencyFormatter.formatPrice(buyPrice ?? empty, with: counterAsset.symbol)

        let accountBalanceInFiat = try? balanceValueSBD?.multiply(with: buyPrice ?? empty, targetPrecision: counterAsset.decimals)
        let accountBalanceInFiatFormatted = CybridCurrencyFormatter.formatPrice(accountBalanceInFiat ?? empty, with: counterAsset.symbol)

        self.accountAssetCode = account.asset ?? ""
        self.accountAssetURL = Cybrid.getAssetURL(with: self.accountAssetCode)
        self.accountBalance = balanceValue ?? BigDecimal(0)
        self.accountBalanceFormatted = balanceValueFormatted
        self.accountBalanceInFiat = accountBalanceInFiat ?? BigDecimal(0)
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

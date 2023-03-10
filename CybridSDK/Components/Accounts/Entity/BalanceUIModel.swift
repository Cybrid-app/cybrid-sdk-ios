//
//  AccountAssetPriceModel.swift
//  CybridSDK
//
//  Created by Erick Sanchez Perez on 18/08/22.
//

import CybridApiBankSwift
import Foundation

struct BalanceUIModel: Equatable {

    let account: AccountBankModel
    let asset: AssetBankModel?
    let counterAsset: AssetBankModel?
    let price: SymbolPriceBankModel?

    let accountBalance: BigDecimal
    let accountBalanceFormatted: String
    let accountBalanceInFiat: BigDecimal
    let accountBalanceInFiatFormatted: String
    let accountAvailable: BigDecimal
    let accountAvailableFormatted: String
    let accountPendingBalance: BigDecimal
    let accountPendingBalanceFormatted: String

    let buyPriceFormatted: String
    let accountAssetURL: String

    init?(
        account: AccountBankModel,
        asset: AssetBankModel?, // BTC
        counterAsset: AssetBankModel?, // USD
        price: SymbolPriceBankModel? // BTC-USD
    ) {

        let zero = BigDecimal(0)
        let assetDecimals = asset?.decimals ?? 0 // 18

        let balanceValue = BigDecimal(account.platformBalance ?? "0", precision: assetDecimals) ?? zero
        var balanceValueFormatted = CybridCurrencyFormatter.formatInputNumber(balanceValue).removeTrailingZeros()

        let balanceAvailable = BigDecimal(account.platformAvailable ?? "0", precision: assetDecimals) ?? zero
        let balanceAvailableFormatted = CybridCurrencyFormatter.formatPrice(balanceAvailable, with: asset?.symbol ?? "")

        let buyPrice = BigDecimal(price?.buyPrice ?? "0", precision: counterAsset?.decimals ?? 0) ?? zero
        let buyPriceFormatted = CybridCurrencyFormatter.formatPrice(buyPrice, with: counterAsset?.symbol ?? "")

        var accountBalanceInFiat = BigDecimal(0)
        if account.type == .fiat {
            accountBalanceInFiat = balanceAvailable
        } else {
            // swiftlint:disable:next force_try
            accountBalanceInFiat = try! balanceValue.multiply(with: buyPrice, targetPrecision: counterAsset?.decimals ?? 0)
        }
        let accountBalanceInFiatFormatted = CybridCurrencyFormatter.formatPrice(accountBalanceInFiat, with: counterAsset?.symbol ?? "")

        let accountPendingBalanceBI = balanceValue.value - balanceAvailable.value
        let accountPendingBalance = BigDecimal(accountPendingBalanceBI, precision: assetDecimals)
        let accountPendingBalanceFormatted = CybridCurrencyFormatter.formatPrice(accountPendingBalance, with: counterAsset?.symbol ?? "")

        // -- Set's
        self.account = account
        self.asset = asset
        self.counterAsset = counterAsset
        self.price = price

        self.accountBalance = balanceValue
        self.accountBalanceFormatted = balanceValueFormatted
        self.accountBalanceInFiat = accountBalanceInFiat
        self.accountBalanceInFiatFormatted = accountBalanceInFiatFormatted
        self.accountAvailable = balanceAvailable
        self.accountAvailableFormatted = balanceAvailableFormatted
        self.accountPendingBalance = accountPendingBalance
        self.accountPendingBalanceFormatted = accountPendingBalanceFormatted
        self.buyPriceFormatted = buyPriceFormatted
        self.accountAssetURL = Cybrid.getAssetURL(with: account.asset ?? "")
    }
}

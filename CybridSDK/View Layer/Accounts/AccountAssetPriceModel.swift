//
//  AccountAssetPriceModel.swift
//  CybridSDK
//
//  Created by Erick Sanchez Perez on 18/08/22.
//

import CybridApiBankSwift
import Foundation
import BigInt
import CybridCore

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
        
        print("__________________****_________________")
        let balanceBigDecimal = SBigDecimal(account.platformBalance ?? "0", precision: asset.decimals)
        let balanceBigDecimalFormatted = CybridCurrencyFormatter.formatPrice(balanceBigDecimal!, with: "")
        let nose = CybridCurrencyFormatter.formatInputNumber(balanceBigDecimal!)
        let perro = AssetPipe.transform(value: BigInt(account.platformBalance ?? "0")!, decimals: asset.decimals, unit: .trade)
        let loco = BigDecimal(value___: "350000000000000000000000000")
        let locoPerro = AssetPipe.transform(value: loco, asset: asset, unit: .trade)
        print(balanceBigDecimal)
        print(balanceBigDecimalFormatted)
        print(nose)
        print(perro)
        print(locoPerro)
        print("__________________****_________________")

        let balanceValue = BigDecimal(value___: account.platformBalance ?? "0")
        let balanceValueFormatted: BigDecimal = AssetPipe.transform(
            value: balanceValue, asset: asset, unit: .trade)
        let balanceValueFormattedString = balanceValueFormatted.toPlainString()

        let buyPriceString = String(price.buyPrice ?? BigInt(0))
        let buyPrice = BigDecimal(value___: buyPriceString)
        let buyPriceFormatted = BigDecimalPipe.transform(value: buyPrice, asset: counterAsset)

        let accountBalanceInFiat = balanceValueFormatted.times(multiplicand: buyPrice).setScale(scale: 2)
        let accountBalanceInFiatFormatted = BigDecimalPipe.transform(value: accountBalanceInFiat, asset: counterAsset)

        self.accountAssetCode = account.asset ?? ""
        self.accountBalance = balanceValue
        self.accountBalanceFormatted = balanceValueFormatted
        self.accountBalanceFormattedString = balanceValueFormattedString
        self.accountBalanceInFiat = accountBalanceInFiat
        self.accountBalanceInFiatFormatted = accountBalanceInFiatFormatted ?? "$0.0"
        self.accountGuid = account.guid ?? ""
        self.accountType = account.type
        self.accountCreated = account.createdAt ?? Date()
        self.assetName = asset.name
        self.assetSymbol = asset.symbol
        self.assetType = asset.type
        self.assetDecimals = BigDecimal(value: Int32(asset.decimals))
        self.pairAsset = counterAsset
        self.buyPrice = buyPrice
        self.buyPriceFormatted = buyPriceFormatted ?? ""
        self.sellPrice = BigDecimal(value___: "0")
    }
}

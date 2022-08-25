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
    let accountAssetURL: String // http://
    let accountBalance: SBigDecimal // 12
    let accountBalanceFormatted: String
    //let accountBalanceFormattedString: String
    let accountBalanceInFiat: SBigDecimal
    let accountBalanceInFiatFormatted: String
    let accountGuid: String
    let accountType: AccountBankModel.TypeBankModel?
    let accountCreated: Date
    let assetName: String
    let assetSymbol: String
    let assetType: AssetBankModel.TypeBankModel
    let assetDecimals: BigDecimal
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
        
        print("__________________****_________________")
        let balanceBigDecimal = SBigDecimal(account.platformBalance ?? "0", precision: asset.decimals)
        let balanceBigDecimalFormatted = CybridCurrencyFormatter.formatPrice(balanceBigDecimal!, with: counterAsset.symbol)
        let nose = CybridCurrencyFormatter.formatInputNumber(balanceBigDecimal!)
        let perro = AssetPipe.transform(value: BigInt(account.platformBalance ?? "0")!, decimals: asset.decimals, unit: .trade)
        let loco = BigDecimal(value___: "3500000000000000000")
        let locoPerro = AssetPipe.transform(value: loco, asset: asset, unit: .trade)
        print(balanceBigDecimal)
        print(balanceBigDecimalFormatted)
        print(nose)
        print(perro)
        print(locoPerro)
        print("__________________****_________________")

        //let balanceValue = BigDecimal(value___: account.platformBalance ?? "0")
        //let balanceValueFormatted: BigDecimal = AssetPipe.transform(
        //    value: balanceValue, asset: asset, unit: .trade)
        //let balanceValueFormattedString = balanceValueFormatted.toPlainString()
        let emptyValue = SBigDecimal(0)
        let balanceAccountBigDecimal = BigDecimal(value___: account.platformBalance ?? "0")
        
        let balanceValue = SBigDecimal(account.platformBalance ?? "0", precision: asset.decimals)
        let balanceValueFormattedOld = CybridCurrencyFormatter.formatPrice(balanceValue ?? emptyValue, with: "")
        let balanceValueFormatted = AssetPipe.transform(value: balanceAccountBigDecimal, asset: asset, unit: .trade).toPlainString()
        
        let buyPrice = SBigDecimal(price.buyPrice ?? "0", precision: counterAsset.decimals)
        let buyPriceFormatted = CybridCurrencyFormatter.formatPrice(buyPrice, with: counterAsset.symbol)
        
        let accountBalanceInFiat = try? balanceValue?.multiply(with: buyPrice, targetPrecision: counterAsset.decimals)
        let accountBalanceInFiatFormatted = CybridCurrencyFormatter.formatPrice(accountBalanceInFiat ?? emptyValue, with: counterAsset.symbol)

        //let accountBalanceInFiat = balanceValueFormatted.times(multiplicand: buyPrice).setScale(scale: 2)
        //let accountBalanceInFiatFormatted = BigDecimalPipe.transform(value: accountBalanceInFiat, asset: counterAsset)

        self.accountAssetCode = account.asset ?? ""
        self.accountAssetURL = Cybrid.getCryptoIconURLString(with: self.accountAssetCode)
        self.accountBalance = balanceValue ?? emptyValue
        self.accountBalanceFormatted = balanceValueFormatted
        // self.accountBalanceFormattedString = balanceValueFormattedString
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

//
//  AccountAssetPriceModel.swift
//  CybridSDK
//
//  Created by Erick Sanchez Perez on 18/08/22.
//

import Foundation
import CybridApiBankSwift

struct AccountAssetPriceModel {

    let accountAssetCode: String
    let accountBalance: BigDecimal
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
    let pairAsset:AssetBankModel?
    let buyPrice:BigDecimal
    let buyPriceFormatted: String
    let sellPrice: BigDecimal

    init?(
        account: AccountBankModel
    ) {

        self.accountAssetCode = ""
        self.accountBalance = BigDecimal("0")
        self.accountBalanceFormatted = BigDecimal("0")
        self.accountBalanceFormattedString = ""
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

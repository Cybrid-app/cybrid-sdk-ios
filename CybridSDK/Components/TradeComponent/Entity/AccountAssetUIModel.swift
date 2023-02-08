//
//  AccountAssetModel.swift
//  CybridSDK
//
//  Created by Erick Sanchez Perez on 06/02/23.
//

import Foundation
import BigInt
import CybridApiBankSwift

struct AccountAssetUIModel: Equatable {

    let account: AccountBankModel
    let asset: AssetBankModel
    let balanceFormatted: String

    init(account: AccountBankModel, asset: AssetBankModel) {

        self.account = account
        self.asset = asset

        let balanceToUse = account.type == .fiat ? account.platformAvailable : account.platformBalance

        let empty = BigDecimal(0)
        let balanceValueSBD = BigDecimal(balanceToUse ?? "0", precision: asset.decimals)
        var balanceValueFormatted: String = ""
        if account.type == .fiat {
            balanceValueFormatted = CybridCurrencyFormatter.formatPrice(balanceValueSBD ?? empty, with: asset.symbol)
        } else {

            //balanceValueFormatted = String(AssetPipe.transform(value: balanceValueSBD ?? empty, asset: asset, unit: "trade").value)
            balanceValueFormatted = CybridCurrencyFormatter.formatInputNumber(balanceValueSBD ?? empty).removeTrailingZeros()
        }
        self.balanceFormatted = balanceValueFormatted
    }
}

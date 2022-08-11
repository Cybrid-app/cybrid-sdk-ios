//
//  AssetBankModel+Extensions.swift
//  CybridSDK
//
//  Created by Cybrid on 5/08/22.
//

import CybridApiBankSwift

// MARK: - Default Fiat Assets
extension AssetBankModel {
  static let cad = AssetBankModel(
    type: .fiat,
    code: "CAD",
    name: "Canadian Dollar",
    symbol: "$",
    decimals: 2
  )

  static let usd = AssetBankModel(
    type: .fiat,
    code: "USD",
    name: "United State Dollar",
    symbol: "$",
    decimals: 2
  )
}

//
//  AssetBankModel+Extensions.swift
//  CybridSDK
//
//  Created by Cybrid on 5/08/22.
//

import CybridApiBankSwift

public enum FiatConfig {

    case usd
    case cad

    internal var defaultAsset: AssetBankModel {

        switch self {
        case .usd:
            return AssetBankModel(
                type: .fiat,
                code: "USD",
                name: "United State Dollar",
                symbol: "$",
                decimals: 2
            )
        case .cad:
            return AssetBankModel(
                type: .fiat,
                code: "CAD",
                name: "Canadian Dollar",
                symbol: "$",
                decimals: 2
            )
        }
    }
}

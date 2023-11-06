//
//  TradeType.swift
//  CybridSDK
//
//  Created by Erick Sanchez on 01/11/23.
//

import UIKit
import CybridApiBankSwift

enum TradeType: Int {

    case buy = 0
    case sell = 1

    var localizationKey: CybridLocalizationKey {
        switch self {
        case .buy:
            return CybridLocalizationKey.trade(.buy(.title))
        case .sell:
            return CybridLocalizationKey.trade(.sell(.title))
        }
    }

    var sideBankModel: PostQuoteBankModel.SideBankModel {
        switch self {
        case .buy:
            return .buy
        case .sell:
            return.sell
        }
    }
}

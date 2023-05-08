//
//  ListPricesOnClickDelegate.swift
//  CybridSDK
//
//  Created by Erick Sanchez Perez on 03/02/23.
//

import Foundation
import CybridApiBankSwift

protocol ListPricesItemDelegate: AnyObject {

    func onSelected(asset: AssetBankModel, counterAsset: AssetBankModel)
}

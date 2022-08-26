//
//  AccountTradeViewModel.swift
//  CybridSDK
//
//  Created by Erick Sanchez Perez on 25/08/22.
//

import Foundation
import CybridApiBankSwift

class AccountTradeViewModel: NSObject {

    // MARK: Observed properties
    internal var trades: Observable<[TradeUIModel]> = .init([])

    // MARK: Private properties
    // private unowned var cellProvider: AccountsViewProvider
    private var dataProvider: TradesRepoProvider
    private var logger: CybridLogger?
    private var assets: [AssetBankModel]?

    init(dataProvider: TradesRepoProvider,
         assets: [AssetBankModel],
         logger: CybridLogger?) {

        // self.cellProvider = cellProvider
        self.dataProvider = dataProvider
        self.assets = assets
        self.logger = logger
    }

    func getTrades(accountGuid: String) {
        dataProvider.fetchTrades(accountGuid: accountGuid) { [weak self] tradesResult in

            switch tradesResult {
            case .success(let tradesList):
                self?.logger?.log(.component(.trades(.tradesDataFetching)))
                guard let modelUIList = self?.createUIModelList(
                    trades: tradesList.objects,
                    assets: self?.assets) else {
                    return
                }
                self?.trades.value = modelUIList
            case .failure(let error):
                self?.logger?.log(.component(.trades(.tradesDataError)))
                print(error)
            }
        }
    }

    private func createUIModelList(
        trades: [TradeBankModel],
        assets: [AssetBankModel]?) -> [TradeUIModel]? {

        return trades.compactMap { trade in
            guard
                let tradeParts = trade.symbol?.split(separator: "-"),
                let asset = assets?.first(where: { $0.code == tradeParts[0] }),
                let counterAsset = assets?.first(where: { $0.code == tradeParts[1] })
            else {
                return nil
            }

            return TradeUIModel(
                tradeBankModel: trade,
                asset: asset,
                counterAsset: counterAsset)
        }
    }
}

//
//  AccountTradeViewModel.swift
//  CybridSDK
//
//  Created by Erick Sanchez Perez on 25/08/22.
//

import Foundation
import CybridApiBankSwift

open class AccountTradesViewModel: NSObject {

    // MARK: Observed properties
    internal var trades: Observable<[TradeUIModel]> = .init([])

    // MARK: Private properties
    private var dataProvider: TradesRepoProvider
    private var logger: CybridLogger?

    internal let assets = Cybrid.assets
    internal var tradesList: [TradeBankModel] = []
    internal var currentAccountGUID: String = ""

    init(dataProvider: TradesRepoProvider,
         logger: CybridLogger?) {

        self.dataProvider = dataProvider
        self.logger = logger
    }

    internal func getTrades(accountGuid: String) {

        self.currentAccountGUID = accountGuid
        dataProvider.fetchTrades(accountGuid: accountGuid) { [weak self] tradesResult in

            switch tradesResult {
            case .success(let tradesList):
                self?.logger?.log(.component(.trades(.tradesDataFetching)))
                self?.tradesList = tradesList.objects
                self?.buildModelList()
            case .failure(let error):
                self?.logger?.log(.component(.trades(.tradesDataError)))
                print(error)
            }
        }
    }

    internal func buildModelList() {

        if let modelUIList = self.createUIModelList(
            trades: self.tradesList,
            assets: self.assets,
            accountGuid: self.currentAccountGUID) {

            self.trades.value = modelUIList
        }
    }

    internal func createUIModelList(
        trades: [TradeBankModel],
        assets: [AssetBankModel],
        accountGuid: String) -> [TradeUIModel]? {

        return trades.compactMap { trade in
            guard
                let tradeParts = trade.symbol?.split(separator: "-"),
                let asset = assets.first(where: { $0.code == tradeParts[0] }),
                let counterAsset = assets.first(where: { $0.code == tradeParts[1] })
            else {
                return nil
            }

            return TradeUIModel(
                tradeBankModel: trade,
                asset: asset,
                counterAsset: counterAsset,
                accountGuid: accountGuid)
        }
    }
}

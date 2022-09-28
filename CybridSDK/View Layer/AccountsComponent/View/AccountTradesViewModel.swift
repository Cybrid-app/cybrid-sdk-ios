//
//  AccountTradeViewModel.swift
//  CybridSDK
//
//  Created by Erick Sanchez Perez on 25/08/22.
//

import Foundation
import CybridApiBankSwift

class AccountTradesViewModel: NSObject {

    // MARK: Observed properties
    internal var trades: Observable<[TradeUIModel]> = .init([])

    // MARK: Private properties
    private unowned var cellProvider: AccountTradesViewProvider
    private var dataProvider: TradesRepoProvider
    private var logger: CybridLogger?

    internal var assets: [AssetBankModel]
    internal var tradesList: [TradeBankModel] = []
    internal var currentCurrency: String = "USD"
    internal var currentAccountGUID: String = ""

    init(cellProvider: AccountTradesViewProvider,
         dataProvider: TradesRepoProvider,
         assets: [AssetBankModel],
         logger: CybridLogger?,
         currency: String = "USD") {

        self.cellProvider = cellProvider
        self.dataProvider = dataProvider
        self.assets = assets
        self.logger = logger
        self.currentCurrency = currency
    }

    func getTrades(accountGuid: String) {

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

// MARK: - TradesViewProvider

protocol AccountTradesViewProvider: AnyObject {

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, withData model: TradeUIModel) -> UITableViewCell

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath, with trade: TradeUIModel)
}

// MARK: - TradesViewModel + UITableViewDelegate + UITableViewDataSource

extension AccountTradesViewModel: UITableViewDelegate, UITableViewDataSource {

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        trades.value.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cellProvider.tableView(tableView, cellForRowAt: indexPath, withData: trades.value[indexPath.row])
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return AccountTradesHeaderCell(currency: self.currentCurrency)
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cellProvider.tableView(tableView, didSelectRowAt: indexPath, with: trades.value[indexPath.row])
    }
}

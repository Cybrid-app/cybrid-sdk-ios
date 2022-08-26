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
    private unowned var cellProvider: AccountTradesViewProvider
    private var dataProvider: TradesRepoProvider
    private var logger: CybridLogger?
    private var assets: [AssetBankModel]?
    private var currentCurrency: String = "USD"

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

// MARK: - TradesViewProvider

protocol AccountTradesViewProvider: AnyObject {

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, withData model: TradeUIModel) -> UITableViewCell

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath, with trade: TradeUIModel)
}

// MARK: - TradesViewModel + UITableViewDelegate + UITableViewDataSource

extension AccountTradeViewModel: UITableViewDelegate, UITableViewDataSource {

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

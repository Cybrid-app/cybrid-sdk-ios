//
//  AccountTradesViewModel.swift
//  CybridSDKTests
//
//  Created by Erick Sanchez Perez on 27/09/22.
//

import CybridApiBankSwift
@testable import CybridSDK
import XCTest

class AccountTradesViewModelTests: XCTestCase {

    lazy var dataProvider = ServiceProviderMock()

    func test_init() {

        let viewModel = AccountTradesViewModel(
            cellProvider: AccountTradesMockViewProvider(),
            dataProvider: self.dataProvider,
            assets: AssetListBankModel.mock.objects,
            logger: nil,
            currency: "USD")

        XCTAssertNotNil(viewModel)
        XCTAssertEqual(viewModel.currentCurrency, "USD")
        XCTAssertNotNil(viewModel.assets)
    }

    func test_getTrades_Successfully() {

        // -- Given
        let viewModel = AccountTradesViewModel(
            cellProvider: AccountTradesMockViewProvider(),
            dataProvider: self.dataProvider,
            assets: AssetListBankModel.mock.objects,
            logger: nil,
            currency: "USD")

        // -- When
        viewModel.getTrades(accountGuid: "")
        dataProvider.didFetchTradesListSuccessfully()

        // -- Then
        XCTAssertNotEqual(viewModel.tradesList, [])
    }

    func test_getTrades_Error() {

        // -- Given
        let viewModel = AccountTradesViewModel(
            cellProvider: AccountTradesMockViewProvider(),
            dataProvider: self.dataProvider,
            assets: AssetListBankModel.mock.objects,
            logger: nil,
            currency: "USD")

        // -- When
        viewModel.getTrades(accountGuid: "")
        dataProvider.didFetchTradesListWithError()

        // -- Then
        XCTAssertEqual(viewModel.tradesList, [])
    }

    func test_buildModelList_Successfully() throws {

        // -- Given
        let viewModel = AccountTradesViewModel(
            cellProvider: AccountTradesMockViewProvider(),
            dataProvider: self.dataProvider,
            assets: AssetListBankModel.mock.objects,
            logger: nil,
            currency: "USD")

        // -- When
        viewModel.getTrades(accountGuid: "")
        dataProvider.didFetchTradesListSuccessfully()

        // -- Then
        XCTAssertFalse(viewModel.trades.value.isEmpty)
    }

    func test_buildModelList_Error() throws {

        // -- Given
        let viewModel = AccountTradesViewModel(
            cellProvider: AccountTradesMockViewProvider(),
            dataProvider: self.dataProvider,
            assets: AssetListBankModel.mock.objects,
            logger: nil,
            currency: "USD")

        // -- When
        viewModel.getTrades(accountGuid: "")
        dataProvider.didFetchTradesListWithError()

        // -- Then
        XCTAssertTrue(viewModel.trades.value.isEmpty)
    }

    func test_createUIModelList_Nil() throws {

        // -- Given
        let viewModel = AccountTradesViewModel(
            cellProvider: AccountTradesMockViewProvider(),
            dataProvider: self.dataProvider,
            assets: AssetListBankModel.mock.objects,
            logger: nil,
            currency: "USD")

        // -- When
        viewModel.getTrades(accountGuid: "")
        dataProvider.didFetchTradesListSuccessfully()
        viewModel.tradesList[0].symbol = "MXN-BTC"

        let list = viewModel.createUIModelList(
            trades: viewModel.tradesList,
            assets: viewModel.assets,
            accountGuid: viewModel.currentAccountGUID)

        // -- Then
        XCTAssertEqual(list, [])
    }

    // MARK: TableView Delegation Test

    func test_TableViewRows() throws {

        // -- Given
        let balance = AccountAssetPriceModel(
            account: AccountsAPIMock.mock.objects[0],
            asset: AssetBankModel.bitcoin,
            counterAsset: AssetBankModel.usd,
            price: SymbolPriceBankModel.btcUSD1)
        let accountsViewModel = AccountsViewModel(
            cellProvider: AccountsMockViewProvider(),
            dataProvider: self.dataProvider,
            logger: nil,
            currency: "USD")
        let controller = AccountTradesViewController(
            balance: balance!,
            accountsViewModel: accountsViewModel)
        let tableView = controller.tradesTable
        let viewModel = AccountTradesViewModel(
            cellProvider: controller,
            dataProvider: self.dataProvider,
            assets: AssetListBankModel.mock.objects,
            logger: nil,
            currency: "USD")

        // -- When
        viewModel.getTrades(accountGuid: "")
        dataProvider.didFetchTradesListSuccessfully()
        tableView.reloadData()

        // -- Then
        XCTAssertEqual(viewModel.tableView(tableView, numberOfRowsInSection: 0), 1)
    }

    func test_TableViewHeader() throws {

        // -- Given
        let balance = AccountAssetPriceModel(
            account: AccountsAPIMock.mock.objects[0],
            asset: AssetBankModel.bitcoin,
            counterAsset: AssetBankModel.usd,
            price: SymbolPriceBankModel.btcUSD1)
        let accountsViewModel = AccountsViewModel(
            cellProvider: AccountsMockViewProvider(),
            dataProvider: self.dataProvider,
            logger: nil,
            currency: "USD")
        let controller = AccountTradesViewController(
            balance: balance!,
            accountsViewModel: accountsViewModel)
        let tableView = controller.tradesTable
        let viewModel = AccountTradesViewModel(
            cellProvider: controller,
            dataProvider: self.dataProvider,
            assets: AssetListBankModel.mock.objects,
            logger: nil,
            currency: "USD")

        // -- When
        viewModel.getTrades(accountGuid: "")
        dataProvider.didFetchTradesListSuccessfully()
        tableView.reloadData()
        let headerView = viewModel.tableView(tableView, viewForHeaderInSection: 0)

        // -- Then
        XCTAssertNotNil(headerView)
        XCTAssertTrue(headerView!.isKind(of: AccountTradesHeaderCell.self))
    }

    func test_TableViewValidCell() throws {

        // -- Given
        let balance = AccountAssetPriceModel(
            account: AccountsAPIMock.mock.objects[0],
            asset: AssetBankModel.bitcoin,
            counterAsset: AssetBankModel.usd,
            price: SymbolPriceBankModel.btcUSD1)
        let accountsViewModel = AccountsViewModel(
            cellProvider: AccountsMockViewProvider(),
            dataProvider: self.dataProvider,
            logger: nil,
            currency: "USD")
        let controller = AccountTradesViewController(
            balance: balance!,
            accountsViewModel: accountsViewModel)
        let tableView = controller.tradesTable
        let viewModel = AccountTradesViewModel(
            cellProvider: controller,
            dataProvider: self.dataProvider,
            assets: AssetListBankModel.mock.objects,
            logger: nil,
            currency: "USD")
        let indexPath = IndexPath(item: 0, section: 0)

        // -- When
        viewModel.getTrades(accountGuid: "")
        dataProvider.didFetchTradesListSuccessfully()
        tableView.reloadData()

        // -- Then
        XCTAssertTrue(viewModel.tableView(tableView, cellForRowAt: indexPath).isKind(of: AccountTradesCell.self))

    }

    func test_TableView_didSelectRowAtIndex() throws {

        // -- Given
        let balance = AccountAssetPriceModel(
            account: AccountsAPIMock.mock.objects[0],
            asset: AssetBankModel.bitcoin,
            counterAsset: AssetBankModel.usd,
            price: SymbolPriceBankModel.btcUSD1)
        let accountsViewModel = AccountsViewModel(
            cellProvider: AccountsMockViewProvider(),
            dataProvider: self.dataProvider,
            logger: nil,
            currency: "USD")
        let controller = AccountTradesViewController(
            balance: balance!,
            accountsViewModel: accountsViewModel)
        let tableView = controller.tradesTable
        let viewModel = AccountTradesViewModel(
            cellProvider: controller,
            dataProvider: self.dataProvider,
            assets: AssetListBankModel.mock.objects,
            logger: nil,
            currency: "USD")
        let indexPath = IndexPath(item: 0, section: 0)

        // -- When
        viewModel.getTrades(accountGuid: "")
        dataProvider.didFetchTradesListSuccessfully()
        tableView.reloadData()
        viewModel.tableView(tableView, didSelectRowAt: indexPath)
    }
}

class AccountTradesMockViewProvider: AccountTradesViewProvider {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, withData model: TradeUIModel) -> UITableViewCell {
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath, with trade: TradeUIModel) {}
}

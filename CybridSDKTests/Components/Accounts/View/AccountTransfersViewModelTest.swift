//
//  AccountTransfersViewModelTest.swift
//  CybridSDKTests
//
//  Created by Erick Sanchez Perez on 03/04/23.
//

import CybridApiBankSwift
@testable import CybridSDK
import XCTest

class AccountTransfersViewModelTest: XCTestCase {

    lazy var dataProvider = ServiceProviderMock()

    func test_init() {

        let viewModel = AccountTransfersViewModel(
            cellProvider: AccountTransfersMockViewProvider(),
            dataProvider: self.dataProvider,
            logger: nil)

        XCTAssertNotNil(viewModel)
        XCTAssertNotNil(viewModel.assets)
    }

    func test_getTransfers_Successfully() {

        // -- Given
        let viewModel = AccountTransfersViewModel(
            cellProvider: AccountTransfersMockViewProvider(),
            dataProvider: self.dataProvider,
            logger: nil)

        // -- When
        dataProvider.didFetchTransfersListSuccessfully()
        viewModel.getTransfers(accountGuid: "")
        dataProvider.didFetchTransfersListSuccessfully()

        // -- Then
        XCTAssertNotEqual(viewModel.tranfers.value, [])
    }

    func test_getTransfers_Error() {

        // -- Given
        let viewModel = AccountTransfersViewModel(
            cellProvider: AccountTransfersMockViewProvider(),
            dataProvider: self.dataProvider,
            logger: nil)

        // -- When
        viewModel.getTransfers(accountGuid: "")
        dataProvider.didFetchTransfersListWithError()

        // -- Then
        XCTAssertEqual(viewModel.tranfers.value, [])
    }

    func test_getAmountOfTransfer_Asset_Not_Found() {

        // -- This method covers try/catch
        // -- Given
        Cybrid.assets = AssetBankModel.mock
        let transfer = TransferBankModel(guid: "1234",
                                         asset: "MXN",
                                         state: .completed,
                                         amount: nil,
                                         estimatedAmount: nil)

        // -- When
        let amount = AccountTransfersViewModel.getAmountOfTransfer(transfer)

        // -- Then
        XCTAssertEqual(amount, CybridConstants.transferAssetError)
    }

    func test_getAmountOfTransfer_Asset_Nil() {

        // -- This method covers guard let
        // -- Given
        Cybrid.assets = AssetBankModel.mock
        let transfer = TransferBankModel(guid: "1234",
                                         asset: nil,
                                         state: .completed,
                                         amount: nil,
                                         estimatedAmount: nil)

        // -- When
        let amount = AccountTransfersViewModel.getAmountOfTransfer(transfer)

        // -- Then
        XCTAssertEqual(amount, CybridConstants.transferAssetError)
    }

    func test_getAmountOfTransfer_Success() {

        // -- This method covers success inside try/catch after guard let
        // -- This method validate amount, estimatedAmount and empty
        // -- Given
        Cybrid.assets = AssetBankModel.mock
        let transferUSDCompleted = TransferBankModel(
            guid: "1234",
            asset: "USD",
            state: .completed,
            amount: 1000,
            estimatedAmount: nil)
        let transferUSDCompletedNoAmount = TransferBankModel(
            guid: "1234",
            asset: "USD",
            state: .completed,
            amount: nil,
            estimatedAmount: nil)
        let transferUSDStoring = TransferBankModel(
            guid: "1234",
            asset: "USD",
            state: .storing,
            amount: nil,
            estimatedAmount: 2000)
        let transferUSDStoringNoEstimatedAmount = TransferBankModel(
            guid: "1234",
            asset: "USD",
            state: .storing,
            amount: nil,
            estimatedAmount: nil)

        // -- When
        let amountUSDCompleted = AccountTransfersViewModel.getAmountOfTransfer(transferUSDCompleted)
        let amountUSDCompletedNoAmount = AccountTransfersViewModel.getAmountOfTransfer(transferUSDCompletedNoAmount)
        let amountUSDStoring = AccountTransfersViewModel.getAmountOfTransfer(transferUSDStoring)
        let amountUSDStoringNoEstimatedAmount = AccountTransfersViewModel.getAmountOfTransfer(transferUSDStoringNoEstimatedAmount)

        // -- Then
        XCTAssertEqual(amountUSDCompleted, "10.00")
        XCTAssertEqual(amountUSDCompletedNoAmount, "0.00")
        XCTAssertEqual(amountUSDStoring, "20.00")
        XCTAssertEqual(amountUSDStoringNoEstimatedAmount, "0.00")
    }

    func test_getAmountOfTransferInFormat_With_Amount_as_Error() {

        // -- This method covers if validation
        // -- Given
        Cybrid.assets = AssetBankModel.mock
        let transfer = TransferBankModel(guid: "1234",
                                         asset: "MXN",
                                         state: .completed,
                                         amount: 1000,
                                         estimatedAmount: nil)

        // -- When
        let amountFormatted = AccountTransfersViewModel.getAmountOfTransferInFormat(transfer)

        // -- Then
        XCTAssertEqual(amountFormatted, CybridConstants.transferAssetError)
    }

    func test_getAmountOfTransferInFormat_Success() {

        // -- This method covers success inside try/catch after if validation
        // -- This method validate amount, estimatedAmount and empty
        // -- Given
        Cybrid.assets = AssetBankModel.mock
        let transfer = TransferBankModel(guid: "1234",
                                         asset: "USD",
                                         state: .completed,
                                         amount: 1000,
                                         estimatedAmount: nil)

        // -- When
        let amountFormatted = AccountTransfersViewModel.getAmountOfTransferInFormat(transfer)

        // -- Then
        XCTAssertEqual(amountFormatted, "$10.00 USD")
    }

    // MARK: TableView Delegation Test

    func test_TableViewRows() throws {

        // -- Given
        let balance = BalanceUIModel(
            account: AccountListBankModel.mock.objects[0],
            asset: AssetBankModel.bitcoin,
            counterAsset: AssetBankModel.usd,
            price: SymbolPriceBankModel.btcUSD1)
        let controller = AccountTransfersViewController(balance: balance)
        let tableView = controller.transfersTable
        let viewModel = AccountTransfersViewModel(
            cellProvider: controller,
            dataProvider: self.dataProvider,
            logger: nil)

        // -- When
        viewModel.getTransfers(accountGuid: "")
        dataProvider.didFetchTransfersListSuccessfully()
        tableView.reloadData()

        // -- Then
        XCTAssertEqual(viewModel.tableView(tableView, numberOfRowsInSection: 0), 1)
    }

    func test_TableViewHeader() throws {

        // -- Given
        let balance = BalanceUIModel(
            account: AccountListBankModel.mock.objects[0],
            asset: AssetBankModel.bitcoin,
            counterAsset: AssetBankModel.usd,
            price: SymbolPriceBankModel.btcUSD1)
        let controller = AccountTransfersViewController(balance: balance)
        let tableView = controller.transfersTable
        let viewModel = AccountTransfersViewModel(
            cellProvider: controller,
            dataProvider: self.dataProvider,
            logger: nil)

        // -- When
        viewModel.getTransfers(accountGuid: "")
        dataProvider.didFetchTransfersListSuccessfully()
        tableView.reloadData()
        let headerView = viewModel.tableView(tableView, viewForHeaderInSection: 0)

        // -- Then
        XCTAssertNotNil(headerView)
        XCTAssertTrue(headerView!.isKind(of: AccountTransfersHeaderCell.self))
    }

    func test_TableViewValidCell() throws {

        // -- Given
        let balance = BalanceUIModel(
            account: AccountListBankModel.mock.objects[0],
            asset: AssetBankModel.bitcoin,
            counterAsset: AssetBankModel.usd,
            price: SymbolPriceBankModel.btcUSD1)
        let controller = AccountTransfersViewController(balance: balance)
        let tableView = controller.transfersTable
        let viewModel = AccountTransfersViewModel(
            cellProvider: controller,
            dataProvider: self.dataProvider,
            logger: nil)
        let indexPath = IndexPath(item: 0, section: 0)

        // -- When
        viewModel.getTransfers(accountGuid: "")
        dataProvider.didFetchTransfersListSuccessfully()
        tableView.reloadData()

        // -- Then
        XCTAssertTrue(viewModel.tableView(tableView, cellForRowAt: indexPath).isKind(of: AccountTransfersCell.self))

    }

    func test_TableView_didSelectRowAtIndex() throws {

        // -- Given
        let balance = BalanceUIModel(
            account: AccountListBankModel.mock.objects[1],
            asset: AssetBankModel.usd,
            counterAsset: AssetBankModel.usd,
            price: SymbolPriceBankModel.btcUSD1)
        let controller = AccountTransfersViewController(balance: balance)
        let tableView = controller.transfersTable
        let viewModel = AccountTransfersViewModel(
            cellProvider: controller,
            dataProvider: self.dataProvider,
            logger: nil)
        let indexPath = IndexPath(item: 0, section: 0)

        // -- When
        viewModel.getTransfers(accountGuid: "")
        dataProvider.didFetchTransfersListSuccessfully()
        tableView.reloadData()
        viewModel.tableView(tableView, didSelectRowAt: indexPath)
    }
}

class AccountTransfersMockViewProvider: AccountTransfersViewProvider {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, withData model: TransferBankModel) -> UITableViewCell {
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath, with transfer: TransferBankModel) {}
}

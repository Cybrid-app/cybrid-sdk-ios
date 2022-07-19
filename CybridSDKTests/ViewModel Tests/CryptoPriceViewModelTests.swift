//
//  CryptoPriceViewModelTests.swift
//  CybridSDKTests
//
//  Created by Cybrid on 29/06/22.
//

@testable import CybridSDK
import XCTest

class CryptoPriceViewModelTests: XCTestCase {

  lazy var dataProvider = PriceListDataProviderMock()

  func testFetchData_Successfully() {
    // Given
    let viewProvider = CryptoPriceMockViewProvider()
    let viewModel = createViewModel(viewProvider: viewProvider)

    // When
    viewModel.fetchPriceList()
    dataProvider.didFetchAssetsSuccessfully()
    dataProvider.didFetchPricesSuccessfully()

    // Then
    XCTAssertFalse(viewModel.cryptoPriceList.value.isEmpty)
  }

  func testFetchData_Failure() {
    // Given
    let viewProvider = CryptoPriceMockViewProvider()
    let viewModel = createViewModel(viewProvider: viewProvider)

    // When
    viewModel.fetchPriceList()
    dataProvider.didFetchAssetsSuccessfully()
    dataProvider.didFetchPricesWithError()

    // Then
    XCTAssertTrue(viewModel.cryptoPriceList.value.isEmpty)
  }

  func testTableViewRows() {
    // Given
    let tableView = CryptoPriceListView()
    let viewModel = createViewModel(viewProvider: tableView)

    // When
    viewModel.fetchPriceList()
    dataProvider.didFetchAssetsSuccessfully()
    dataProvider.didFetchPricesSuccessfully()
    tableView.reloadData()

    // Then
    XCTAssertEqual(viewModel.tableView(tableView, numberOfRowsInSection: 0), Array.mockPrices.count)
  }

  func testTableViewValidCell() {
    // Given
    let tableView = CryptoPriceListView()
    let viewModel = createViewModel(viewProvider: tableView)

    // When
    viewModel.fetchPriceList()
    dataProvider.didFetchAssetsSuccessfully()
    dataProvider.didFetchPricesSuccessfully()
    tableView.reloadData()

    // Then
    XCTAssertTrue(viewModel.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 0)).isKind(of: CryptoPriceTableViewCell.self))
  }

  func testTableViewInvalidCell() {
    // Given
    let tableView = UITableView()
    let viewProvider = CryptoPriceMockViewProvider()
    let viewModel = createViewModel(viewProvider: viewProvider)

    // When
    viewModel.fetchPriceList()
    dataProvider.didFetchAssetsSuccessfully()
    dataProvider.didFetchPricesSuccessfully()
    tableView.reloadData()

    // Then
    XCTAssertFalse(viewModel.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 0)).isKind(of: CryptoPriceTableViewCell.self))
  }

  func testTableViewHeader() {
    // Given
    let tableView = CryptoPriceListView()
    let viewModel = createViewModel(viewProvider: tableView)

    // When
    viewModel.fetchPriceList()
    let headerView = viewModel.tableView(tableView, viewForHeaderInSection: 0)

    // Then
    XCTAssertNotNil(headerView)
    XCTAssertTrue(headerView!.isKind(of: CryptoPriceTableHeaderView.self))
  }
}

extension CryptoPriceViewModelTests {
  func createViewModel(viewProvider: CryptoPriceViewProvider) -> CryptoPriceViewModel {
    let viewModel = CryptoPriceViewModel(cellProvider: viewProvider, dataProvider: dataProvider)
    return viewModel
  }
}

class CryptoPriceMockViewProvider: CryptoPriceViewProvider {
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, withData dataModel: CryptoPriceModel) -> UITableViewCell {
    return UITableViewCell()
  }
}

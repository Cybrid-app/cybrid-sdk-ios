//
//  CryptoPriceViewModelTests.swift
//  CybridSDKTests
//
//  Created by Cybrid on 29/06/22.
//

import CybridApiBankSwift
@testable import CybridSDK
import XCTest

class CryptoPriceViewModelTests: XCTestCase {

  lazy var dataProvider = PriceListDataProviderMock()

  func testFetchData_successfully() {
    // Given
    let viewProvider = CryptoPriceMockViewProvider()
    let viewModel = createViewModel(viewProvider: viewProvider)

    // When
    viewModel.startLivePriceUpdates()
    dataProvider.didFetchAssetsSuccessfully()
    dataProvider.didFetchPricesSuccessfully()

    // Then
    XCTAssertFalse(viewModel.filteredCryptoPriceList.value.isEmpty)
  }

  func testFetchData_pricesFailure() {
    // Given
    let viewProvider = CryptoPriceMockViewProvider()
    let viewModel = createViewModel(viewProvider: viewProvider)

    // When
    viewModel.startLivePriceUpdates()
    dataProvider.didFetchAssetsSuccessfully()
    dataProvider.didFetchPricesWithError()

    // Then
    XCTAssertTrue(viewModel.filteredCryptoPriceList.value.isEmpty)
  }

  func testFetchData_assetsFailure() {
    // Given
    let viewProvider = CryptoPriceMockViewProvider()
    let viewModel = createViewModel(viewProvider: viewProvider)

    // When
    viewModel.startLivePriceUpdates()
    dataProvider.didFetchAssetsWithError()

    // Then
    XCTAssertTrue(viewModel.filteredCryptoPriceList.value.isEmpty)
  }

  func testViewModel_memoryDeallocation() {
    // Given
    let viewProvider = CryptoPriceMockViewProvider()
    var viewModel: CryptoPriceViewModel? = createViewModel(viewProvider: viewProvider)

    // When
    viewModel?.startLivePriceUpdates()
    dataProvider.didFetchAssetsSuccessfully()
    viewModel = nil
    dataProvider.didFetchPricesSuccessfully()

    // Then
    XCTAssertNil(viewModel)
  }

  func testFetchData_withWrongDataFormat() {
    // Given
    let viewProvider = CryptoPriceMockViewProvider()
    let viewModel = createViewModel(viewProvider: viewProvider)

    // When
    viewModel.startLivePriceUpdates()
    dataProvider.didFetchAssetsSuccessfully()
    dataProvider.didFetchPricesSuccessfully([
      SymbolPriceBankModel(
        symbol: "BTC_USD",
        buyPrice: 2_019_891,
        sellPrice: 2_019_881,
        buyPriceLastUpdatedAt: nil,
        sellPriceLastUpdatedAt: nil
      ),
      SymbolPriceBankModel(
        symbol: "ETH_USD",
        buyPrice: 209_891,
        sellPrice: 209_881,
        buyPriceLastUpdatedAt: nil,
        sellPriceLastUpdatedAt: nil
      )
    ])

    // Then
    XCTAssertTrue(viewModel.filteredCryptoPriceList.value.isEmpty)
  }

  func testFetchData_withCachedAssets() {
    // Given
    let viewProvider = CryptoPriceMockViewProvider()
    let viewModel = createViewModel(viewProvider: viewProvider)

    // When
    viewModel.startLivePriceUpdates()
    dataProvider.didFetchAssetsSuccessfully() // Assets Cached!
    dataProvider.didFetchPricesSuccessfully()

    let firstList = viewModel.filteredCryptoPriceList.value

    viewModel.startLivePriceUpdates()
    dataProvider.didFetchAssetsSuccessfully() // Assets retrieved from Cache
    dataProvider.didFetchPricesSuccessfully()

    let secondList = viewModel.filteredCryptoPriceList.value

    // Then
    XCTAssertEqual(firstList, secondList)
  }

  func testTableViewRows() {
    // Given
    let tableView = CryptoPriceListView()
    let viewModel = createViewModel(viewProvider: tableView)

    // When
    viewModel.startLivePriceUpdates()
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
    viewModel.startLivePriceUpdates()
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
    viewModel.startLivePriceUpdates()
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
    viewModel.startLivePriceUpdates()
    let headerView = viewModel.tableView(tableView, viewForHeaderInSection: 0)

    // Then
    XCTAssertNotNil(headerView)
    XCTAssertTrue(headerView!.isKind(of: CryptoPriceTableHeaderView.self))
  }

  func testSearchBar_filterWithValidQuery() {
    // Given
    let tableView = CryptoPriceListView()
    let viewModel = createViewModel(viewProvider: tableView)
    let searchBar = UISearchTextField()

    // When 1
    viewModel.startLivePriceUpdates()
    dataProvider.didFetchAssetsSuccessfully()
    dataProvider.didFetchPricesSuccessfully()

    // Then 1
    XCTAssertFalse(viewModel.filteredCryptoPriceList.value.isEmpty)

    // When 2
    searchBar.text = "BTC"
    viewModel.textFieldDidChangeSelection(searchBar)

    // Then 2
    XCTAssertFalse(viewModel.filteredCryptoPriceList.value.isEmpty)
    XCTAssertEqual(viewModel.filteredCryptoPriceList.value.count, 1)
  }

  func testSearchBar_filterWithEmptyText() {
    // Given
    let tableView = CryptoPriceListView()
    let viewModel = createViewModel(viewProvider: tableView)

    // When 1
    viewModel.startLivePriceUpdates()
    dataProvider.didFetchAssetsSuccessfully()
    dataProvider.didFetchPricesSuccessfully()

    // Then 1
    XCTAssertFalse(viewModel.filteredCryptoPriceList.value.isEmpty)

    // When 2
    viewModel.filterPriceList(with: nil)

    // Then 2
    XCTAssertEqual(viewModel.filteredCryptoPriceList.value, viewModel.cryptoPriceList)

    // When 3
    viewModel.filterPriceList(with: "")

    // Then 3
    XCTAssertEqual(viewModel.filteredCryptoPriceList.value, viewModel.cryptoPriceList)
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

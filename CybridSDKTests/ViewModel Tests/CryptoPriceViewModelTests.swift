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

  let pricesFetchScheduler = TaskSchedulerMock()
  lazy var dataProvider = ServiceProviderMock()

  func testFetchData_withLiveUpdate_successfully() {
    // Given
    let viewProvider = CryptoPriceMockViewProvider()
    let viewModel = createViewModel(viewProvider: viewProvider,
                                    pricesFetchScheduler: pricesFetchScheduler)

    // When
    viewModel.fetchPriceList()
    dataProvider.didFetchAssetsSuccessfully()
    dataProvider.didFetchPricesSuccessfully()

    // Then
    XCTAssertFalse(viewModel.filteredCryptoPriceList.value.isEmpty)
  }

  func testFetchData_withoutLiveUpdate_successfully() {
    // Given
    let viewProvider = CryptoPriceMockViewProvider()
    let viewModel = createViewModel(viewProvider: viewProvider)
    viewModel.taskScheduler = nil

    // When
    viewModel.fetchPriceList()
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
    viewModel.fetchPriceList()
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
    viewModel.fetchPriceList()
    dataProvider.didFetchAssetsWithError()

    // Then
    XCTAssertTrue(viewModel.filteredCryptoPriceList.value.isEmpty)
  }

  func testViewModel_memoryDeallocation() {
    // Given
    let viewProvider = CryptoPriceMockViewProvider()
    var viewModel: ListPricesViewModel? = createViewModel(viewProvider: viewProvider)

    // When
    viewModel?.fetchPriceList()
    dataProvider.didFetchAssetsSuccessfully()
    viewModel = nil
    dataProvider.didFetchPricesSuccessfully()

    // Then
    XCTAssertNil(viewModel)
  }

  func testPriceRepoProvider_MemoryDeallocation() {
    // Given
    let viewProvider = CryptoPriceMockViewProvider()
    var optionalDataProvider: ServiceProviderMock? = ServiceProviderMock()
    var viewModel: ListPricesViewModel? = createViewModel(viewProvider: viewProvider,
                                                           dataProvider: optionalDataProvider,
                                                           pricesFetchScheduler: pricesFetchScheduler)

    // When
    viewModel?.fetchPriceList()
    optionalDataProvider?.didFetchAssetsSuccessfully()
    XCTAssertTrue(pricesFetchScheduler.state == .running)

    // When
    viewModel = nil
    optionalDataProvider = nil
    pricesFetchScheduler.runNextLoop()

    // Then
    XCTAssertTrue(pricesFetchScheduler.state == .cancelled)
  }

  func testFetchData_withWrongDataFormat() {
    // Given
    let viewProvider = CryptoPriceMockViewProvider()
    let viewModel = createViewModel(viewProvider: viewProvider)

    // When
    viewModel.fetchPriceList()
    dataProvider.didFetchAssetsSuccessfully()
    dataProvider.didFetchPricesSuccessfully([
      SymbolPriceBankModel(
        symbol: "BTC_USD",
        buyPrice: "2019891",
        sellPrice: "2019881",
        buyPriceLastUpdatedAt: nil,
        sellPriceLastUpdatedAt: nil
      ),
      SymbolPriceBankModel(
        symbol: "ETH_USD",
        buyPrice: "209891",
        sellPrice: "209881",
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
    viewModel.fetchPriceList()
    dataProvider.didFetchAssetsSuccessfully() // Assets Cached!
    dataProvider.didFetchPricesSuccessfully()

    let firstList = viewModel.filteredCryptoPriceList.value

    viewModel.fetchPriceList()
    dataProvider.didFetchAssetsSuccessfully() // Assets retrieved from Cache
    dataProvider.didFetchPricesSuccessfully()

    let secondList = viewModel.filteredCryptoPriceList.value

    // Then
    XCTAssertEqual(firstList, secondList)
  }

}

// MARK: - Data Fetch Scheduled Tests

extension CryptoPriceViewModelTests {
  func testPriceLiveUpdate() {
    // Given
    let viewProvider = CryptoPriceMockViewProvider()
    let viewModel = createViewModel(viewProvider: viewProvider,
                                    pricesFetchScheduler: pricesFetchScheduler)
    let firstList: [CryptoPriceModel] = [
      CryptoPriceModel(
        symbolPrice: .btcUSD1,
        asset: .bitcoin,
        counterAsset: .usd
      ),
      CryptoPriceModel(
        symbolPrice: .ethUSD1,
        asset: .ethereum,
        counterAsset: .usd
      )
    ].compactMap { $0 }
    let secondList: [CryptoPriceModel] = [
      CryptoPriceModel(
        symbolPrice: .btcUSD2,
        asset: .bitcoin,
        counterAsset: .usd
      ),
      CryptoPriceModel(
        symbolPrice: .ethUSD2,
        asset: .ethereum,
        counterAsset: .usd
      )
    ].compactMap { $0 }

    // When
    viewModel.fetchPriceList()
    dataProvider.didFetchAssetsSuccessfully()
    dataProvider.didFetchPricesSuccessfully([
      .btcUSD1,
      .ethUSD1
    ])

    // Then
    XCTAssertEqual(firstList, viewModel.filteredCryptoPriceList.value)

    pricesFetchScheduler.runNextLoop()
    // When
    dataProvider.didFetchAssetsSuccessfully()
    dataProvider.didFetchPricesSuccessfully([
      .btcUSD2,
      .ethUSD2
    ])

    // Then
    XCTAssertEqual(secondList, viewModel.filteredCryptoPriceList.value)
  }

  func testPriceLiveUpdate_cancel() {
    // Given
    let viewProvider = CryptoPriceMockViewProvider()
    let viewModel = createViewModel(viewProvider: viewProvider,
                                    pricesFetchScheduler: pricesFetchScheduler)

    // When
    viewModel.fetchPriceList()
    dataProvider.didFetchAssetsSuccessfully()
    dataProvider.didFetchPricesSuccessfully()

    // Then
    XCTAssertTrue(pricesFetchScheduler.state == .running)

    // When
    viewModel.stopLiveUpdates()

    // Then
    XCTAssertTrue(pricesFetchScheduler.state == .cancelled)
  }

  func testPriceLiveUpdate_doubleCancel() {
    // Given
    let viewProvider = CryptoPriceMockViewProvider()
    let viewModel = createViewModel(viewProvider: viewProvider,
                                    pricesFetchScheduler: pricesFetchScheduler)

    // When
    viewModel.fetchPriceList()
    dataProvider.didFetchAssetsSuccessfully()
    dataProvider.didFetchPricesSuccessfully()

    // Then
    XCTAssertTrue(pricesFetchScheduler.state == .running)

    // When
    viewModel.stopLiveUpdates()
    pricesFetchScheduler.cancel()

    // Then
    XCTAssertTrue(pricesFetchScheduler.state == .cancelled)
  }
}

// MARK: - TableView Delegate Tests

extension CryptoPriceViewModelTests {
  func testTableViewRows() {
    // Given
    let tableView = ListPricesView()
    let viewModel = createViewModel(viewProvider: tableView)

    // When
    viewModel.fetchPriceList()
    dataProvider.didFetchAssetsSuccessfully()
    dataProvider.didFetchPricesSuccessfully()
    tableView.reloadData()

    // Then
    XCTAssertEqual(viewModel.tableView(tableView, numberOfRowsInSection: 0), Array.mockPrices.count)
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
    let tableView = ListPricesView()
    let viewModel = createViewModel(viewProvider: tableView)

    // When
    viewModel.fetchPriceList()
    let headerView = viewModel.tableView(tableView, viewForHeaderInSection: 0)

    // Then
    XCTAssertNotNil(headerView)
    XCTAssertTrue(headerView!.isKind(of: CryptoPriceTableHeaderView.self))
  }

  func testTableView_didSelectRowAtIndex() {
    // Given
    let tableView = ListPricesView()
    let viewModel = createViewModel(viewProvider: tableView)

    // When
    viewModel.fetchPriceList()
    dataProvider.didFetchAssetsSuccessfully()
    dataProvider.didFetchPricesSuccessfully()
    tableView.reloadData()
    viewModel.tableView(tableView, didSelectRowAt: IndexPath(item: 0, section: 0))
    let expectedCryptoViewModel = _TradeViewModel(selectedCrypto: .bitcoin,
                                                 dataProvider: dataProvider,
                                                 logger: nil)

    // Then
    XCTAssertNotNil(viewModel.selectedAsset.value)
  }

  func testTableView_didSelectRowAtIndex_withoutAssetsData() {
    // Given
    let tableView = ListPricesView()
    let viewModel = createViewModel(viewProvider: tableView)

    // When
    viewModel.fetchPriceList()
    dataProvider.didFetchAssetsSuccessfully()
    dataProvider.didFetchPricesSuccessfully()
    tableView.reloadData()
    dataProvider.assetsCache = nil // Clears cache
    viewModel.tableView(tableView, didSelectRowAt: IndexPath(item: 0, section: 0))

    // Then
    XCTAssertNil(viewModel.selectedAsset.value)
  }
}

// MARK: - SearchBar Tests

extension CryptoPriceViewModelTests {
  func testSearchBar_filterWithValidQuery() {
    // Given
    let tableView = ListPricesView()
    let viewModel = createViewModel(viewProvider: tableView)
    let searchBar = UISearchTextField()

    // When 1
    viewModel.fetchPriceList()
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
    let tableView = ListPricesView()
    let viewModel = createViewModel(viewProvider: tableView)

    // When 1
    viewModel.fetchPriceList()
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
  func createViewModel(viewProvider: ListPricesViewProvider,
                       dataProvider: (AssetsRepoProvider
                                      & PricesRepoProvider
                                      & QuotesRepoProvider
                                      & TradesRepoProvider)? = nil,
                       pricesFetchScheduler: TaskScheduler? = nil) -> ListPricesViewModel {
    let viewModel = ListPricesViewModel(
      cellProvider: viewProvider,
      dataProvider: dataProvider ?? self.dataProvider,
      logger: nil,
      taskScheduler: pricesFetchScheduler
    )
    return viewModel
  }
}

class CryptoPriceMockViewProvider: ListPricesViewProvider {
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, withData dataModel: CryptoPriceModel) -> UITableViewCell {
    return UITableViewCell()
  }
}

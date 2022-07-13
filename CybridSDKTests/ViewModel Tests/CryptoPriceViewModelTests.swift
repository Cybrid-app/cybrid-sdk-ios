//
//  CryptoPriceViewModelTests.swift
//  CybridSDKTests
//
//  Created by Cybrid on 29/06/22.
//

@testable import CybridSDK
import XCTest

class CryptoPriceViewModelTests: XCTestCase {

  var dataService = CurrencyListDataProviderMock()

  func testFetchData() {
    // Given
    let viewProvider = CryptoPriceMockViewProvider()
    let viewModel = createViewModel(viewProvider: viewProvider)

    // When
    viewModel.fetchPriceList()

    // Then
    XCTAssertEqual(viewModel.cryptoPriceList.value, CryptoPriceModel.mockList)
  }

  func testTableViewRows() {
    // Given
    let tableView = CryptoPriceListView()
    let viewModel = createViewModel(viewProvider: tableView)

    // When
    viewModel.fetchPriceList()

    // Then
    XCTAssertEqual(viewModel.tableView(tableView, numberOfRowsInSection: 0), CryptoPriceModel.mockList.count)
  }

  func testTableViewValidCell() {
    // Given
    let tableView = CryptoPriceListView()
    let viewModel = createViewModel(viewProvider: tableView)

    // When
    viewModel.fetchPriceList()

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
    let viewModel = CryptoPriceViewModel(cellProvider: viewProvider, dataProvider: dataService)
    return viewModel
  }
}

class CryptoPriceMockViewProvider: CryptoPriceViewProvider {
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, withData dataModel: CryptoPriceModel) -> UITableViewCell {
    return UITableViewCell()
  }
}

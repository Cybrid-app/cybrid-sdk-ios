//
//  BuyQuoteViewModelTests.swift
//  CybridSDKTests
//
//  Created by Cybrid on 11/08/22.
//

import BigInt
import CybridApiBankSwift
@testable import CybridSDK
import XCTest

class BuyQuoteViewModelTests: XCTestCase {
  let pricesFetchScheduler = TaskSchedulerMock()
  lazy var dataProvider = PriceListDataProviderMock(pricesFetchScheduler: pricesFetchScheduler)

  func testViewModel_initialization() {
    // Given
    let viewModel = createViewModel()

    // Then
    XCTAssertTrue(viewModel.assetList.value.isEmpty)
    XCTAssertNil(viewModel.selectedPriceRate)
  }

  func testViewModel_initialization_withMissingCrypto() {
    // Given
    let viewModel = createViewModel(priceList: [.btcUSD1, .priceWithoutSymbol])

    // When
    viewModel.cryptoCurrency.value = .init(asset: .dogecoin)

    // Then
    XCTAssertTrue(viewModel.assetList.value.isEmpty)
    XCTAssertNil(viewModel.selectedPriceRate)
  }

  func testFetchData_successfully() {
    // Given
    let viewModel = createViewModel()

    // When
    viewModel.fetchPriceList()
    dataProvider.didFetchAssetsSuccessfully()
    dataProvider.didFetchPricesSuccessfully()

    // Then
    XCTAssertFalse(viewModel.assetList.value.isEmpty)
    XCTAssertNotNil(viewModel.selectedPriceRate)
  }

  func testFetchData_pricesFailure() {
    // Given
    let viewModel = createViewModel()

    // When
    viewModel.fetchPriceList()
    dataProvider.didFetchAssetsSuccessfully()
    dataProvider.didFetchPricesWithError()

    // Then
    XCTAssertNil(viewModel.selectedPriceRate)
  }

  func testFetchData_assetsFailure() {
    // Given
    let viewModel = createViewModel()

    // When
    viewModel.fetchPriceList()
    dataProvider.didFetchAssetsWithError()

    // Then
    XCTAssertTrue(viewModel.assetList.value.isEmpty)
  }

  func testViewModel_pickerSetup() {
    // Given
    let viewModel = createViewModel()
    let pickerView = UIPickerView()

    // When
    viewModel.fetchPriceList()
    dataProvider.didFetchAssetsSuccessfully()
    dataProvider.didFetchPricesSuccessfully()

    // Then
    XCTAssertEqual(viewModel.numberOfComponents(in: pickerView), 1)
    XCTAssertEqual(viewModel.pickerView(pickerView, numberOfRowsInComponent: 0), 2)
    XCTAssertEqual(viewModel.pickerView(pickerView, titleForRow: 0, forComponent: 0), "Bitcoin")
  }

  func testViewModel_pickerSelect() {
    // Given
    let viewModel = createViewModel()
    let pickerView = UIPickerView()

    // When
    viewModel.fetchPriceList()
    dataProvider.didFetchAssetsSuccessfully()
    dataProvider.didFetchPricesSuccessfully()
    viewModel.pickerView(pickerView, didSelectRow: 1, inComponent: 0)

    // Then
    XCTAssertEqual(viewModel.cryptoCurrency.value?.asset.name, "Ethereum")
  }

  func testViewModel_amountInput() {
    // Given
    let viewModel = createViewModel()
    let textField = CYBTextField(style: .plain, icon: .text("USD"), theme: CybridTheme.default)

    // When
    viewModel.fetchPriceList()
    dataProvider.didFetchAssetsSuccessfully()
    dataProvider.didFetchPricesSuccessfully()
    textField.text = "1.10020030"
    viewModel.textFieldDidChangeSelection(textField)

    // Then
    XCTAssertEqual(viewModel.displayAmount.value, "$22,222.85 USD")
  }

  func testViewModel_amountInput_duplicate() {
    // Given
    let viewModel = createViewModel()
    let textField = CYBTextField(style: .plain, icon: .text("USD"), theme: CybridTheme.default)

    // When
    viewModel.fetchPriceList()
    dataProvider.didFetchAssetsSuccessfully()
    dataProvider.didFetchPricesSuccessfully()
    textField.text = "1.10020030"
    viewModel.textFieldDidChangeSelection(textField)
    viewModel.textFieldDidChangeSelection(textField)

    // Then
    XCTAssertEqual(viewModel.displayAmount.value, "$22,222.85 USD")
  }

  func testViewModel_switchConversion() {
    // Given
    let viewModel = createViewModel()
    let textField = CYBTextField(style: .plain, icon: .text("USD"), theme: CybridTheme.default)

    // When
    viewModel.fetchPriceList()
    dataProvider.didFetchAssetsSuccessfully()
    dataProvider.didFetchPricesSuccessfully()
    textField.text = "1.10020030"
    viewModel.textFieldDidChangeSelection(textField)
    viewModel.switchConversion()

    // Then
    XCTAssertEqual(viewModel.amountText.value, "1100200.30")
  }

  func testViewModel_updateButtonState_CryptoInput() {
    // Given
    let viewModel = createViewModel()

    // When
    viewModel.fetchPriceList()
    dataProvider.didFetchAssetsSuccessfully()
    dataProvider.didFetchPricesSuccessfully()
    viewModel.shouldInputCrypto.value = true
    viewModel.displayAmount.value = "$1.00 USD"
    viewModel.updateButtonState()

    // Then
    XCTAssertTrue(viewModel.ctaButtonEnabled.value)
  }

  func testViewModel_updateButtonState_FiatInput() {
    // Given
    let viewModel = createViewModel()

    // When
    viewModel.fetchPriceList()
    dataProvider.didFetchAssetsSuccessfully()
    dataProvider.didFetchPricesSuccessfully()
    viewModel.shouldInputCrypto.value = false
    viewModel.amountText.value = "1.10020030"
    viewModel.updateButtonState()

    // Then
    XCTAssertTrue(viewModel.ctaButtonEnabled.value)
  }

  func testViewModel_updateButtonState_EmptyAmount() {
    // Given
    let viewModel = createViewModel()

    // When
    viewModel.fetchPriceList()
    dataProvider.didFetchAssetsSuccessfully()
    dataProvider.didFetchPricesSuccessfully()
    viewModel.shouldInputCrypto.value = true
    viewModel.displayAmount.value = nil
    viewModel.updateButtonState()

    // Then
    XCTAssertFalse(viewModel.ctaButtonEnabled.value)
  }

  func testViewModel_inputGreaterThanZero_bitcoinInput() {
    // Given
    let viewModel = createViewModel()

    // When
    viewModel.cryptoCurrency.value = .init(asset: .bitcoin)

    // Then
    XCTAssertFalse(viewModel.isInputGreaterThanZero("0"))
    XCTAssertFalse(viewModel.isInputGreaterThanZero("A"))
    XCTAssertTrue(viewModel.isInputGreaterThanZero("100"))

    // When
    viewModel.cryptoCurrency.value = nil

    // Then
    XCTAssertFalse(viewModel.isInputGreaterThanZero("0"))
  }

  func testViewModel_formatInputText() {
    // Given
    let viewModel = createViewModel()

    // When
    viewModel.cryptoCurrency.value = .init(asset: .bitcoin)

    // Then
    XCTAssertEqual(viewModel.formatInputText("100"), "0.00000100")

    // When
    viewModel.cryptoCurrency.value = nil

    // Then
    XCTAssertNil(viewModel.formatInputText("1.00"))
  }

  func testViewModel_formatDisplayAmount() {
    // Given
    let viewModel = createViewModel()

    // When
    viewModel.fetchPriceList()
    dataProvider.didFetchAssetsSuccessfully()
    dataProvider.didFetchPricesSuccessfully()

    // Then: convert to Fiat without crypto Currency
    viewModel.cryptoCurrency.value = nil
    XCTAssertEqual(viewModel.formatAndConvert("1"), "$0.00 USD")

    // Then: convert to Fiat with crypto Currency
    viewModel.cryptoCurrency.value = .init(asset: .bitcoin)
    XCTAssertEqual(viewModel.formatAndConvert("100000000"), "$20,198.91 USD")

    // Then: convert to Crypto
    viewModel.switchConversion()
    XCTAssertEqual(viewModel.formatAndConvert("2019891"), "1.00000000 BTC")

    // Then: convert to Crypto without crypto Currency
    viewModel.cryptoCurrency.value = nil
    XCTAssertEqual(viewModel.formatAndConvert("2019891"), "0.00")
  }
}

extension BuyQuoteViewModelTests {
  func createViewModel(dataProvider: (AssetsRepoProvider & PricesRepoProvider)? = nil,
                       priceList: [SymbolPriceBankModel]? = nil) -> BuyQuoteViewModel {
    return BuyQuoteViewModel(dataProvider: dataProvider ?? self.dataProvider,
                             fiatAsset: .usd,
                             logger: nil,
                             priceList: priceList)
  }
}

//
//  TradeViewModelTests.swift
//  CybridSDKTests
//
//  Created by Cybrid on 11/08/22.
//

import BigInt
import CybridApiBankSwift
@testable import CybridSDK
import XCTest

class TradeViewModelTests: XCTestCase {
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
    let viewModel = createViewModel(selectedCrypto: .dogecoin)

    // When
    viewModel.fetchPriceList()
    dataProvider.didFetchAssetsSuccessfully()
    dataProvider.didFetchPricesSuccessfully()

    // Then
    XCTAssertNil(viewModel.selectedPriceRate)
  }

  func testViewModel_initialization_withMalformedCryptoData() {
    // Given
    let viewModel = createViewModel(selectedCrypto: .dogecoin)

    // When
    viewModel.fetchPriceList()
    dataProvider.didFetchAssetsSuccessfully()
    dataProvider.didFetchPricesSuccessfully([.priceWithoutSymbol])

    // Then
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

  func testFetchData_successfully_withCachedAssets() {
    // Given
    dataProvider.didFetchAssetsSuccessfully()
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

  func testViewModel_segmentControl_Selection() {
    // Given
    let viewModel = createViewModel()
    let segmentedControl = UISegmentedControl(items: ["Buy", "Sell"])

    XCTAssertEqual(viewModel.segmentSelection.value, .buy)

    // When
    viewModel.fetchPriceList()
    dataProvider.didFetchAssetsSuccessfully()
    dataProvider.didFetchPricesSuccessfully()
    segmentedControl.selectedSegmentIndex = 1
    viewModel.segmentedControlValueChanged(segmentedControl)

    // Then
    XCTAssertEqual(viewModel.segmentSelection.value, .sell)
  }

  func testViewModel_segmentControl_invalidSelection() {
    // Given
    let viewModel = createViewModel()
    let segmentedControl = UISegmentedControl(items: ["Buy", "Sell"])

    XCTAssertEqual(viewModel.segmentSelection.value, .buy)

    // When
    viewModel.fetchPriceList()
    dataProvider.didFetchAssetsSuccessfully()
    dataProvider.didFetchPricesSuccessfully()
    segmentedControl.selectedSegmentIndex = 100
    viewModel.segmentedControlValueChanged(segmentedControl)

    // Then
    XCTAssertEqual(viewModel.segmentSelection.value, .buy)
  }

  func testViewModel_segmentControl_localizationKeys() {
    XCTAssertEqual(TradeSegment.buy.localizationKey, .trade(.buy(.title)))
    XCTAssertEqual(TradeSegment.sell.localizationKey, .trade(.sell(.title)))
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
    viewModel.didTapConversionSwitchButton()

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
    viewModel.didTapConversionSwitchButton()
    XCTAssertEqual(viewModel.formatAndConvert("2019891"), "1.00000000 BTC")

    // Then: convert to Crypto without crypto Currency
    viewModel.cryptoCurrency.value = nil
    XCTAssertEqual(viewModel.formatAndConvert("2019891"), "0.00")
  }

  func testViewModel_createQuote() {
    // Given
    let viewModel = createViewModel()
    viewModel.fetchPriceList()
    dataProvider.didFetchAssetsSuccessfully()
    dataProvider.didFetchPricesSuccessfully()

    // When
    viewModel.createQuote()

    // Then
    XCTAssertNotNil(viewModel.generatedQuoteModel.value)
    XCTAssertEqual(viewModel.generatedQuoteModel.value?.quoteType, .buy)
  }

  func testViewModel_createQuote_alternative() {
    // Given
    let viewModel = createViewModel()
    viewModel.fetchPriceList()
    dataProvider.didFetchAssetsSuccessfully()
    dataProvider.didFetchPricesSuccessfully()
    viewModel.cryptoCurrency.value = nil
    viewModel.segmentSelection.value = .sell

    // When
    viewModel.createQuote()

    // Then
    XCTAssertNotNil(viewModel.generatedQuoteModel.value)
    XCTAssertEqual(viewModel.generatedQuoteModel.value?.cryptoCode, "")
    XCTAssertEqual(viewModel.generatedQuoteModel.value?.quoteType, .sell)
  }

  func testViewModel_confirmOperation() {
    // Given
    let viewModel = createViewModel()
    viewModel.fetchPriceList()
    dataProvider.didFetchAssetsSuccessfully()
    dataProvider.didFetchPricesSuccessfully()
    viewModel.cryptoCurrency.value = nil
    viewModel.segmentSelection.value = .sell

    // When
    viewModel.confirmOperation()

    // Then
    XCTAssertNotNil(viewModel.tradeSuccessModel.value)
    XCTAssertEqual(viewModel.tradeSuccessModel.value?.cryptoCode, "")
    XCTAssertEqual(viewModel.tradeSuccessModel.value?.quoteType, .sell)
  }

  func testViewModel_confirmOperation_alternative() {
    // Given
    let viewModel = createViewModel()
    viewModel.fetchPriceList()
    dataProvider.didFetchAssetsSuccessfully()
    dataProvider.didFetchPricesSuccessfully()

    // When
    viewModel.confirmOperation()

    // Then
    XCTAssertNotNil(viewModel.tradeSuccessModel.value)
  }
}

extension TradeViewModelTests {
  func createViewModel(selectedCrypto: AssetBankModel = .bitcoin,
                       dataProvider: (AssetsRepoProvider & PricesRepoProvider)? = nil) -> TradeViewModel {
    return TradeViewModel(selectedCrypto: selectedCrypto,
                          dataProvider: dataProvider ?? self.dataProvider,
                          logger: nil)
  }
}

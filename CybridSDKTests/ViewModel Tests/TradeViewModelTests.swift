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
  lazy var dataProvider = ServiceProviderMock(pricesFetchScheduler: pricesFetchScheduler)

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
    XCTAssertEqual(TradeType.buy.localizationKey, .trade(.buy(.title)))
    XCTAssertEqual(TradeType.sell.localizationKey, .trade(.sell(.title)))
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

  func testViewModel_createBuyQuote() {
    // Given
    let viewModel = createViewModel()
    viewModel.fetchPriceList()
    dataProvider.didFetchAssetsSuccessfully()
    dataProvider.didFetchPricesSuccessfully()
    viewModel.amountText.value = "0.00012343"

    // When
    viewModel.createQuote()
    dataProvider.didCreateQuoteSuccessfully(.buyBitcoin)

    // Then
    XCTAssertNotNil(viewModel.generatedQuoteModel.value)
    XCTAssertEqual(viewModel.generatedQuoteModel.value?.quoteType, .buy)
    XCTAssertEqual(viewModel.generatedQuoteModel.value?.fiatAmount, "$2.68")
    XCTAssertEqual(viewModel.generatedQuoteModel.value?.cryptoAmount, "0.00012343")
  }

  func testViewModel_createSellQuote() {
    // Given
    let viewModel = createViewModel()
    viewModel.fetchPriceList()
    dataProvider.didFetchAssetsSuccessfully()
    dataProvider.didFetchPricesSuccessfully()
    viewModel.segmentSelection.value = .sell
    viewModel.amountText.value = "2.68"

    // When
    viewModel.createQuote()
    dataProvider.didCreateQuoteSuccessfully(.sellBitcoin)

    // Then
    XCTAssertNotNil(viewModel.generatedQuoteModel.value)
    XCTAssertEqual(viewModel.generatedQuoteModel.value?.quoteType, .sell)
    XCTAssertEqual(viewModel.generatedQuoteModel.value?.fiatAmount, "$2.68")
    XCTAssertEqual(viewModel.generatedQuoteModel.value?.cryptoAmount, "0.00012343")
  }

  func testViewModel_confirmBuyOperation() {
    // Given
    let viewModel = createViewModel()
    viewModel.fetchPriceList()
    dataProvider.didFetchAssetsSuccessfully()
    dataProvider.didFetchPricesSuccessfully()
    viewModel.amountText.value = "0.00012343"

    // When
    viewModel.createQuote()
    dataProvider.didCreateQuoteSuccessfully(.buyBitcoin)
    viewModel.confirmOperation()
    dataProvider.didCreateTradeSuccessfully(.buyBitcoin)

    // Then
    XCTAssertNotNil(viewModel.tradeSuccessModel.value)
    XCTAssertEqual(viewModel.tradeSuccessModel.value?.quoteType, .buy)
    XCTAssertEqual(viewModel.tradeSuccessModel.value?.fiatAmount, "$2.68")
    XCTAssertEqual(viewModel.tradeSuccessModel.value?.cryptoAmount, "0.00012343")
  }

  func testViewModel_confirmSellOperation() {
    // Given
    let viewModel = createViewModel()
    viewModel.fetchPriceList()
    dataProvider.didFetchAssetsSuccessfully()
    dataProvider.didFetchPricesSuccessfully()
    viewModel.segmentSelection.value = .sell
    viewModel.amountText.value = "2.68"

    // When
    viewModel.createQuote()
    dataProvider.didCreateQuoteSuccessfully(.sellBitcoin)
    viewModel.confirmOperation()
    dataProvider.didCreateTradeSuccessfully(.sellBitcoin)

    // Then
    XCTAssertNotNil(viewModel.tradeSuccessModel.value)
    XCTAssertEqual(viewModel.tradeSuccessModel.value?.quoteType, .sell)
    XCTAssertEqual(viewModel.tradeSuccessModel.value?.fiatAmount, "$2.68")
    XCTAssertEqual(viewModel.tradeSuccessModel.value?.cryptoAmount, "0.00012343")
  }
}

extension TradeViewModelTests {
  func createViewModel(selectedCrypto: AssetBankModel = .bitcoin) -> TradeViewModel {
    return TradeViewModel(selectedCrypto: selectedCrypto,
                          dataProvider: self.dataProvider,
                          logger: nil)
  }
}

//
//  TradeViewModel.swift
//  CybridSDK
//
//  Created by Cybrid on 16/08/22.
//

import BigInt
import CybridApiBankSwift

enum TradeSegment: Int {
  case buy = 0
  case sell = 1

  var localizationKey: CybridLocalizationKey {
    switch self {
    case .buy:
      return CybridLocalizationKey.trade(.buy(.title))
    case .sell:
      return CybridLocalizationKey.trade(.sell(.title))
    }
  }
}

final class TradeViewModel: NSObject {
  // MARK: Observed Properties
  internal var amountText: Observable<String?> = Observable(nil)
  internal var assetList: Observable<[CurrencyModel]>
  internal var cryptoCurrency: Observable<CurrencyModel?>
  internal var ctaButtonEnabled: Observable<Bool> = Observable(false)
  internal var displayAmount: Observable<String?> = Observable(nil)
  internal var segmentSelection: Observable<TradeSegment> = Observable(.buy)
  internal var shouldInputCrypto: Observable<Bool> = Observable(true)

  internal var generatedQuoteModel: Observable<TradeConfirmationModalView.DataModel?> = Observable(nil)
  internal var tradeSuccessModel: Observable<TradeSuccessModalView.DataModel?> = Observable(nil)

  // MARK: Internal Properties
  internal let fiatCurrency: CurrencyModel

  // MARK: Computed properties
  internal var selectedPriceRate: BigInt? {
    guard let cryptoCode = cryptoCurrency.value?.asset.code else { return nil }
    let priceRate = priceList.first { $0.symbol?.contains(cryptoCode) ?? false }
    return priceRate?.buyPrice
  }

  // MARK: Private Properties
  private let dataProvider: AssetsRepoProvider & PricesRepoProvider
  private let logger: CybridLogger?
  private var priceList: [SymbolPriceBankModel] {
    didSet {
      updateConversion()
    }
  }

  init(selectedCrypto: AssetBankModel,
       dataProvider: AssetsRepoProvider & PricesRepoProvider,
       logger: CybridLogger?) {
    self.dataProvider = dataProvider
    self.fiatCurrency = CurrencyModel(asset: Cybrid.fiat.defaultAsset)
    self.assetList = Observable([])
    self.logger = Cybrid.logger
    self.priceList = []
    self.cryptoCurrency = Observable(.init(asset: selectedCrypto))
    if let assetsCache = dataProvider.assetsCache {
      self.assetList.value = assetsCache.map { .init(asset: $0) }
    }
    cryptoCurrency.value = .init(asset: selectedCrypto)
  }

  func fetchPriceList() {
    dataProvider.fetchAssetsList { [weak self] assetsResult in
      switch assetsResult {
      case .success(let assetList):
        self?.assetList.value = assetList
          .filter { $0.type == .crypto }
          .map { CurrencyModel(asset: $0) }
        self?.dataProvider.fetchPriceList { pricesResult in
          switch pricesResult {
          case .success(let pricesList):
            self?.priceList = pricesList
          case .failure:
            self?.logger?.log(.component(.trade(.priceDataError)))
          }
        }
      case .failure:
        self?.logger?.log(.component(.trade(.priceDataError)))
      }
    }
  }

  @objc
  func segmentedControlValueChanged(_ sender: UISegmentedControl) {
    guard let selectedIndex = TradeSegment(rawValue: sender.selectedSegmentIndex) else { return }
    self.segmentSelection.value = selectedIndex
  }

  @objc
  func didTapConversionSwitchButton() {
    shouldInputCrypto.value.toggle()
    updateConversion()
  }
}

extension TradeViewModel: UIPickerViewDelegate, UIPickerViewDataSource {
  public func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }

  public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return assetList.value.count
  }

  public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return assetList.value[row].asset.name
  }

  public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    cryptoCurrency.value = assetList.value[row]
    updateConversion()
  }
}

extension TradeViewModel: UITextFieldDelegate {
  public func textFieldDidChangeSelection(_ textField: UITextField) {
    guard self.amountText.value != textField.text else { return }
    let formattedInput = formatInputText(textField.text)
    amountText.value = formattedInput
    updateConversion()
    updateButtonState()
  }

  func updateConversion() {
    let formattedInput = formatInputText(amountText.value)
    amountText.value = formattedInput
    guard
      let inputText = (amountText.value?.filter { $0 != "." && $0 != "," }),
      isInputGreaterThanZero(inputText)
    else { return }
    displayAmount.value = formatAndConvert(amountText.value)
  }

  func updateButtonState() {
    var numberText: String?
    if shouldInputCrypto.value {
      numberText = displayAmount.value?
        .trimmingCharacters(in: CharacterSet(charactersIn: " " + fiatCurrency.asset.symbol + fiatCurrency.asset.code))
        .filter { $0 != "." && $0 != "," }
    } else {
      numberText = amountText.value?.filter { $0 != "." && $0 != "," }
    }
    ctaButtonEnabled.value = isInputGreaterThanZero(numberText ?? "")
  }

  func isInputGreaterThanZero(_ numberString: String) -> Bool {
    let inputPrecision = shouldInputCrypto.value ? (cryptoCurrency.value?.asset.decimals ?? 2) : fiatCurrency.asset.decimals
    if let bigDecimal = BigDecimal(numberString, precision: inputPrecision) {
      return bigDecimal.value > 0
    }
    return false
  }

  func formatInputText(_ inputText: String?) -> String? {
    guard
      let text = (inputText?.filter { $0 != "." && $0 != "," }),
      let bigInt = BigInt(text),
      isInputGreaterThanZero(text)
    else { return nil }
    var precision: Int = 2
    if shouldInputCrypto.value {
      guard let cryptoAsset = cryptoCurrency.value?.asset else { return nil }
      precision = cryptoAsset.decimals
    } else {
      precision = fiatCurrency.asset.decimals
    }
    return CybridCurrencyFormatter.formatInputNumber(BigDecimal(bigInt, precision: precision))
  }

  func formatAndConvert(_ amount: String?) -> String {
    let symbol = shouldInputCrypto.value ? fiatCurrency.asset.symbol : ""
    let code = shouldInputCrypto.value ? fiatCurrency.asset.code : (cryptoCurrency.value?.asset.code ?? "")

    guard
      let text = amount,
      let priceBigInt = selectedPriceRate,
      let cryptoAsset = cryptoCurrency.value?.asset,
      let amountBigInt = BigInt(text.filter { $0 != "." && $0 != "," })
    else {
      return (CybridCurrencyFormatter.formatPrice(BigDecimal(0), with: symbol) + " " + code)
        .trimmingCharacters(in: .whitespacesAndNewlines)
    }
    let originPrecision = shouldInputCrypto.value ? cryptoAsset.decimals : fiatCurrency.asset.decimals
    let targetPrecision = shouldInputCrypto.value ? fiatCurrency.asset.decimals : cryptoAsset.decimals
    let amountBigDecimal = BigDecimal(amountBigInt, precision: originPrecision)
    let priceRateBigDecimal = BigDecimal(priceBigInt, precision: fiatCurrency.asset.decimals)
    let conversionAmount = shouldInputCrypto.value
      ? BigDecimal.runOperation({
        try amountBigDecimal.multiply(with: priceRateBigDecimal, targetPrecision: targetPrecision)
      }, errorEvent: .component(.trade(.priceDataError)))
      : BigDecimal.runOperation({
        try amountBigDecimal.divide(by: priceRateBigDecimal, targetPrecision: targetPrecision)
      }, errorEvent: .component(.trade(.priceDataError)))
    return CybridCurrencyFormatter.formatPrice(conversionAmount, with: symbol) + " " + code
  }

  func createQuote() {
    // TODO: Replace with service call
    generatedQuoteModel.value = .init(
      fiatAmount: amountText.value ?? "",
      fiatCode: fiatCurrency.asset.code,
      cryptoAmount: displayAmount.value ?? "",
      cryptoCode: cryptoCurrency.value?.asset.code ?? "",
      transactionFee: "$2.59",
      quoteType: segmentSelection.value == .buy ? .buy : .sell
    )
  }

  func confirmOperation() {
    // TODO: Replace with service call
    tradeSuccessModel.value = .init(
      transactionId: "#980019", // FIXME: Remove mocked data
      date: "August 16, 2022", // FIXME: Remove mocked data
      fiatAmount: amountText.value ?? "",
      fiatCode: fiatCurrency.asset.code,
      cryptoAmount: displayAmount.value ?? "",
      cryptoCode: cryptoCurrency.value?.asset.code ?? "",
      transactionFee: "$2.59", // FIXME: Remove mocked data
      quoteType: segmentSelection.value == .buy ? .buy : .sell
    )
  }
}

extension TradeViewModel {
  struct CurrencyModel: Equatable {
    let asset: AssetBankModel
    let imageURL: String

    init(asset: AssetBankModel) {
      self.asset = asset
      self.imageURL = Cybrid.getCryptoIconURLString(with: asset.code)
    }
  }
}
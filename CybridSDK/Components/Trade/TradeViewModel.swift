//
//  TradeViewModel.swift
//  CybridSDK
//
//  Created by Cybrid on 16/08/22.
//

import BigInt
import CybridApiBankSwift

enum TradeType: Int {
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

  var sideBankModel: PostQuoteBankModel.SideBankModel {
    switch self {
    case .buy:
      return .buy
    case .sell:
      return.sell
    }
  }
}

final class TradeViewModel: NSObject {
  typealias DataProvider = AssetsRepoProvider & PricesRepoProvider & QuotesRepoProvider & TradesRepoProvider

  // MARK: Observed Properties
  internal var amountText: Observable<String?> = Observable(nil)
  internal var assetList: Observable<[CurrencyModel]>
  internal var cryptoCurrency: Observable<CurrencyModel?> // Asset
  internal var ctaButtonEnabled: Observable<Bool> = Observable(false)
  internal var displayAmount: Observable<String?> = Observable(nil)
  internal var segmentSelection: Observable<TradeType> = Observable(.buy)
  internal var shouldInputCrypto: Observable<Bool> = Observable(true)

  internal var generatedQuoteModel: Observable<TradeConfirmationModalView.DataModel?> = Observable(nil)
  internal var tradeSuccessModel: Observable<TradeSuccessModalView.DataModel?> = Observable(nil)
  internal var error: Observable<Error?> = Observable(nil)

  // MARK: Internal Properties
  internal let fiatCurrency: CurrencyModel // CounterAsset
  internal var priceFetchScheduler: TaskScheduler?
  internal var quoteFetchScheduler: TaskScheduler?

  // MARK: Computed properties
  internal var selectedPriceRate: BigInt? {
    guard let cryptoCode = cryptoCurrency.value?.asset.code else { return nil }
    let priceRate = priceList.first { $0.symbol?.contains(cryptoCode) ?? false }
    return BigInt(priceRate?.buyPrice ?? "0")
  }

  // MARK: Private Properties
  private let dataProvider: DataProvider
  private let logger: CybridLogger?
  private var priceList: [SymbolPriceBankModel] {
    didSet {
      updateConversion()
    }
  }
  private var quoteGUID: String?

  init(selectedCrypto: AssetBankModel,
       dataProvider: DataProvider,
       logger: CybridLogger?,
       priceScheduler: TaskScheduler? = nil,
       quoteScheduler: TaskScheduler? = nil) {
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
    self.priceFetchScheduler = priceScheduler ?? TaskScheduler()
    self.quoteFetchScheduler = quoteScheduler ?? TaskScheduler()
  }

  private func registerPriceScheduler() {
    if let scheduler = priceFetchScheduler {
      Cybrid.session.taskSchedulers.insert(scheduler)
    }
  }

  private func registerQuoteScheduler() {
    if let scheduler = quoteFetchScheduler {
      Cybrid.session.taskSchedulers.insert(scheduler)
    }
  }

  func fetchPriceList() {
    registerPriceScheduler()
    dataProvider.fetchAssetsList { [weak self] assetsResult in
      switch assetsResult {
      case .success(let assetList):
        self?.logger?.log(.component(.trade(.priceDataFetching)))
        self?.assetList.value = assetList
          .filter { $0.type == .crypto }
          .map { CurrencyModel(asset: $0) }
        guard
          let cryptoCode = self?.cryptoCurrency.value?.asset.code,
          let fiatCode = self?.fiatCurrency.asset.code
        else {
          self?.logger?.log(.component(.trade(.priceDataError)))
          return
        }
        let symbol = cryptoCode + "-" + fiatCode
        self?.dataProvider.fetchPriceList(symbol: symbol, with: self?.priceFetchScheduler) { pricesResult in
          switch pricesResult {
          case .success(let pricesList):
            self?.logger?.log(.component(.trade(.priceDataRefreshed)))
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

  func createQuote() {
    registerQuoteScheduler()
    logger?.log(.component(.trade(.quoteDataFetching)))
    guard
      let cryptoCode = cryptoCurrency.value?.asset.code,
      let inputText = (amountText.value?.filter { $0 != "." && $0 != "," && $0 != " " })
    else { return }
    let fiatCode = fiatCurrency.asset.code
    let symbol = cryptoCode + "-" + fiatCode
    var receiveAmount: String?
    var deliverAmount: String?

    switch segmentSelection.value {
    case .buy:
      if shouldInputCrypto.value {
        receiveAmount = inputText
      } else {
        deliverAmount = inputText
      }
    case .sell:
      if shouldInputCrypto.value {
        deliverAmount = inputText
      } else {
        receiveAmount = inputText
      }
    }

    let params = PostQuoteBankModel(
      customerGuid: Cybrid.customerGUID,
      symbol: symbol,
      side: segmentSelection.value.sideBankModel,
      receiveAmount: receiveAmount,
      deliverAmount: deliverAmount
    )
    dataProvider.createQuote(params: params, with: quoteFetchScheduler) { [weak self] result in
      guard let self = self else { return }
      switch result {
      case .success(let quoteModel):
        guard let newDataModel = self.createQuoteDataModel(with: quoteModel) else {
          self.logger?.log(.component(.trade(.quoteDataError)))
          return
        }
        self.logger?.log(.component(.trade(.quoteDataRefreshed)))
        self.generatedQuoteModel.value = newDataModel
        self.quoteGUID = newDataModel.quoteGUID
        self.error.value = nil
      case .failure(let error):
        self.logger?.log(.component(.trade(.quoteDataError)))
        self.error.value = error
      }
    }
  }

  func createQuoteDataModel(with quoteBankModel: QuoteBankModel) -> TradeConfirmationModalView.DataModel? {
    guard
      let guid = quoteBankModel.guid,
      let receiveAmount = quoteBankModel.receiveAmount,
      let deliverAmount = quoteBankModel.deliverAmount,
      let cryptoAsset = cryptoCurrency.value?.asset
    else {
      return nil
    }
    var cryptoAmount = BigInt(receiveAmount)
    var fiatAmount = BigInt(deliverAmount)
    switch segmentSelection.value {
    case .buy:
        cryptoAmount = BigInt(receiveAmount)
        fiatAmount = BigInt(deliverAmount)
    case .sell:
      cryptoAmount = BigInt(deliverAmount)
      fiatAmount = BigInt(receiveAmount)
    }
    let fiatCode = fiatCurrency.asset.code
      let fiatDecimal = BigDecimal(fiatAmount!, precision: fiatCurrency.asset.decimals)
    let formattedFiatAmount = CybridCurrencyFormatter.formatPrice(fiatDecimal, with: fiatCurrency.asset.symbol)
    let feeDecimal = BigDecimal(quoteBankModel.fee ?? "0", precision: fiatCurrency.asset.decimals)
      let formattedFeeAmount = CybridCurrencyFormatter.formatPrice(feeDecimal!, with: fiatCurrency.asset.symbol)
      let cryptoDecimal = BigDecimal(cryptoAmount!, precision: cryptoAsset.decimals)
    let formattedCryptoAmount = CybridCurrencyFormatter.formatPrice(cryptoDecimal, with: "")
    return .init(quoteGUID: guid,
                 fiatAmount: formattedFiatAmount,
                 fiatCode: fiatCode,
                 cryptoAmount: formattedCryptoAmount,
                 cryptoCode: cryptoAsset.code,
                 transactionFee: formattedFeeAmount,
                 quoteType: segmentSelection.value)
  }

  func confirmOperation() {
    guard let guid = quoteGUID else { return }

    self.logger?.log(.component(.trade(.tradeDataFetching)))
    dataProvider.createTrade(quoteGuid: guid) { [weak self] result in
      guard let self = self else { return }
      switch result {
      case .success(let tradeModel):
        guard let newDataModel = self.createTradeDataModel(with: tradeModel) else {
          self.logger?.log(.component(.trade(.tradeDataError)))
          return
        }
        self.logger?.log(.component(.trade(.tradeConfirmed)))
        self.tradeSuccessModel.value = newDataModel
        self.error.value = nil
      case .failure(let error):
        self.logger?.log(.component(.trade(.quoteDataError)))
        self.error.value = error
      }
    }
  }

  func createTradeDataModel(with tradeModel: TradeBankModel) -> TradeSuccessModalView.DataModel? {
    guard
      let guid = tradeModel.guid,
      let receiveAmount = tradeModel.receiveAmount,
      let deliverAmount = tradeModel.deliverAmount,
      let cryptoAsset = cryptoCurrency.value?.asset
    else {
      return nil
    }
    var cryptoAmount = BigInt(receiveAmount)
    var fiatAmount = BigInt(deliverAmount)
    switch segmentSelection.value {
    case .buy:
      cryptoAmount = BigInt(receiveAmount)
      fiatAmount = BigInt(deliverAmount)
    case .sell:
      cryptoAmount = BigInt(deliverAmount)
      fiatAmount = BigInt(receiveAmount)
    }
    let fiatCode = fiatCurrency.asset.code
      let fiatDecimal = BigDecimal(fiatAmount!, precision: fiatCurrency.asset.decimals)
    let formattedFiatAmount = CybridCurrencyFormatter.formatPrice(fiatDecimal, with: fiatCurrency.asset.symbol)
    let feeDecimal = BigDecimal(tradeModel.fee ?? "0", precision: fiatCurrency.asset.decimals)
      let formattedFeeAmount = CybridCurrencyFormatter.formatPrice(feeDecimal!, with: fiatCurrency.asset.symbol)
      let cryptoDecimal = BigDecimal(cryptoAmount!, precision: cryptoAsset.decimals)
    let formattedCryptoAmount = CybridCurrencyFormatter.formatPrice(cryptoDecimal, with: "")
    return .init(
      transactionId: guid,
      date: String(describing: tradeModel.createdAt),
      fiatAmount: formattedFiatAmount,
      fiatCode: fiatCode,
      cryptoAmount: formattedCryptoAmount,
      cryptoCode: cryptoAsset.code,
      transactionFee: formattedFeeAmount,
      quoteType: segmentSelection.value
    )
  }

  func stopPriceUpdate() {
    priceFetchScheduler?.cancel()
  }

  func stopQuoteUpdateIfNeeded() {
    quoteFetchScheduler?.cancel()
  }

  @objc
  func segmentedControlValueChanged(_ sender: UISegmentedControl) {
    guard let selectedIndex = TradeType(rawValue: sender.selectedSegmentIndex) else { return }
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

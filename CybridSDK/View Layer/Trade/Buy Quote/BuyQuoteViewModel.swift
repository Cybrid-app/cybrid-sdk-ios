//
//  BuyQuoteViewModel.swift
//  CybridSDK
//
//  Created by Cybrid on 5/08/22.
//

import BigInt
import CybridApiBankSwift
import Foundation

final class BuyQuoteViewModel: NSObject {
  // MARK: Internal Properties
  internal var amountText: Observable<String?> = Observable(nil)
  internal var displayAmount: Observable<String?> = Observable(nil)
  internal var shouldInputCrypto: Observable<Bool> = Observable(true)
  internal var ctaButtonEnabled: Observable<Bool> = Observable(false)
  internal var assetList: Observable<[CurrencyModel]>
  internal var cryptoCurrency: Observable<CurrencyModel?>
  internal let fiatCurrency: CurrencyModel

  internal var selectedPriceRate: BigInt? {
    guard let cryptoCode = cryptoCurrency.value?.asset.code else { return nil }
    let priceRate = priceList.first { $0.symbol?.contains(cryptoCode) ?? false }
    return priceRate?.buyPrice
  }

  // MARK: Private Properties
  private let dataProvider: AssetsRepoProvider & PricesRepoProvider
  private var priceList: [SymbolPriceBankModel] {
    didSet {
      updateConversion()
    }
  }

  init(dataProvider: AssetsRepoProvider & PricesRepoProvider,
       fiatAsset: AssetBankModel,
       priceList: [SymbolPriceBankModel]? = nil) {
    self.dataProvider = dataProvider
    self.fiatCurrency = CurrencyModel(asset: fiatAsset)
    self.assetList = Observable([])
    self.priceList = priceList ?? []
    self.cryptoCurrency = Observable(nil)
    cryptoCurrency.value = assetList.value.first
  }

  func fetchPriceList() {
    dataProvider.fetchAssetsList { [weak self] assetsResult in
      switch assetsResult {
      case .success(let assetList):
        self?.assetList.value = assetList
          .filter { $0.type == .crypto }
          .map { CurrencyModel(asset: $0) }
        self?.cryptoCurrency.value = self?.assetList.value.first
        self?.dataProvider.fetchPriceList { pricesResult in
          switch pricesResult {
          case .success(let pricesList):
            self?.priceList = pricesList
          case .failure(let error):
            self?.handleError(error)
          }
        }
      case .failure(let error):
        self?.handleError(error)
      }
    }
  }

  func handleError(_ error: Error) {
    print(error)
  }

  func switchConversion() {
    shouldInputCrypto.value.toggle()
    updateConversion()
  }
}

extension BuyQuoteViewModel: UIPickerViewDelegate, UIPickerViewDataSource {
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }

  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return assetList.value.count
  }

  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return assetList.value[row].asset.name
  }

  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    cryptoCurrency.value = assetList.value[row]
    updateConversion()
  }
}

extension BuyQuoteViewModel: UITextFieldDelegate {
  func textFieldDidChangeSelection(_ textField: UITextField) {
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
      }, with: handleError(_:))
      : BigDecimal.runOperation({
        try amountBigDecimal.divide(by: priceRateBigDecimal, targetPrecision: targetPrecision)
      }, with: handleError(_:))
    return CybridCurrencyFormatter.formatPrice(conversionAmount, with: symbol) + " " + code
  }
}

extension BuyQuoteViewModel {
  struct CurrencyModel {
    let asset: AssetBankModel
    let imageURL: String

    init(asset: AssetBankModel) {
      self.asset = asset
      self.imageURL = Cybrid.getCryptoIconURLString(with: asset.code)
    }
  }
}

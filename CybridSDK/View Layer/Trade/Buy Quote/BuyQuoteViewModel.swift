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

  // MARK: Private Properties
  private let dataProvider: AssetsRepoProvider & PricesRepoProvider
  private var priceList: [SymbolPriceBankModel] {
    didSet {
      updateConversion()
    }
  }

  private var selectedPriceRate: BigInt? {
    guard let cryptoCode = cryptoCurrency.value?.asset.code else { return nil }
    let priceRate = priceList.first { $0.symbol?.contains(cryptoCode) ?? false }
    return priceRate?.buyPrice
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
            print(error)
          }
        }
      case .failure(let error):
        print(error)
      }
    }
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
    displayAmount.value = formatDisplayAmount(amountText.value)
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
    if let bigDecimal = BigDecimal(numberString, precision: self.cryptoCurrency.value?.asset.decimals ?? 2) {
      return bigDecimal.value > 0
    } else {
      return false
    }
  }

  func formatInputText(_ inputText: String?) -> String? {
    guard
      let text = (inputText?.filter { $0 != "." && $0 != "," }),
      isInputGreaterThanZero(text)
    else { return nil }
    var precision: Int = 2
    if shouldInputCrypto.value {
      precision = cryptoCurrency.value?.asset.decimals ?? 2
    } else {
      precision = fiatCurrency.asset.decimals
    }
    guard let resultDecimal = BigDecimal(text, precision: precision) else { return nil }
    return CybridCurrencyFormatter.formatInputNumber(resultDecimal)
  }

  func formatDisplayAmount(_ amount: String?) -> String {
    let fiatSymbol = fiatCurrency.asset.symbol
    let fiatCode = fiatCurrency.asset.code
    let fiatPrecision = fiatCurrency.asset.decimals

    guard let crypto = cryptoCurrency.value else {
      return CybridCurrencyFormatter.formatPrice(BigDecimal(0), with: fiatSymbol) + " " + fiatCode
    }

    let cryptoCode = crypto.asset.code
    let cryptoPrecision = crypto.asset.decimals

    if shouldInputCrypto.value {
      guard
        let text = amount,
        let priceBigInt = selectedPriceRate,
        let amountBigDecimal = BigDecimal((text.filter { $0 != "." && $0 != "," }), precision: cryptoPrecision)
      else {
        return CybridCurrencyFormatter.formatPrice(BigDecimal(0), with: fiatSymbol) + " " + fiatCode
      }
      let priceRateBigDecimal = BigDecimal(priceBigInt, precision: fiatPrecision)
      let conversionAmount = amountBigDecimal.multiply(with: priceRateBigDecimal, targetPrecision: fiatPrecision)

      return CybridCurrencyFormatter.formatPrice(conversionAmount, with: fiatSymbol) + " " + fiatCode
    } else {
      guard
        let text = amount,
        let priceBigInt = selectedPriceRate,
        let amountBigDecimal = BigDecimal((text.filter { $0 != "." && $0 != "," }), precision: fiatPrecision)
      else {
        return CybridCurrencyFormatter.formatPrice(BigDecimal(0), with: "") + " \(cryptoCode)"
      }
      let priceRateBigDecimal = BigDecimal(priceBigInt, precision: fiatCurrency.asset.decimals)
      let conversionAmount = amountBigDecimal.divide(by: priceRateBigDecimal, targetPrecision: cryptoPrecision)

      return CybridCurrencyFormatter.formatPrice(conversionAmount, with: "") + " \(cryptoCode)"
    }
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

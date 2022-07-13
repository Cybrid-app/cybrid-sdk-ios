//
//  CurrencyListDataProviderMock.swift
//  CybridSDKTests
//
//  Created by Cybrid on 13/07/22.
//

import CybridApiBankSwift
@testable import CybridSDK

class CurrencyListDataProviderMock: SymbolsDataProvider {
  var listSymbolsService: SymbolsAPI.Type = SymbolsAPIMock.self

  private var symbolsFetchCompletion: FetchSymbolsCompletion?

  func fetchAvailableSymbols(_ completion: @escaping FetchSymbolsCompletion) {
    listSymbolsService.listSymbols(apiResponseQueue: DispatchQueue(label: "MockQueue"), completion: completion)
  }

  func didFetchSymbolsSuccessfuly() {
    SymbolsAPIMock.didFetchSymbolsSuccessfully()
  }

  func didFetchSymbolsWithError() {
    SymbolsAPIMock.didFetchSymbolsWithErrors()
  }
}

// MARK: - Mock Data

extension Array where Element == String {
  static let mockSymbols: Self = [
    "BTC-USD",
    "ETH-USD"
  ]
}

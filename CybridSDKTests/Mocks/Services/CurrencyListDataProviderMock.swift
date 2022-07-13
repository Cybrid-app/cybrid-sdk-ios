//
//  CurrencyListDataProviderMock.swift
//  CybridSDKTests
//
//  Created by Cybrid on 13/07/22.
//

@testable import CybridSDK

class CurrencyListDataProviderMock: SymbolsDataProvider {
  private var symbolsFetchCompletion: FetchSymbolsCompletion?

  func fetchAvailableSymbols(_ completion: @escaping FetchSymbolsCompletion) {
    symbolsFetchCompletion = completion
  }

  func didFetchSymbolsSuccessfuly() {
    symbolsFetchCompletion?(.success(.mockSymbols))
  }

  func didFetchSymbolsWithError() {
    symbolsFetchCompletion?(.failure(CybridError.serviceError))
  }
}

// MARK: - Mock Data

extension Array where Element == String {
  static let mockSymbols: Self = [
    "BTC-USD",
    "ETH-USD"
  ]
}

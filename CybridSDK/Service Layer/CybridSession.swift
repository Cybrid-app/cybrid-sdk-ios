//
//  CybridSession.swift
//  CybridSDK
//
//  Created by Cybrid on 8/07/22.
//

import CybridApiBankSwift
import Foundation

final class CybridSession: AuthenticatedServiceProvider {
  // MARK: Static Properties
  static var current = CybridSession(authenticator: Cybrid.authenticator, apiManager: CybridApiBankSwiftAPI.self)

  // MARK: Internal Properties
  // Assets Repository
  internal var assetsRepository: AssetsRepository.Type
  internal var assetsCache: [AssetBankModel]?

  // Prices Repository
  internal var pricesRepository: PricesRepository.Type
  internal var pricesFetchScheduler: TaskScheduler

  // MARK: Private Properties
  private(set) var authenticator: CybridAuthenticator?
  private(set) var apiManager: CybridAPIManager.Type

  // MARK: Initializer
  init(authenticator: CybridAuthenticator?, apiManager: CybridAPIManager.Type) {
    self.authenticator = authenticator
    self.apiManager = apiManager
    self.pricesRepository = PricesAPI.self
    self.assetsRepository = AssetsAPI.self
    self.pricesFetchScheduler = CybridTaskScheduler()
  }
}

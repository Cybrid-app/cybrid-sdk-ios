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
  static var current = CybridSession(authenticator: Cybrid.authenticator,
                                     apiManager: CybridApiBankSwiftAPI.self,
                                     notificationManager: NotificationCenter.default)
  static let appMovedToBackgroundEvent = UIApplication.willResignActiveNotification
  static let appMovedToForegroundEvent = UIApplication.didBecomeActiveNotification

  // MARK: Internal Properties
  // Assets Repository
  internal var assetsRepository: AssetsRepository.Type
  internal var assetsCache: [AssetBankModel]?

  // Prices Repository
  internal var pricesRepository: PricesRepository.Type
  internal var pricesFetchScheduler: TaskScheduler

  // Quotes Repository
  internal var quotesRepository: QuotesRepository.Type

  // Trades Repository
  internal var tradesRepository: TradesRepository.Type

  // MARK: Private(set) Internal Properties
  private(set) var authenticator: CybridAuthenticator?
  private(set) var apiManager: CybridAPIManager.Type
  private(set) var notificationManager: NotificationManager
  private(set) var isListeningToAppEvents = false

  // MARK: Initializer
  init(authenticator: CybridAuthenticator?,
       apiManager: CybridAPIManager.Type,
       notificationManager: NotificationManager) {
    self.authenticator = authenticator
    self.apiManager = apiManager
    self.notificationManager = notificationManager
    self.pricesRepository = PricesAPI.self
    self.assetsRepository = AssetsAPI.self
    self.pricesFetchScheduler = CybridTaskScheduler()
    self.quotesRepository = QuotesAPI.self
    self.tradesRepository = TradesAPI.self

    setupEventListeners()
  }

  func setupEventListeners() {
    notificationManager.removeObserver(self)
    notificationManager.addObserver(self,
                                    selector: #selector(appMovedToBackground),
                                    name: CybridSession.appMovedToBackgroundEvent,
                                    object: nil)
    notificationManager.addObserver(self,
                                    selector: #selector(appMovedToForeground),
                                    name: CybridSession.appMovedToForegroundEvent,
                                    object: nil)
    isListeningToAppEvents = true
  }

  func stopListeners() {
    notificationManager.removeObserver(self)
    isListeningToAppEvents = false
  }

  @objc
  func appMovedToBackground() {
    pricesFetchScheduler.pause()
  }

  @objc
  func appMovedToForeground() {
    pricesFetchScheduler.resume()
  }
}

protocol NotificationManager {
  func addObserver(_ observer: Any, selector: Selector, name: NSNotification.Name?, object: Any?)
  func removeObserver(_ observer: Any)
  func post(name: NSNotification.Name, object: Any?, userInfo: [AnyHashable: Any]?)
}

extension NotificationCenter: NotificationManager {}

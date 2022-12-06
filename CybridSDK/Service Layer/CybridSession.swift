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
    static var current = CybridSession(apiManager: CybridApiBankSwiftAPI.self,
                                       notificationManager: NotificationCenter.default)
    static let appMovedToBackgroundEvent = UIApplication.willResignActiveNotification
    static let appMovedToForegroundEvent = UIApplication.didBecomeActiveNotification

    // MARK: Internal Properties
    // Assets Repository
    internal var assetsRepository: AssetsRepository.Type
    internal var assetsCache: [AssetBankModel]?

    // Prices Repository
    internal var pricesRepository: PricesRepository.Type

    // Quotes Repository
    internal var quotesRepository: QuotesRepository.Type

    // Trades Repository
    internal var tradesRepository: TradesRepository.Type

    // Accounts Repository
    internal var accountsRepository: AccountsRepository.Type

    // Customers Repository
    internal var customersRepository: CustomersRepository.Type

    // Identity Verification Repository
    internal var identityVerificationRepository: IdentityVerificationRepository.Type

    // Worflows Repository
    internal var workflowRepository: WorkflowRepository.Type

    // Schedulers
    internal var taskSchedulers: Set<TaskScheduler> = []

    // MARK: Private(set) Internal Properties
    private(set) var apiManager: CybridAPIManager.Type
    private(set) var notificationManager: NotificationManager
    private(set) var isListeningToAppEvents = false

    // MARK: Initializer
    init(apiManager: CybridAPIManager.Type,
         notificationManager: NotificationManager) {

        self.apiManager = apiManager
        self.notificationManager = notificationManager
        self.pricesRepository = PricesAPI.self
        self.assetsRepository = AssetsAPI.self
        self.quotesRepository = QuotesAPI.self
        self.tradesRepository = TradesAPI.self
        self.accountsRepository = AccountsAPI.self
        self.customersRepository = CustomersAPI.self
        self.identityVerificationRepository = IdentityVerificationsAPI.self
        self.workflowRepository = WorkflowsAPI.self

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

        taskSchedulers.forEach { scheduler in
            scheduler.pause()
        }
    }

    @objc
    func appMovedToForeground() {

        taskSchedulers.forEach { scheduler in
            scheduler.resume()
        }
    }
}

protocol NotificationManager {

    func addObserver(_ observer: Any, selector: Selector, name: NSNotification.Name?, object: Any?)
    func removeObserver(_ observer: Any)
    func post(name: NSNotification.Name, object: Any?, userInfo: [AnyHashable: Any]?)
}

extension NotificationCenter: NotificationManager {}

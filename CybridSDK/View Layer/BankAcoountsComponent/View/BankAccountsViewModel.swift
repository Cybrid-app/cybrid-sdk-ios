//
//  BankAccountsViewModel.swift
//  CybridSDK
//
//  Created by Erick Sanchez Perez on 02/12/22.
//

import Foundation
import CybridApiBankSwift

class BankAccountsViewModel: NSObject {

    // MARK: Private properties
    private var dataProvider: WorkflowProvider
    private var logger: CybridLogger?

    private let plaidCustomizationName = "default"
    private let androidPackageName = "app.cybrid.sdkandroid"
    private let defaultAssetCurrency = "USD"

    // MARK: Internal properties
    internal var workflowJob: Polling?
    internal var customerGuid = Cybrid.customerGUID

    // MARK: Public properties
    var uiState: Observable<BankAccountsViewcontroller.BankAccountsViewState> = .init(.LOADING)
    var latestWorkflow: WorkflowWithDetailsBankModel?

    // MARK: Constructor
    init(dataProvider: WorkflowProvider,
         UIState: Observable<BankAccountsViewcontroller.BankAccountsViewState>,
         logger: CybridLogger?) {

        self.dataProvider = dataProvider
        self.uiState = UIState
        self.logger = logger
    }

    // MARK: ViewModel Methods
    
}

//
//  ExternalWalletsViewModel.swift
//  CybridSDK
//
//  Created by Erick Sanchez on 17/08/23.
//

import CybridApiBankSwift

open class ExternalWalletsViewModel: NSObject {

    // MARK: Private properties
    // private var dataProvider: DepositAddressRepoProvider
    private var logger: CybridLogger?

    // MARK: Internal properties
    internal var customerGuig = Cybrid.customerGuid

    // MARK: Public properties
    var uiState: Observable<ExternalWalletsView.State> = .init(.LOADING)

    // MARK: Constructor
    init(/*dataProvider: DepositAddressRepoProvider,*/
         logger: CybridLogger?) {

        // self.dataProvider = dataProvider
        self.logger = logger
    }
}

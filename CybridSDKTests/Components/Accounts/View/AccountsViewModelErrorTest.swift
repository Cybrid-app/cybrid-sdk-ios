//
//  AccountsViewModelTestError.swift
//  CybridSDKTests
//
//  Created by Erick Sanchez Perez on 07/03/23.
//

import CybridApiBankSwift
@testable import CybridSDK
import XCTest

class AccountsViewModelErrorTest: XCTestCase {
    
    lazy var dataProvider = ServiceProviderMock()
    
    func createViewModel() -> AccountsViewModel {
        
        return AccountsViewModel(
            cellProvider: AccountsMockViewProvider(),
            dataProvider: self.dataProvider,
            logger: nil,
            currency: "USD")
    }
    
    func test_getAssetsList_Error() async {

        // -- Given
        let viewModel = AccountsViewModel(
            cellProvider: AccountsMockViewProvider(),
            dataProvider: self.dataProvider,
            logger: nil,
            currency: "USD")

        // -- When
        let assets = await viewModel.getAssetsList()
        dataProvider.didFetchAssetsWithError()

        // -- Then
        XCTAssertEqual(assets, [])
    }
}

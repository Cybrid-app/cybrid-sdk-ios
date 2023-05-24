//
//  AccountsFlow.swift
//  CybridSDKTestAppUITests
//
//  Created by Erick Sanchez Perez on 22/05/23.
//

import Foundation
import XCTest

class AccountsFlow: CybridUITest {
    
    func get_Accounts() -> AccountsWrapper {
        
        // -- Accounts Wrapper object
        var accountsWrapper = AccountsWrapper()
        
        // -- Check and tap Transfer Component
        let transferComponent = app.staticTexts["Accounts Component"]
        if transferComponent.waitForExistence(timeout: 6) {
            XCTAssertTrue(transferComponent.exists)
            transferComponent.tap()
        }
        
        // -- Check: From Bank Account
        let accountValueTitle = app.staticTexts["Account Value"]
        if accountValueTitle.waitForExistence(timeout: 6) {
            XCTAssertTrue(accountValueTitle.exists)
        }
        
        // -- Get total balance of the account
        let balanceValueTitle = app.staticTexts["AccountsAcomponent_Content_Balance_Value_Label"]
        XCTAssertTrue(accountValueTitle.exists)
        accountsWrapper.accountsTotalBalance = balanceValueTitle.label
        
        // -- Getting the table
        let accountsTable = app.tables["AccountsAcomponent_Content_Table"]
        XCTAssertTrue(accountsTable.exists)
        
        // -- Check: Table header ()
        let tableHeaderAsset = accountsTable.staticTexts["ASSET"]
        XCTAssertTrue(tableHeaderAsset.exists)
        
        let tableHeaderBalance = accountsTable.staticTexts["BALANCE"]
        XCTAssertTrue(tableHeaderBalance.exists)
        
        let tableHeaderMarketPrice = accountsTable.staticTexts["Market Price"]
        XCTAssertTrue(tableHeaderMarketPrice.exists)
        
        let tableHeaderUSD = accountsTable.staticTexts["USD"]
        XCTAssertTrue(tableHeaderUSD.exists)
        
        // -- Getting assets
        let accountsList = accountsTable.cells
        accountsWrapper.accounts = accountsList
        
        // -- Return object
        return accountsWrapper
    }
    
    func check_accounts(accountsWrapper: AccountsWrapper) {
        
        var accountsSize = (accountsWrapper.accounts?.count ?? 0)
        if accountsSize != 0 { accountsSize -= 1 }
        
        // -- Iterate over accounts
        for i in 0...accountsSize {
            
            let accountCell = accountsWrapper.accounts?.element(boundBy: i)
            XCTAssertTrue(((accountCell?.exists) != nil))
            accountCell?.tap()
            returnTap()
        }
    }
    
    func test_flow() {
        
        // -- App launch
        app.launch()
        
        // -- Login
        self.login()
        
        // -- Getting the accounts wrapper
        let accountsWrapper = self.get_Accounts()
        
        // -- Iterate over accounts and check one by one
        self.check_accounts(accountsWrapper: accountsWrapper)
    }
}

struct AccountsWrapper {
    
    var accountsTotalBalance: String = ""
    var accounts: XCUIElementQuery? = nil
}

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

        let fiatNames: [String] = ["United States Dollar USD"]

        var totalBalanceCalculated: Double = 0
        var accountsSize = (accountsWrapper.accounts?.count ?? 0)
        if accountsSize != 0 { accountsSize -= 1 }

        // -- Iterate over accounts
        for index in 0...accountsSize {

            let accountCell = accountsWrapper.accounts?.element(boundBy: index)
            XCTAssertTrue(((accountCell?.exists) != nil))
            if accountCell?.exists ?? false {

                // -- Var only for crypto balance
                var cryptoBalance = ""

                // -- Logic for balance in fiat and crypto
                var dynamicAccessibilityIdentifier = ""
                let cellAssetName = accountCell?.staticTexts["AccountsComponent_Content_Table_Item_Name"].label ?? ""
                if fiatNames.contains(cellAssetName) {
                    dynamicAccessibilityIdentifier = "AccountsComponent_Content_Table_Item_Balance"
                } else {
                    cryptoBalance = accountCell?.staticTexts["AccountsComponent_Content_Table_Item_Balance"].label ?? ""
                    dynamicAccessibilityIdentifier = "AccountsComponent_Content_Table_Item_FiatBalance"
                }

                // -- Check the balance and add to totalBalance
                let itemBalance = accountCell?.staticTexts[dynamicAccessibilityIdentifier]
                let itemBalanceValue = (itemBalance?.label ?? "0.0").replacingOccurrences(of: "$", with: "")
                let itemBalanceValueDouble = Double(itemBalanceValue) ?? 0
                totalBalanceCalculated += itemBalanceValueDouble

                // -- Enter into the account
                accountCell?.tap()

                // -- Check items
                if dynamicAccessibilityIdentifier == "AccountsComponent_Content_Table_Item_Balance" {

                    // -- Name
                    let nameParts = cellAssetName.components(separatedBy: " ")
                    let name = nameParts[0]
                    let code = (nameParts.count > 2) ? nameParts[nameParts.count - 1] : nameParts[1]
                    let detailName = app.staticTexts[name]
                    if detailName.waitForExistence(timeout: 4) {
                        XCTAssertTrue(detailName.exists)
                    }

                    // -- Balance
                    let itemBalanceValueWithCode = "$\(itemBalanceValue) \(code)"
                    let detailBalance = app.staticTexts[itemBalanceValueWithCode]
                    XCTAssertTrue(detailBalance.exists)

                } else {

                    // -- Name
                    let nameParts = cellAssetName.components(separatedBy: " ")
                    let name = nameParts[0]
                    let code = (nameParts.count > 2) ? nameParts[nameParts.count - 1] : nameParts[1]
                    let detailName = app.staticTexts[name]
                    if detailName.waitForExistence(timeout: 4) {
                        XCTAssertTrue(detailName.exists)
                    }

                    // -- Crypto Balance
                    let itemBalanceValueWithCode = cryptoBalance + " " + code
                    print(itemBalanceValueWithCode)
                    let detailCrpytoBalance = app.staticTexts["AccountsComponent_Trades_Balance_Title"]
                    XCTAssertTrue(detailCrpytoBalance.exists)
                    XCTAssertEqual(detailCrpytoBalance.label, itemBalanceValueWithCode)

                    // -- Fiat Balance
                    let itemFiatBalanceValueWithCode = "$" + itemBalanceValue + " USD"
                    let detailFiatBalance = app.staticTexts[itemFiatBalanceValueWithCode]
                    XCTAssertTrue(detailFiatBalance.exists)
                }

                // -- Return
                returnTap()
            }
        }

        // -- Check total balance
        let totalBalanceString = String(format: "$%.2f USD", totalBalanceCalculated)
        XCTAssertEqual(totalBalanceString, accountsWrapper.accountsTotalBalance)
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
    var accounts: XCUIElementQuery?
}

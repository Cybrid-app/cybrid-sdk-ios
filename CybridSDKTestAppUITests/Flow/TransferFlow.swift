//
//  TransferFlow.swift
//  CybridSDKTestAppUITests
//
//  Created by Erick Sanchez Perez on 15/05/23.
//

import Foundation
import XCTest

class TransferFlow: CybridUITest {
    
    func depositFunds(funds: Int, fundsFormatted: String) -> TransferMade {
        
        // -- Transfer Object
        var transfer = TransferMade()
        
        // -- Check and tap Transfer Component
        let transferComponent = app.staticTexts["Transfer Component"]
        if transferComponent.waitForExistence(timeout: 6) {
            transferComponent.tap()
        }
        
        // -- Check UISegmentedControl (Deposit)
        let deposit = app.buttons["Deposit"]
        if deposit.waitForExistence(timeout: 2) {
            
            XCTAssertTrue(deposit.exists)
            XCTAssertTrue(app.buttons["Withdraw"].exists)
            let segmented = app.segmentedControls.element(boundBy: 0)
            XCTAssertTrue(segmented.buttons.element(boundBy: 0).isSelected)
        }
        
        // -- Check: From Bank Account
        let fromBankAccountLabel = app.staticTexts["From Bank Account"]
        XCTAssertTrue(fromBankAccountLabel.exists)

        // -- Check and get: Account Field
        let accountField = app.textFields["TransferComponent_AccountField"]
        XCTAssertTrue(accountField.exists)
        transfer.accountName = accountField.value as! String
        
        // -- Check: Amount
        let amountLabel = app.staticTexts["Amount"]
        XCTAssertTrue(amountLabel.exists)
        
        // -- Check, tap and set: Amount Field
        let amountField = app.textFields["TransferComponent_AmountField"]
        if amountField.waitForExistence(timeout: 6) {
            tapElementAndWaitForKeyboardToAppear(amountField)
            amountField.typeText(String(funds))
        }
        
        // -- Continue button
        let continueButton = app.buttons["Continue"]
        XCTAssertTrue(continueButton.exists)
        continueButton.tap()
        
        
        // -- Transfer Modal: Confirm
        
        // -- Title
        let confirmTitle = app.staticTexts["Confirm Deposit Details"]
        if confirmTitle.waitForExistence(timeout: 4) {
            XCTAssertTrue(confirmTitle.exists)
        }
        
        // -- Amount Value
        let amountValue = app.staticTexts[fundsFormatted]
        XCTAssertTrue(amountValue.exists)
        
        // -- Deposit Date
        let depositDate = app.staticTexts["Deposit Date"]
        XCTAssertTrue(depositDate.exists)
        
        // -- Deposit Date Value
        let depositDateValue = app.staticTexts["TransferComponent_Modal_Confirm_DateValue"]
        XCTAssertTrue(depositDateValue.exists)
        transfer.accountDate = depositDateValue.label
        
        // -- From
        let from = app.staticTexts["From"]
        XCTAssertTrue(from.exists)
        
        // -- From Value
        let fromValue = app.staticTexts[transfer.accountName]
        XCTAssertTrue(fromValue.exists)
        
        // -- Confirm deposit
        let confirmDeposit = app.buttons["Confirm Deposit"]
        if confirmDeposit.waitForExistence(timeout: 2) {
            confirmDeposit.tap()
        }
        
        
        // -- Transfer Modal: Details
        
        // -- Funds
        let fundsTitle = app.staticTexts[fundsFormatted]
        if fundsTitle.waitForExistence(timeout: 6) {
            XCTAssertTrue(fundsTitle.exists)
        }
        
        // -- Title
        let detailsTitle = app.staticTexts["Transfer submitted"]
        if detailsTitle.waitForExistence(timeout: 6) {
            XCTAssertTrue(detailsTitle.exists)
        }
        
        // -- Continue
        let continueButton_2 = app.buttons["TransferComponent_Modal_Details_Continue"]
        continueButton_2.tap()
        
        // -- Return main controller
        transfer.fundsFormatted = fundsFormatted
        self.returnTap()
        
        // -- Return transfer made
        return transfer
    }
    
    func withdrawFunds(funds: Int, transfer: TransferMade) {
        
        // -- Check and tap Transfer Component
        let transferComponent = app.staticTexts["Transfer Component"]
        if transferComponent.waitForExistence(timeout: 6) {
            transferComponent.tap()
        }
        
        // -- Check UISegmentedControl (Withdraw)
        let withdraw = app.buttons["Withdraw"]
        if withdraw.waitForExistence(timeout: 2) {
            
            XCTAssertTrue(withdraw.exists)
            XCTAssertTrue(app.buttons["Deposit"].exists)
            withdraw.tap()
        }
        let segmented = app.segmentedControls.element(boundBy: 0)
        XCTAssertTrue(segmented.buttons.element(boundBy: 1).isSelected)
        
        // -- Check: From Bank Account
        let toBankAccountLabel = app.staticTexts["To Bank Account"]
        XCTAssertTrue(toBankAccountLabel.exists)

        // -- Check and get: Account Field
        let accountField = app.textFields["TransferComponent_AccountField"]
        XCTAssertTrue(accountField.exists)
        XCTAssertTrue(accountField.value != nil)
        
        // -- Check: Amount
        let amountLabel = app.staticTexts["Amount"]
        XCTAssertTrue(amountLabel.exists)
        
        // -- Check, tap and set: Amount Field
        let amountField = app.textFields["TransferComponent_AmountField"]
        if amountField.waitForExistence(timeout: 6) {
            tapElementAndWaitForKeyboardToAppear(amountField)
            amountField.typeText(String(funds))
        }
        
        // -- Continue button
        let continueButton = app.buttons["Continue"]
        XCTAssertTrue(continueButton.exists)
        continueButton.tap()
        
        
        // -- Transfer Modal: Confirm
        
        // -- Title
        let confirmTitle = app.staticTexts["Confirm Withdraw Details"]
        if confirmTitle.waitForExistence(timeout: 4) {
            XCTAssertTrue(confirmTitle.exists)
        }
        
        // -- Amount Value
        let amountValue = app.staticTexts[transfer.fundsFormatted]
        XCTAssertTrue(amountValue.exists)
        
        // -- Withdraw Date
        let depositDate = app.staticTexts["Withdraw Date"]
        XCTAssertTrue(depositDate.exists)
        
        // -- Withdraw Date Value
        let depositDateValue = app.staticTexts["TransferComponent_Modal_Confirm_DateValue"]
        XCTAssertTrue(depositDateValue.exists)
        
        // -- To
        let to = app.staticTexts["To"]
        XCTAssertTrue(to.exists)
        
        // -- To Value
        let toValue = app.staticTexts[transfer.accountName]
        XCTAssertTrue(toValue.exists)
        
        // -- Confirm Withdraw
        let confirmWithdraw = app.buttons["Confirm Withdraw"]
        if confirmWithdraw.waitForExistence(timeout: 2) {
            confirmWithdraw.tap()
        }
        
        
        // -- Transfer Modal: Details
        
        // -- Funds
        /*let fundsTitle = app.staticTexts[fundsFormatted]
        if fundsTitle.waitForExistence(timeout: 6) {
            XCTAssertTrue(fundsTitle.exists)
        }
        
        // -- Title
        let detailsTitle = app.staticTexts["Transfer submitted"]
        if detailsTitle.waitForExistence(timeout: 6) {
            XCTAssertTrue(detailsTitle.exists)
        }
        
        // -- Continue
        let continueButton_2 = app.buttons["TransferComponent_Modal_Details_Continue"]
        continueButton_2.tap()*/
        
        // -- Return main controller
        self.returnTap()
    }
    
    func checkDepositOrWithdraw(transfer: TransferMade, type: TransferFlowType) {
        
        // -- Check and tap Accounts Component
        let accountsComponent = app.staticTexts["Accounts Component"]
        if accountsComponent.waitForExistence(timeout: 6) {
            accountsComponent.tap()
        }
        
        // -- Tap over USD
        let usd = app.staticTexts["United States Dollar USD"]
        if usd.waitForExistence(timeout: 6) {
            XCTAssertTrue(usd.exists)
        }
        usd.tap()
        
        // -- Transfers Component
        
        // -- Title
        let assetTitle = app.staticTexts["United States Dollar"]
        if assetTitle.waitForExistence(timeout: 6) {
            XCTAssertTrue(assetTitle.exists)
        }
        
        // -- Find the first cell in table
        let firstCell = app.tables.cells.element(boundBy: 0)
        
        // -- Cell: Type
        let cellType = firstCell.staticTexts[type.rawValue]
        XCTAssertTrue(cellType.exists)
        
        // -- Cell: Date
        let cellDate = firstCell.staticTexts[transfer.accountDate]
        XCTAssertTrue(cellDate.exists)
        
        // -- Cell: Amount
        let cellAmount = firstCell.staticTexts[transfer.fundsFormatted]
        XCTAssertTrue(cellAmount.exists)
        
        // -- Return main controller
        self.returnTap()
    }
    
    func test_flow() {
        
        // -- Get ramdom number to be founds
        let randomFunds = Int.random(in: 10..<51)
        
        // -- Set random funds number in format
        let fundsFormatted = "$\(randomFunds).00 USD"
        
        // -- App launch
        app.launch()
        
        // -- Login
        self.login()
        
        // -- Deposit funds and get transfer
        let transfer = self.depositFunds(funds: randomFunds, fundsFormatted: fundsFormatted)
        
        // -- Check deposit in Accounts
        self.checkDepositOrWithdraw(transfer: transfer, type: .deposit)
    }
}

struct TransferMade {
    
    var accountName: String = ""
    var accountDate: String = ""
    var fundsFormatted: String = ""
}

enum TransferFlowType: String {
    
    case deposit = "Deposit"
    case withdraw = "Withdraw"
}

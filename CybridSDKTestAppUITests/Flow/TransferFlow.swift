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
        
        // -- Check UISegmentedControl (Buy)
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
        
        // -- Return transfer made
        return transfer
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
    }
}

struct TransferMade {
    
    var accountName: String = ""
    var accountDate: String = ""
}

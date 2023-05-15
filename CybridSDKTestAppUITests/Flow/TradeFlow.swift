//
//  TradeFlow.swift
//  CybridSDKTestAppUITests
//
//  Created by Erick Sanchez Perez on 05/05/23.
//
//  This flow allow:
//  - Login
//  - Add EXternal Account
//  - Transfer 50 USD
//  - Buy 50 USD of BTC
//

import Foundation
import XCTest

class TradeFlow: XCTestCase {
    
    let app = XCUIApplication()
    
    func returnTap() {
        
        app.navigationBars.buttons.element(boundBy: 0).tap()
    }
    
    func getAsset(_ assetCode: String) -> String {
        
        var asset = ""
        switch assetCode {
            
        case "BTC":
            asset = "Bitcoin BTC"
            
        case "ETH":
            asset = "Ethereum ETH"
            
        case "USDC":
            asset = "USDC (ERC-20) USDC"
            
        case "SOL":
            asset = "Solana SOL"
            
        default:
            ()
        }
        return asset
    }
    
    func login() {
        
        // -- Given
        let demoMode = app.buttons["demo_mode"]
        demoMode.tap()
    }
    
    func depositFunds() {
        
        // --
        let fundsToAdd = "50"
        let fundsFormatted = "$50.00 USD"
        
        // -- Get Trade Component and tap
        let transferComponent = app.staticTexts["Transfer Component"]
        if transferComponent.waitForExistence(timeout: 6) {
            transferComponent.tap()
        }
        
        // -- Check UISegmentedControl
        let deposit = app.buttons["Deposit"]
        if deposit.waitForExistence(timeout: 6) {
            
            XCTAssertTrue(deposit.exists)
            XCTAssertTrue(app.buttons["Withdraw"].exists)
            let segmented = app.segmentedControls.element(boundBy: 0)
            XCTAssertTrue(segmented.buttons.element(boundBy: 0).isSelected)
        }
        
        // --
        let amountField = app.textFields["TransferComponent_AmountField"]
        if amountField.waitForExistence(timeout: 6) {
            tapElementAndWaitForKeyboardToAppear(amountField)
            amountField.typeText(fundsToAdd)
        }
        
        let continueButton = app.buttons["Continue"]
        if continueButton.waitForExistence(timeout: 2) {
            continueButton.tap()
        }
        
        // -- Transfer Modal: Confirm
        
        // -- Title
        let confirmTitle = app.staticTexts["Confirm Deposit Details"]
        if confirmTitle.waitForExistence(timeout: 4) {
            XCTAssertTrue(confirmTitle.exists)
        }
        
        // -- Amount
        let amountTitle = app.staticTexts[fundsFormatted]
        if amountTitle.waitForExistence(timeout: 4) {
            XCTAssertTrue(amountTitle.exists)
        }
        
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
        if continueButton_2.waitForExistence(timeout: 2) {
            continueButton_2.tap()
        }
        
        // -- Return main controller
        self.returnTap()
    }
    
    func withdrawFunds() {
        
        // -- Get Trade Component and tap
        let transferComponent = app.staticTexts["Transfer Component"]
        if transferComponent.waitForExistence(timeout: 6) {
            transferComponent.tap()
        }
        
        // -- Get the balance in the account
        let balanceFormatted = app.staticTexts["TrasnferComponent_Balance"].label
        var balance = balanceFormatted.replacingOccurrences(of: "$", with: "")
        balance = balance.replacingOccurrences(of: " USD", with: "")
        
        // -- Check UISegmentedControl and select withdraw
        let withdraw = app.buttons["Withdraw"]
        if withdraw.waitForExistence(timeout: 6) {

            XCTAssertTrue(app.buttons["Deposit"].exists)
            XCTAssertTrue(withdraw.exists)

            withdraw.tap()
            let segmented = app.segmentedControls.element(boundBy: 0)
            XCTAssertTrue(segmented.buttons.element(boundBy: 1).isSelected)
        }
        
        // -- Setting balance
        let amountField = app.textFields["TransferComponent_AmountField"]
        if amountField.waitForExistence(timeout: 6) {
            tapElementAndWaitForKeyboardToAppear(amountField)
            amountField.typeText(balance)
        }
        
        let continueButton = app.buttons["Continue"]
        if continueButton.waitForExistence(timeout: 2) {
            continueButton.tap()
        }
        
        // -- Transfer Modal: Confirm
        
        // -- Title
        let confirmTitle = app.staticTexts["Confirm Withdraw Details"]
        if confirmTitle.waitForExistence(timeout: 4) {
            XCTAssertTrue(confirmTitle.exists)
        }
        
        // -- Confirm deposit
        let confirmDeposit = app.buttons["Confirm Withdraw"]
        if confirmDeposit.waitForExistence(timeout: 2) {
            confirmDeposit.tap()
        }
        
        // -- Transfer Modal: Details
        
        // -- Balance
        let balanceTitle = app.staticTexts[balanceFormatted]
        if balanceTitle.waitForExistence(timeout: 6) {
            XCTAssertTrue(balanceTitle.exists)
        }
        
        // -- Title
        let detailsTitle = app.staticTexts["Transfer submitted"]
        if detailsTitle.waitForExistence(timeout: 6) {
            XCTAssertTrue(detailsTitle.exists)
        }
        
        // -- Continue
        let continueButton_2 = app.buttons["TransferComponent_Modal_Details_Continue"]
        if continueButton_2.waitForExistence(timeout: 2) {
            continueButton_2.tap()
        }
        
        // -- Return main controller
        self.returnTap()
    }
    
    func trade_buy(_ assetCode: String) {
        
        // --
        let fundsToTrade = "50"
        let fundsToTradeFormatted = "$50.00 USD"
        let asset = self.getAsset(assetCode)
        
        // -- Get Trade Component and tap
        let transferComponent = app.staticTexts["Trade Component"]
        if transferComponent.waitForExistence(timeout: 6) {
            transferComponent.tap()
        }
        
        // -- Enter in BTC
        let assetToBuy = app.staticTexts[asset]
        if assetToBuy.waitForExistence(timeout: 5) {
            
            XCTAssertTrue(assetToBuy.exists)
            assetToBuy.tap()
            
            // -- Check UISegmentedControl
            let buy = app.buttons["BUY"]
            if buy.waitForExistence(timeout: 6) {
                
                XCTAssertTrue(buy.exists)
                XCTAssertTrue(app.buttons["SELL"].exists)
                let segmented = app.segmentedControls.element(boundBy: 0)
                XCTAssertTrue(segmented.buttons.element(boundBy: 0).isSelected)
            }
            
            // -- Set how many USD to trade
            let switchButton = app.buttons["TradeComponent_SWitchButton"]
            if switchButton.waitForExistence(timeout: 5) {
                switchButton.tap()
            }
            
            let amountField = app.textFields["TradeComponent_AmountField"]
            if amountField.waitForExistence(timeout: 2) {
                tapElementAndWaitForKeyboardToAppear(amountField)
                amountField.typeText(fundsToTrade)
            }
            
            // -- Trigger action (buy/sell)
            let actionButton = app.buttons["TradeComponent_ActionButton"]
            if actionButton.waitForExistence(timeout: 2) {
                actionButton.tap()
            }
            
            // Modal: Confirm
            
            // -- Title
            let confirmTitle = app.staticTexts["Order Quote"]
            if confirmTitle.waitForExistence(timeout: 6) {
                XCTAssertTrue(confirmTitle.exists)
            }
            
            // -- Amount
            let amountTitle = app.staticTexts[fundsToTradeFormatted]
            if amountTitle.waitForExistence(timeout: 4) {
                XCTAssertTrue(amountTitle.exists)
            }
            
            // -- Confirm deposit
            let confirmTrade = app.buttons["Confirm"]
            if confirmTrade.waitForExistence(timeout: 2) {
                confirmTrade.tap()
            }
            
            // Modal: Confirm
            
            // -- Title
            let detailsTitle = app.staticTexts["Order Submitted"]
            if detailsTitle.waitForExistence(timeout: 6) {
                XCTAssertTrue(detailsTitle.exists)
            }
            
            let confirmTrade_2 = app.buttons["TradeComponent_Modal_Success_ConfirmButton"]
            if confirmTrade_2.waitForExistence(timeout: 2) {
                confirmTrade_2.tap()
            }
            
            // -- Return main controller
            self.returnTap()
            
        } else {
            
            // -- Return main controller
            self.returnTap()
        }
    }
    
    func trade_sell(_ assetCode: String) {
        
        // --
        let fundsToTrade = "50"
        let asset = self.getAsset(assetCode)
        
        // -- Get Trade Component and tap
        let transferComponent = app.staticTexts["Trade Component"]
        if transferComponent.waitForExistence(timeout: 6) {
            transferComponent.tap()
        }
        
        // -- Enter in BTC
        let assetToBuy = app.staticTexts[asset]
        if assetToBuy.waitForExistence(timeout: 4) {
            XCTAssertTrue(assetToBuy.exists)
            assetToBuy.tap()
        }
        
        // -- Check UISegmentedControl
        let sell = app.buttons["SELL"]
        if sell.waitForExistence(timeout: 6) {

            XCTAssertTrue(app.buttons["BUY"].exists)
            XCTAssertTrue(sell.exists)

            sell.tap()
            let segmented = app.segmentedControls.element(boundBy: 0)
            XCTAssertTrue(segmented.buttons.element(boundBy: 1).isSelected)
        }
        
        // -- Set how many USD to trade
        let switchButton = app.buttons["TradeComponent_SWitchButton"]
        if switchButton.waitForExistence(timeout: 5) {
            switchButton.tap()
        }
        
        let amountField = app.textFields["TradeComponent_AmountField"]
        if amountField.waitForExistence(timeout: 2) {
            tapElementAndWaitForKeyboardToAppear(amountField)
            amountField.typeText(fundsToTrade)
        }
        
        // -- Trigger action (buy/sell)
        let actionButton = app.buttons["TradeComponent_ActionButton"]
        if actionButton.waitForExistence(timeout: 2) {
            actionButton.tap()
        }
        
        // Modal: Confirm
        
        // -- Title
        let confirmTitle = app.staticTexts["Order Quote"]
        if confirmTitle.waitForExistence(timeout: 6) {
            XCTAssertTrue(confirmTitle.exists)
        }
        
        // -- Confirm deposit
        let confirmTrade = app.buttons["Confirm"]
        if confirmTrade.waitForExistence(timeout: 2) {
            confirmTrade.tap()
        }
        
        // Modal: Confirm
        
        // -- Title
        let detailsTitle = app.staticTexts["Order Submitted"]
        if detailsTitle.waitForExistence(timeout: 6) {
            XCTAssertTrue(detailsTitle.exists)
        }
        
        let confirmTrade_2 = app.buttons["TradeComponent_Modal_Success_ConfirmButton"]
        if confirmTrade_2.waitForExistence(timeout: 2) {
            confirmTrade_2.tap()
        }
        
        // -- Return main controller
        self.returnTap()
    }
    
    func trade_buy_Error() {
        
        // -- Get Trade Component and tap
        let transferComponent = app.staticTexts["Trade Component"]
        if transferComponent.waitForExistence(timeout: 6) {
            transferComponent.tap()
        }
        
        // -- Enter in BTC
        let btc = app.staticTexts["Bitcoin BTC"]
        if btc.waitForExistence(timeout: 4) {
            XCTAssertTrue(btc.exists)
            btc.tap()
        }
        
        // -- Check UISegmentedControl
        let buy = app.buttons["BUY"]
        if buy.waitForExistence(timeout: 6) {
            
            XCTAssertTrue(buy.exists)
            XCTAssertTrue(app.buttons["SELL"].exists)
            let segmented = app.segmentedControls.element(boundBy: 0)
            XCTAssertTrue(segmented.buttons.element(boundBy: 0).isSelected)
        }
        
        // -- Trigger action (buy/sell)
        let actionButton = app.buttons["TradeComponent_ActionButton"]
        if actionButton.waitForExistence(timeout: 2) {
            actionButton.tap()
        }
        
        // Modal: Error
        
        // -- Title
        let confirmTitle = app.staticTexts["Please try again."]
        if confirmTitle.waitForExistence(timeout: 6) {
            XCTAssertTrue(confirmTitle.exists)
        }
        
        // -- Confirm deposit
        let confirmTrade = app.buttons["Confirm"]
        if confirmTrade.waitForExistence(timeout: 2) {
            confirmTrade.tap()
        }
        
        // -- Return main controller
        self.returnTap()
    }
    
    func test_flow_BTC() {
        
        // -- App launch
        app.launch()
        
        // -- Login
        self.login()
        
        // -- Add 50 USD funds
        self.depositFunds()
        
        // -- Trade (buy) 50 USD to BTC
        self.trade_buy("BTC")
        
        // -- Trade (sell) 50 USD of BTC
        self.trade_sell("BTC")
    }
    
    func test_flow_ETH() {
        
        // -- App launch
        app.launch()
        
        // -- Login
        self.login()
        
        // -- Add 50 USD funds
        self.depositFunds()
        
        // -- Trade 50 USD to BTC
        self.self.trade_buy("ETH")
        
        // -- Trade (sell) 50 USD of ETH
        self.trade_sell("ETH")
    }
    
    func test_flow_USDC() {
        
        // -- App launch
        app.launch()
        
        // -- Login
        self.login()
        
        // -- Add 50 USD funds
        self.depositFunds()
        
        // -- Trade 50 USD to BTC
        self.trade_buy("USDC")
    }
    
    func test_flow_SOL() {
        
        // -- App launch
        app.launch()
        
        // -- Login
        self.login()
        
        // -- Add 50 USD funds
        self.depositFunds()
        
        // -- Trade 50 USD to BTC
        self.trade_buy("SOL")
    }
    
    func test_flow_buy_Error() {
        
        // -- App launch
        app.launch()
        
        // -- Login
        self.login()

        // -- Trade 50 USD to BTC
        self.trade_buy_Error()
    }
}

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
    
    func login() {
        
        // -- Given
        let demoMode = app.buttons["demo_mode"]
        demoMode.tap()
    }
    
    func depositFounds() {
        
        // --
        let foundsToAdd = "50"
        let foundsFormatted = "$50.00 USD"
        
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
            amountField.typeText(foundsToAdd)
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
        let amountTitle = app.staticTexts[foundsFormatted]
        if amountTitle.waitForExistence(timeout: 4) {
            XCTAssertTrue(amountTitle.exists)
        }
        
        // -- Confirm deposit
        let confirmDeposit = app.buttons["Confirm Deposit"]
        if confirmDeposit.waitForExistence(timeout: 2) {
            confirmDeposit.tap()
        }
        
        // -- Transfer Modal: Details
        
        // -- Founds
        let foundsTitle = app.staticTexts[foundsFormatted]
        if foundsTitle.waitForExistence(timeout: 6) {
            XCTAssertTrue(foundsTitle.exists)
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
    
    func withdrawFounds() {
        
        // -- Get Trade Component and tap
        let transferComponent = app.staticTexts["Transfer Component"]
        if transferComponent.waitForExistence(timeout: 6) {
            transferComponent.tap()
        }
        
        // -- Get how many founds in account
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
    
    func trade_buy_BTC() {
        
        // --
        let foundsToTrade = "50"
        let foundsToTradeFormatted = "$50.00 USD"
        
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
        
        // -- Set how many USD to trade
        let switchButton = app.buttons["TradeComponent_SWitchButton"]
        if switchButton.waitForExistence(timeout: 5) {
            switchButton.tap()
        }
        
        let amountField = app.textFields["TradeComponent_AmountField"]
        if amountField.waitForExistence(timeout: 2) {
            tapElementAndWaitForKeyboardToAppear(amountField)
            amountField.typeText(foundsToTrade)
        }
        //dismissKeyboardIfPresent()
        
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
        let amountTitle = app.staticTexts[foundsToTradeFormatted]
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
    }
    
    func trade_sell_BTC() {
        
        // --
        let foundsToTrade = "50"
        
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
            amountField.typeText(foundsToTrade)
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
    
    func trade_buy_ETH() {
        
        // --
        let foundsToTrade = "50"
        let foundsToTradeFormatted = "$50.00 USD"
        
        // -- Get Trade Component and tap
        let transferComponent = app.staticTexts["Trade Component"]
        if transferComponent.waitForExistence(timeout: 6) {
            transferComponent.tap()
        }
        
        // -- Enter in BTC
        let eth = app.staticTexts["Ethereum ETH"]
        if eth.waitForExistence(timeout: 4) {
            XCTAssertTrue(eth.exists)
            eth.tap()
        }
        
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
            amountField.typeText(foundsToTrade)
        }
        //dismissKeyboardIfPresent()
        
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
        let amountTitle = app.staticTexts[foundsToTradeFormatted]
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
    }
    
    func trade_sell_ETH() {
        
        // --
        let foundsToTrade = "50"
        
        // -- Get Trade Component and tap
        let transferComponent = app.staticTexts["Trade Component"]
        if transferComponent.waitForExistence(timeout: 6) {
            transferComponent.tap()
        }
        
        // -- Enter in BTC
        let eth = app.staticTexts["Ethereum ETH"]
        if eth.waitForExistence(timeout: 4) {
            XCTAssertTrue(eth.exists)
            eth.tap()
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
            amountField.typeText(foundsToTrade)
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
    
    func trade_buy_USDC() {
        
        // --
        let foundsToTrade = "50"
        let foundsToTradeFormatted = "$50.00 USD"
        
        // -- Get Trade Component and tap
        let transferComponent = app.staticTexts["Trade Component"]
        if transferComponent.waitForExistence(timeout: 6) {
            transferComponent.tap()
        }
        
        // -- Enter in BTC
        let usdc = app.staticTexts["USDC (ERC-20) USDC"]
        if usdc.waitForExistence(timeout: 5) {
            
            XCTAssertTrue(usdc.exists)
            usdc.tap()
            
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
                amountField.typeText(foundsToTrade)
            }
            //dismissKeyboardIfPresent()
            
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
            let amountTitle = app.staticTexts[foundsToTradeFormatted]
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
    
    func trade_buy_SOL() {
        
        // --
        let foundsToTrade = "50"
        let foundsToTradeFormatted = "$50.00 USD"
        
        // -- Get Trade Component and tap
        let transferComponent = app.staticTexts["Trade Component"]
        if transferComponent.waitForExistence(timeout: 6) {
            transferComponent.tap()
        }
        
        // -- Enter in BTC
        let usdc = app.staticTexts["Solana SOL"]
        if usdc.waitForExistence(timeout: 5) {
            
            XCTAssertTrue(usdc.exists)
            usdc.tap()
            
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
                amountField.typeText(foundsToTrade)
            }
            //dismissKeyboardIfPresent()
            
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
            let amountTitle = app.staticTexts[foundsToTradeFormatted]
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
        
        // -- Add 50 USD founds
        self.depositFounds()
        
        // -- Trade (buy) 50 USD to BTC
        self.trade_buy_BTC()
        
        // -- Trade (sell) 50 USD of BTC
        self.trade_sell_BTC()
    }
    
    func test_flow_buy_ETH() {
        
        // -- App launch
        app.launch()
        
        // -- Login
        self.login()
        
        // -- Add 50 USD founds
        self.depositFounds()
        
        // -- Trade 50 USD to BTC
        self.trade_buy_ETH()
        
        // -- Trade (sell) 50 USD of ETH
        self.trade_sell_ETH()
    }
    
    func test_flow_buy_USDC() {
        
        // -- App launch
        app.launch()
        
        // -- Login
        self.login()
        
        // -- Add 50 USD founds
        self.depositFounds()
        
        // -- Trade 50 USD to BTC
        self.trade_buy_USDC()
    }
    
    func test_flow_buy_SOL() {
        
        // -- App launch
        app.launch()
        
        // -- Login
        self.login()
        
        // -- Add 50 USD founds
        self.depositFounds()
        
        // -- Trade 50 USD to BTC
        self.trade_buy_SOL()
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

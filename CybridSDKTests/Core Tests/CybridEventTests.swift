//
//  CybridEventTests.swift
//  CybridSDKTests
//
//  Created by Cybrid on 2/08/22.
//

@testable import CybridSDK
import XCTest

class CybridEventTests: XCTestCase {
  func testEvent_LogLevel() {
    // Application
    XCTAssertEqual(CybridEvent.application(.initSuccess).level, .info)
    XCTAssertEqual(CybridEvent.application(.initError).level, .fatal)
    // Service Error
    XCTAssertEqual(CybridEvent.serviceError(.authService).level, .error)
    XCTAssertEqual(CybridEvent.serviceError(.errorService).level, .error)
    XCTAssertEqual(CybridEvent.serviceError(.eventService).level, .error)
    // PriceList
    XCTAssertEqual(CybridEvent.component(.priceList(.initSuccess)).level, .info)
    XCTAssertEqual(CybridEvent.component(.priceList(.dataFetching)).level, .info)
    XCTAssertEqual(CybridEvent.component(.priceList(.dataError)).level, .error)
    XCTAssertEqual(CybridEvent.component(.priceList(.dataRefreshed)).level, .info)
    // Trade
    XCTAssertEqual(CybridEvent.component(.trade(.initSuccess)).level, .info)
    XCTAssertEqual(CybridEvent.component(.trade(.priceDataFetching)).level, .info)
    XCTAssertEqual(CybridEvent.component(.trade(.priceDataError)).level, .error)
    XCTAssertEqual(CybridEvent.component(.trade(.priceDataRefreshed)).level, .info)
    XCTAssertEqual(CybridEvent.component(.trade(.quoteDataFetching)).level, .info)
    XCTAssertEqual(CybridEvent.component(.trade(.quoteDataError)).level, .error)
    XCTAssertEqual(CybridEvent.component(.trade(.quoteDataRefreshed)).level, .info)
    XCTAssertEqual(CybridEvent.component(.trade(.tradeDataFetching)).level, .info)
    XCTAssertEqual(CybridEvent.component(.trade(.tradeDataError)).level, .error)
    XCTAssertEqual(CybridEvent.component(.trade(.tradeConfirmed)).level, .info)
  }

  func testEvent_Code() {
    // Application
    XCTAssertEqual(CybridEvent.application(.initSuccess).code, "APPLICATION_INIT")
    XCTAssertEqual(CybridEvent.application(.initError).code, "APPLICATION_ERROR")
    // Service Error
    XCTAssertEqual(CybridEvent.serviceError(.authService).code, "SERVICE_ERROR")
    XCTAssertEqual(CybridEvent.serviceError(.errorService).code, "SERVICE_ERROR")
    XCTAssertEqual(CybridEvent.serviceError(.eventService).code, "SERVICE_ERROR")
    // PriceList
    XCTAssertEqual(CybridEvent.component(.priceList(.initSuccess)).code, "COMPONENT_PRICE_LIST_INIT")
    XCTAssertEqual(CybridEvent.component(.priceList(.dataFetching)).code, "COMPONENT_PRICE_LIST_DATA_FETCHING")
    XCTAssertEqual(CybridEvent.component(.priceList(.dataError)).code, "COMPONENT_PRICE_LIST_DATA_ERROR")
    XCTAssertEqual(CybridEvent.component(.priceList(.dataRefreshed)).code, "COMPONENT_PRICE_LIST_DATA_REFRESHED")
    
    // Trade
    XCTAssertEqual(CybridEvent.component(.trade(.initSuccess)).code, "COMPONENT_TRADE_INIT")
    XCTAssertEqual(CybridEvent.component(.trade(.priceDataFetching)).code, "COMPONENT_TRADE_PRICE_DATA_FETCHING")
    XCTAssertEqual(CybridEvent.component(.trade(.priceDataError)).code, "COMPONENT_TRADE_PRICE_DATA_ERROR")
    XCTAssertEqual(CybridEvent.component(.trade(.priceDataRefreshed)).code, "COMPONENT_TRADE_PRICE_DATA_REFRESHED")
    XCTAssertEqual(CybridEvent.component(.trade(.quoteDataFetching)).code, "COMPONENT_TRADE_QUOTE_DATA_FETCHING")
    XCTAssertEqual(CybridEvent.component(.trade(.quoteDataError)).code, "COMPONENT_TRADE_QUOTE_DATA_ERROR")
    XCTAssertEqual(CybridEvent.component(.trade(.quoteDataRefreshed)).code, "COMPONENT_TRADE_QUOTE_DATA_REFRESHED")
    XCTAssertEqual(CybridEvent.component(.trade(.tradeDataFetching)).code, "COMPONENT_TRADE_TRADE_DATA_FETCHING")
    XCTAssertEqual(CybridEvent.component(.trade(.tradeDataError)).code, "COMPONENT_TRADE_TRADE_DATA_ERROR")
    XCTAssertEqual(CybridEvent.component(.trade(.tradeConfirmed)).code, "COMPONENT_TRADE_TRADE_CONFIRMED")
  }

  func testEvent_Message() {
    // Application
    XCTAssertEqual(CybridEvent.application(.initSuccess).message, "Initializing appplication")
    XCTAssertEqual(CybridEvent.application(.initError).message, "Fatal error initializing application")
    // Service Error
    XCTAssertEqual(CybridEvent.serviceError(.authService).message, "There was a failure initializing the Auth service")
    XCTAssertEqual(CybridEvent.serviceError(.errorService).message, "There was a failure initializing the Error service")
    XCTAssertEqual(CybridEvent.serviceError(.eventService).message, "There was a failure initializing the Event service")
    // PriceList
    XCTAssertEqual(CybridEvent.component(.priceList(.initSuccess)).message, "Initializing price list component")
    XCTAssertEqual(CybridEvent.component(.priceList(.dataFetching)).message, "Fetching price list...")
    XCTAssertEqual(CybridEvent.component(.priceList(.dataError)).message, "There was an error fetching price list")
    XCTAssertEqual(CybridEvent.component(.priceList(.dataRefreshed)).message, "Price list successfully updated")

    // Trade
    XCTAssertEqual(CybridEvent.component(.trade(.initSuccess)).message, "Initializing trade component")
    XCTAssertEqual(CybridEvent.component(.trade(.priceDataFetching)).message, "Fetching price...")
    XCTAssertEqual(CybridEvent.component(.trade(.priceDataError)).message, "There was an error fetching price")
    XCTAssertEqual(CybridEvent.component(.trade(.priceDataRefreshed)).message, "Price successfully updated")
    XCTAssertEqual(CybridEvent.component(.trade(.quoteDataFetching)).message, "Fetching quote...")
    XCTAssertEqual(CybridEvent.component(.trade(.quoteDataError)).message, "There was an error fetching quote")
    XCTAssertEqual(CybridEvent.component(.trade(.quoteDataRefreshed)).message, "Quote successfully updated")
    XCTAssertEqual(CybridEvent.component(.trade(.tradeDataFetching)).message, "Fetching trade...")
    XCTAssertEqual(CybridEvent.component(.trade(.tradeDataError)).message, "There was an error confirming trade")
    XCTAssertEqual(CybridEvent.component(.trade(.tradeConfirmed)).message, "Trade successfully confirmed")
  }
}

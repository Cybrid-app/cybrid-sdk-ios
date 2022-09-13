//
//  CybridEvent.swift
//  CybridSDK
//
//  Created by Cybrid on 2/08/22.
//

import Foundation

// MARK: - Log Level

public enum LogLevel: String {
  case debug = "DEBUG"
  case info = "INFO"
  case warning = "WARNING"
  case error = "ERROR"
  case fatal = "FATAL"
}

// MARK: - Cybrid Event

public enum CybridEvent {
  case application(ApplicationEvent)
  case component(ComponentEvent)
  case serviceError(ServiceError)

  public var level: LogLevel {
    switch self {
    case .application(let event):
      return event.level
    case .component(let event):
      return event.level
    case .serviceError:
      return .error
    }
  }

  public var code: String {
    switch self {
    case .application(let applicationEvent):
      return "APPLICATION_" + applicationEvent.code
    case .component(let componentEvent):
      return "COMPONENT_" + componentEvent.code
    case .serviceError:
      return "SERVICE_ERROR"
    }
  }

  public var message: String {
    switch self {
    case .application(let event):
      return event.message
    case .component(let event):
      return event.message
    case .serviceError(let error):
      return error.message
    }
  }
}

// MARK: - Service Error

extension CybridEvent {
  public enum ServiceError {
    case authService
    case errorService
    case eventService

    var message: String {
      switch self {
      case .authService:
        return "There was a failure initializing the Auth service"
      case .errorService:
        return "There was a failure initializing the Error service"
      case .eventService:
        return "There was a failure initializing the Event service"
      }
    }
  }
}

// MARK: - Application Event

extension CybridEvent {
  public enum ApplicationEvent {
    case initSuccess
    case initError

    var level: LogLevel {
      switch self {
      case .initSuccess:
        return .info
      case .initError:
        return .fatal
      }
    }

    var code: String {
      switch self {
      case .initSuccess:
        return "INIT"
      case .initError:
        return "ERROR"
      }
    }

    var message: String {
      switch self {
      case .initSuccess:
        return "Initializing appplication"
      case .initError:
        return "Fatal error initializing application"
      }
    }
  }
}

// MARK: - Component Event

extension CybridEvent {
  public enum ComponentEvent {
    case priceList(PriceListEvent)
    case trade(TradeEvent)

    var level: LogLevel {
      switch self {
      case .priceList(let event):
        return event.level
      case .trade(let event):
        return event.level
      }
    }

    var code: String {
      switch self {
      case .priceList(let event):
        return "PRICE_LIST_" + event.code
      case .trade(let event):
        return "TRADE_" + event.code
      }
    }

    var message: String {
      switch self {
      case .priceList(let event):
        return event.message
      case .trade(let event):
        return event.message
      }
    }

    public enum PriceListEvent {
      case initSuccess
      case dataFetching
      case dataError
      case dataRefreshed
      case liveUpdateStop

      var level: LogLevel {
        switch self {
        case .initSuccess, .dataFetching, .dataRefreshed, .liveUpdateStop:
          return .info
        case .dataError:
          return .error
        }
      }

      var code: String {
        switch self {
        case .initSuccess:
          return "INIT"
        case .dataFetching:
          return "DATA_FETCHING"
        case .dataError:
          return "DATA_ERROR"
        case .dataRefreshed:
          return "DATA_REFRESHED"
        case .liveUpdateStop:
          return "LIVE_UPDATE_STOP"
        }
      }

      var message: String {
        switch self {
        case .initSuccess:
          return "Initializing price list component"
        case .dataFetching:
          return "Fetching price list..."
        case .dataError:
          return "There was an error fetching price list"
        case .dataRefreshed:
          return "Price list successfully updated"
        case .liveUpdateStop:
          return "Price list live update stop"
        }
      }
    }

    public enum TradeEvent {
      case initSuccess
      case priceDataFetching
      case priceDataError
      case priceDataRefreshed
      case priceLiveUpdateStop
      case quoteDataFetching
      case quoteDataError
      case quoteDataRefreshed
      case quoteLiveUpdateStop
      case tradeDataFetching
      case tradeDataError
      case tradeConfirmed

      var level: LogLevel {
        switch self {
        case .initSuccess, .priceDataFetching, .priceDataRefreshed, .quoteDataFetching,
            .quoteDataRefreshed, .tradeDataFetching, .tradeConfirmed,
            .priceLiveUpdateStop, .quoteLiveUpdateStop:
          return .info
        case .priceDataError, .quoteDataError, .tradeDataError:
          return .error
        }
      }

      var code: String {
        switch self {
        case .initSuccess:
          return "INIT"
        case .priceDataFetching:
          return "PRICE_DATA_FETCHING"
        case .priceDataError:
          return "PRICE_DATA_ERROR"
        case .priceDataRefreshed:
          return "PRICE_DATA_REFRESHED"
        case .quoteDataFetching:
          return "QUOTE_DATA_FETCHING"
        case .quoteDataError:
          return "QUOTE_DATA_ERROR"
        case .quoteDataRefreshed:
          return "QUOTE_DATA_REFRESHED"
        case .tradeDataFetching:
          return "TRADE_DATA_FETCHING"
        case .tradeDataError:
          return "TRADE_DATA_ERROR"
        case .tradeConfirmed:
          return "TRADE_CONFIRMED"
        case .priceLiveUpdateStop:
          return "PRICE_LIVE_UPDATE_STOP"
        case .quoteLiveUpdateStop:
          return "QUOTE_LIVE_UPDATE_STOP"
        }
      }

      var message: String {
        switch self {
        case .initSuccess:
          return "Initializing trade component"
        case .priceDataFetching:
          return "Fetching price..."
        case .priceDataError:
          return "There was an error fetching price"
        case .priceDataRefreshed:
          return "Price successfully updated"
        case .quoteDataFetching:
          return "Fetching quote..."
        case .quoteDataError:
          return "There was an error fetching quote"
        case .quoteDataRefreshed:
          return "Quote successfully updated"
        case .tradeDataFetching:
          return "Fetching trade..."
        case .tradeDataError:
          return "There was an error confirming trade"
        case .tradeConfirmed:
          return "Trade successfully confirmed"
        case .priceLiveUpdateStop:
          return "Price live update did stop"
        case .quoteLiveUpdateStop:
          return "Quote live update did stop"
        }
      }
    }
  }
}

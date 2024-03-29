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
    case accounts(AccountsEvent)
    case trades(TradesEvent)

    var level: LogLevel {
      switch self {
      case .priceList(let event):
        return event.level
      case .trade(let event):
        return event.level
      case .accounts(let event):
          return event.level
      case .trades(let event):
        return event.level
      }
    }

    var code: String {
      switch self {
      case .priceList(let event):
        return "PRICE_LIST_" + event.code
      case .trade(let event):
          return "TRADE_" + event.code
      case .accounts(let event):
          return "ACCOUNTS_" + event.code
      case .trades(let event):
          return "TRADES_" + event.code
      }
    }

    var message: String {
      switch self {
      case .priceList(let event):
        return event.message
      case .trade(let event):
        return event.message
      case .accounts(let event):
        return event.message
      case .trades(let event):
        return event.message
      }
    }
  }

    public enum PriceListEvent {
      case initSuccess
      case dataFetching
      case dataError
      case dataRefreshed

      var level: LogLevel {
        switch self {
        case .initSuccess, .dataFetching, .dataRefreshed:
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
        }
      }
    }

    public enum TradeEvent {
      case initSuccess
      case priceDataFetching
      case priceDataError
      case priceDataRefreshed
      case quoteDataFetching
      case quoteDataError
      case quoteDataRefreshed
      case tradeDataFetching
      case tradeDataError
      case tradeConfirmed

      var level: LogLevel {
        switch self {
        case .initSuccess, .priceDataFetching, .priceDataRefreshed, .quoteDataFetching,
            .quoteDataRefreshed, .tradeDataFetching, .tradeConfirmed:
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
        }
      }
    }

    public enum AccountsEvent {
        case initSuccess
        case assetsDataFetching
        case accountsDataFetching
        case pricesDataFetching
        case assetsDataError
        case accountsDataError
        case pricesDataError

        var level: LogLevel {
          switch self {
          case .initSuccess, .assetsDataFetching, .accountsDataFetching, .pricesDataFetching:
            return .info
          case .assetsDataError, .accountsDataError, .pricesDataError:
            return .error
          }
        }

        var code: String {
          switch self {
          case .initSuccess:
            return "INIT"
          case .assetsDataFetching:
            return "ASSETS_DATA_FETCHING"
          case .assetsDataError:
            return "ASSETS_DATA_ERROR"
          case .accountsDataFetching:
            return "ACCOUNTS_DATA_FETCHING"
          case .accountsDataError:
            return "ACCOUNTS_DATA_ERROR"
          case .pricesDataFetching:
            return "PRICES_DATA_FETCHING"
          case .pricesDataError:
            return "PRICES_DATA_ERROR"

          }
        }

        var message: String {
          switch self {
          case .initSuccess:
            return "Initializing accounts component"
          case .assetsDataFetching:
            return "Fetching assets"
          case .assetsDataError:
            return "There was an error fetching prices"
          case .accountsDataFetching:
            return "Fetching accounts"
          case .accountsDataError:
            return "There was an error fetching accounts"
          case .pricesDataFetching:
            return "Fetching prices"
          case .pricesDataError:
            return "There was an error fetching accounts"

          }
        }
    }

    public enum TradesEvent {
        case initSuccess
        case tradesDataFetching
        case tradesDataError

        var level: LogLevel {
          switch self {
          case .initSuccess, .tradesDataFetching:
            return .info
          case .tradesDataError:
            return .error
          }
        }

        var code: String {
          switch self {
          case .initSuccess:
            return "INIT"
          case .tradesDataFetching:
            return "TRADES_DATA_FETCHING"
          case .tradesDataError:
            return "TRADES_DATA_ERROR"

          }
        }

        var message: String {
          switch self {
          case .initSuccess:
            return "Initializing accounts component"
          case .tradesDataFetching:
            return "Fetching trades"
          case .tradesDataError:
            return "There was an error fetching trades"
          }
        }
    }
}

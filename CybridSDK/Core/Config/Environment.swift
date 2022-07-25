//
//  Environment.swift
//  CybridSDK
//
//  Created by Cybrid on 11/07/22.
//

import Foundation

public enum CybridEnvironment {
  case sandbox
  case development
  case production

  var basePath: String {
    switch self {
    case .sandbox:
      return "https://bank.demo.cybrid.app"
    case .development:
      // TODO: Add Development path
      return "https://bank.demo.cybrid.app"
    case .production:
      // TODO: Add Prod path
      return "https://bank.demo.cybrid.app"
    }
  }
}

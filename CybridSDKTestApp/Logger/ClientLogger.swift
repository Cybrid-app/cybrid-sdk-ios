//
//  ClientLogger.swift
//  CybridSDKTestApp
//
//  Created by Cybrid on 2/08/22.
//

import CybridSDK
import Foundation

final class ClientLogger: CybridLogger {
  func log(_ event: CybridEvent) {
    print("\(event.level.rawValue):\(event.code) - \(event.message)")
  }
}

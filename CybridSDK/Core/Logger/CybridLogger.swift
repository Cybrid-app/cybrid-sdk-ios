//
//  CybridLogger.swift
//  CybridSDK
//
//  Created by Cybrid on 2/08/22.
//

import Foundation

public protocol CybridLogger {
  func log(_ event: CybridEvent)
}

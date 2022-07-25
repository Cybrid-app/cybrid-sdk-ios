//
//  TimerType.swift
//  CybridSDK
//
//  Created by Cybrid on 25/07/22.
//

import Foundation

protocol TimerType {
  var isValid: Bool { get }
  var timeInterval: TimeInterval { get }

  static func makeScheduler(block: @escaping (TimerType) -> Void) -> TimerType
  func invalidate()
  func fire()
}

extension Timer: TimerType {
  static func makeScheduler(block: @escaping (TimerType) -> Void) -> TimerType {
    return Timer.scheduledTimer(withTimeInterval: Cybrid.refreshRate, repeats: true, block: block)
  }
}

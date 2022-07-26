//
//  TimerMock.swift
//  CybridSDKTests
//
//  Created by Cybrid on 26/07/22.
//

@testable import CybridSDK
import Foundation

final class TimerMock: TimerType {
  private var _isValid = false
  private var _timeInterval: TimeInterval = 1
  fileprivate var block: (() -> Void)?

  var isValid: Bool {
    return _isValid
  }

  var timeInterval: TimeInterval {
    return _timeInterval
  }

  static func makeScheduler(block: @escaping (TimerType) -> Void) -> TimerType {
    let timer = TimerMock()
    timer.block = {
      block(timer)
    }
    return timer
  }

  func invalidate() {
    _isValid = false
  }

  func fire() {
    _isValid = true
    block?()
  }

  func runLoop() {
    while isValid {
      block?()
      sleep(UInt32(timeInterval))
    }
  }
}

//
//  TaskSchedulerMock.swift
//  CybridSDKTests
//
//  Created by Cybrid on 25/07/22.
//

@testable import CybridSDK
import Foundation

final class TaskSchedulerMock: TaskScheduler {
  var timerType: TimerType.Type
  var timer: TimerType?
  var state: TimerTypeState = .initial
  var block: (() -> Void)?

  init(timer: TimerType = TimerMock()) {
    self.timerType = type(of: timer)
    self.timer = timer
    self.state = .initial
  }

  func runNextLoop() {
    block?()
  }
}

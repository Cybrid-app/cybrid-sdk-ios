//
//  TaskSchedulerMock.swift
//  CybridSDKTests
//
//  Created by Cybrid on 25/07/22.
//

@testable import CybridSDK
import Foundation

final class TaskSchedulerMock: TaskScheduler {
  init(timer: TimerType = TimerMock()) {
    super.init()
    self.timerType = type(of: timer)
    self.timer = timer
    self.state = .initial
  }

  func runNextLoop() {
    block?()
  }

  func runLoop() {
    (timer as? TimerMock)?.runLoop()
  }
}

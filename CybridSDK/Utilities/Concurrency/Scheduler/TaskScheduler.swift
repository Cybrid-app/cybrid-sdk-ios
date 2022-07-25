//
//  TaskScheduler.swift
//  CybridSDK
//
//  Created by Cybrid on 22/07/22.
//

import Foundation

protocol TaskScheduler: AnyObject {
  var timerType: TimerType.Type { get }
  var timer: TimerType? { get set }
  var state: TimerTypeState { get set }
  var block: (() -> Void)? { get set }
}

extension TaskScheduler {
  /// Schedules new block of code to run
  func start(block: (() -> Void)? = nil) {
    /// Check if trying to override block
    if let incomingBlock = block {
      /// We set the new block
      self.block = incomingBlock
    }
    /// Create new scheduler
    timer = timerType.makeScheduler(block: { [weak self] capturedTimer in
      // TODO: replace this print with Log
      print("\(String(describing: self)) running scheduled task at \(Date().description)")
      guard let self = self, capturedTimer.isValid else { return }
      self.block?()
    })
    timer?.fire()
    /// Change state to running
    state = .running
  }

  func pause() {
    if state == .running {
      timer?.invalidate()
      timer = nil
      state = .paused
    }
  }

  func resume() {
    if state == .paused || (state == .running && !(timer?.isValid ?? false)) {
      start()
    }
  }

  func cancel() {
    timer?.invalidate()
    timer = nil
    state = .cancelled
  }
}

enum TimerTypeState {
  case initial
  case running
  case paused
  case cancelled
}

final class CybridTaskScheduler: TaskScheduler {
  var timerType: TimerType.Type
  var timer: TimerType?
  var state: TimerTypeState
  var block: (() -> Void)?

  init() {
    self.timerType = Timer.self
    self.state = .initial
  }
}

//
//  AssertionFailureOverride.swift
//  CybridSDK
//
//  Created by Cybrid on 15/06/22.
//

import Foundation

/// Override Swift global `assertionFailure` function
func assertionFailure(_ message: @autoclosure () -> String = "", file: StaticString = #file, line: UInt = #line) {
  AssertionFailureOverride.assertionClosure(message(), file, line)
}

enum AssertionFailureOverride {
  typealias AssertionClosure = (@autoclosure () -> String, StaticString, UInt) -> Void

  /// Custom `assertionFailure`
  static var assertionClosure: AssertionClosure = Swift.assertionFailure

  /// Backup Swift's `assertionFailure` function
  private static let defaultAssertionClosure: AssertionClosure = Swift.assertionFailure

  static func replaceAssertionClosure(_ closure: @escaping AssertionClosure) {
    assertionClosure = closure
  }

  static func restoreAssertionClosure() {
    assertionClosure = defaultAssertionClosure
  }
}

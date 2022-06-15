//
//  AssertionFailureOverride.swift
//  CybridSDK
//
//  Created by Cybrid on 15/06/22.
//

import Foundation

/// Override Swift global `assertionFailure` function
func assertionFailure(_ message: @autoclosure () -> String = String()) {
  AssertionFailureOverride.assertionClosure(message())
}

enum AssertionFailureOverride {
  typealias AssertionClosure = (String) -> Void

  /// Custom `assertionFailure`
  static var assertionClosure: AssertionClosure = defaultAssertionClosure

  /// Backup Swift's `assertionFailure` function
  private static let defaultAssertionClosure: AssertionClosure = { Swift.assertionFailure($0) }

  static func replaceAssertionClosure(_ closure: @escaping AssertionClosure) {
    assertionClosure = closure
  }

  static func restoreAssertionClosure() {
    assertionClosure = defaultAssertionClosure
  }
}

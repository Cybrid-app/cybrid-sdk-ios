//
//  MockNumberFormatter.swift
//  CybridSDKTests
//
//  Created by Cybrid on 5/07/22.
//

import Foundation

class MockNumberFormatter: NumberFormatter {
  private var fixedFormattedNumber: String?

  func setFixedFormattedNumber(_ formattedNumber: String?) {
    self.fixedFormattedNumber = formattedNumber
  }

  override func string(from number: NSNumber) -> String? {
    return fixedFormattedNumber
  }
}

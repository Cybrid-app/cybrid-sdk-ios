//
//  Cybrid.swift
//  CybridSDK
//
//  Created by Cybrid on 22/06/22.
//

import Foundation

// swiftlint:disable identifier_name
/// Reference to `CybridConfig.shared` for quick bootstrapping.
public let Cybrid = CybridConfig.shared

public final class CybridConfig {
  static var shared = CybridConfig()

  var theme: Theme = CybridTheme.default

  public func setup(_ theme: Theme) {
      self.theme = theme
  }
}
// swiftlint:enable identifier_name

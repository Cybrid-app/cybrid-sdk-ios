//
//  CybridSDK.swift
//  CybridSDK
//
//  Created by Cybrid on 22/06/22.
//

import Foundation

public final class CybridSDK {
  static var global = CybridSDK()

  var theme: Theme = CybridTheme.default

  public static func setup(_ theme: Theme) {
    global.theme = theme
  }
}

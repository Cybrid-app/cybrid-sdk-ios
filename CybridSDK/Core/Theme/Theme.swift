//
//  Theme.swift
//  CybridSDK
//
//  Created by Cybrid on 21/06/22.
//

import UIKit

public protocol Theme {
  var colorTheme: ColorTheme { get }
  var fontTheme: FontTheme { get }
}

struct CybridTheme: Theme {
  static let `default` = CybridTheme(colorTheme: .default, fontTheme: .default)
  let colorTheme: ColorTheme
  let fontTheme: FontTheme
}

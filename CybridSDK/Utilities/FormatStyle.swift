//
//  FormatStyle.swift
//  CybridSDK
//
//  Created by Cybrid on 22/06/22.
//

import UIKit

enum FormatStyle {
  case headerSmall
  case bodyLarge
  case body
  case comment
  case inputPlaceholder

  var isUppercased: Bool {
    switch self {
    case .headerSmall:
      return true
    default:
      return false
    }
  }

  func textColor(with theme: ColorTheme) -> UIColor {
    switch self {
    case .headerSmall, .comment, .inputPlaceholder:
      return theme.secondaryTextColor
    case .body, .bodyLarge:
      return theme.primaryTextColor
    }
  }

  func font(with theme: FontTheme) -> UIFont {
    switch self {
    case .headerSmall:
      return theme.caption
    case .bodyLarge:
      return theme.bodyLarge
    case .body:
      return theme.body
    case .comment:
      return theme.caption
    case .inputPlaceholder:
      return theme.bodyLarge
    }
  }
}

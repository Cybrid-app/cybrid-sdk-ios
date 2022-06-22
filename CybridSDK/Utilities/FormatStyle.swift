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

  var textColor: UIColor {
    switch self {
    case .headerSmall, .comment, .inputPlaceholder:
      return CybridSDK.global.theme.colorTheme.secondaryTextColor
    case .body, .bodyLarge:
      return CybridSDK.global.theme.colorTheme.primaryTextColor
    }
  }

  var font: UIFont {
    switch self {
    case .headerSmall:
      return CybridSDK.global.theme.fontTheme.caption
    case .bodyLarge:
      return CybridSDK.global.theme.fontTheme.bodyLarge
    case .body:
      return CybridSDK.global.theme.fontTheme.body
    case .comment:
      return CybridSDK.global.theme.fontTheme.caption
    case .inputPlaceholder:
      return CybridSDK.global.theme.fontTheme.bodyLarge
    }
  }
}

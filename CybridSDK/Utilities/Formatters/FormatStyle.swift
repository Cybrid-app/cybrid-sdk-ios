//
//  FormatStyle.swift
//  CybridSDK
//
//  Created by Cybrid on 22/06/22.
//

import UIKit

enum FormatStyle {
  case header
  case headerSmall
  case bodyLarge
  case body
  case bodyStrong
  case caption
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
    case .headerSmall, .caption, .inputPlaceholder:
      return Cybrid.theme.colorTheme.secondaryTextColor
    case .body, .bodyStrong, .bodyLarge, .header:
      return Cybrid.theme.colorTheme.primaryTextColor
    }
  }

  var font: UIFont {
    switch self {
    case .header:
      return Cybrid.theme.fontTheme.bodyLarge
    case .headerSmall:
      return Cybrid.theme.fontTheme.caption
    case .bodyLarge:
      return Cybrid.theme.fontTheme.bodyLarge
    case .body:
      return Cybrid.theme.fontTheme.body
    case .bodyStrong:
      return Cybrid.theme.fontTheme.body
    case .caption:
      return Cybrid.theme.fontTheme.caption
    case .inputPlaceholder:
      return Cybrid.theme.fontTheme.bodyLarge
    }
  }
}

//
//  FormatStyle.swift
//  CybridSDK
//
//  Created by Cybrid on 22/06/22.
//

import UIKit

enum FormatStyle {
  case header1 // Largest Font
  case header2 // Large Font
  case header4 // Small title font with all caps
  case body // Body font
  case disclaimer // Smaller body font, similar color as caption
  case caption
  case inputPlaceholder

  var isUppercased: Bool {
    switch self {
    case .header4:
      return true
    default:
      return false
    }
  }

  var textColor: UIColor {
    switch self {
    case .header4, .caption, .inputPlaceholder, .disclaimer:
      return Cybrid.theme.colorTheme.secondaryTextColor
    case .body, .header2, .header1:
      return Cybrid.theme.colorTheme.primaryTextColor
    }
  }

  var font: UIFont {
    switch self {
    case .header1:
      return Cybrid.theme.fontTheme.header1
    case .header2:
      return Cybrid.theme.fontTheme.header2
    case .header4:
      return Cybrid.theme.fontTheme.caption
    case .body:
      return Cybrid.theme.fontTheme.body
    case .disclaimer:
      return Cybrid.theme.fontTheme.body2
    case .caption:
      return Cybrid.theme.fontTheme.caption
    case .inputPlaceholder:
      return Cybrid.theme.fontTheme.header2
    }
  }
}

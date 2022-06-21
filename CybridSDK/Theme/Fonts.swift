//
//  Fonts.swift
//  CybridSDK
//
//  Created by Cybrid on 21/06/22.
//

import UIKit

enum FontStyle {
  case headerSmall
  case bodyLarge
  case body
  case comment
  case searchBar

  var font: UIFont {
    switch self {
    case .headerSmall:
      return .systemFont(ofSize: 12, weight: .regular)
    case .bodyLarge:
      return .systemFont(ofSize: 17, weight: .regular)
    case .body, .comment:
      return .systemFont(ofSize: 14, weight: .regular)
    case .searchBar:
      return .systemFont(ofSize: 16, weight: .regular)
    }
  }

  var textColor: UIColor {
    switch self {
    case .headerSmall, .comment, .searchBar:
      return .secondaryText
    case .body, .bodyLarge:
      return .primaryText
    }
  }

  var isCapitalized: Bool {
    switch self {
    case .headerSmall:
      return true
    default:
      return false
    }
  }
}

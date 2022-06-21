//
//  Colors.swift
//  CybridSDK
//
//  Created by Cybrid on 21/06/22.
//

import UIKit

extension UIColor {
  // Background Color
  static var primaryBackground: UIColor {
    return UIColor(light: primaryLightBackground, dark: primaryDarkBackground)
  }
  static var secondaryBackground: UIColor {
    return UIColor(light: primaryLightBackground, dark: secondaryDarkBackground)
  }
  static var tertiaryBackground: UIColor {
    return UIColor(light: tertiaryLightBackground, dark: tertiaryDarkBackground)
  }
  private static let primaryLightBackground = UIColor.white
  private static let primaryDarkBackground = UIColor(red: 0.11, green: 0.11, blue: 0.118, alpha: 0.94)
  private static let secondaryDarkBackground = UIColor(red: 0.11, green: 0.11, blue: 0.118, alpha: 1)
  private static let tertiaryLightBackground = UIColor(red: 0.463, green: 0.463, blue: 0.502, alpha: 0.12)
  private static let tertiaryDarkBackground = UIColor(red: 0.463, green: 0.463, blue: 0.502, alpha: 0.24)

  // Text Color
  static var primaryText: UIColor {
    return UIColor(light: primaryDarkText, dark: primaryLightText)
  }
  static var secondaryText: UIColor {
    return UIColor(light: secondaryDarkText, dark: secondaryLightText)
  }
  static var placeholderText: UIColor {
    return UIColor(light: primaryDarkText, dark: secondaryLightText)
  }
  private static let primaryDarkText = UIColor.black
  private static let primaryLightText = UIColor.white
  private static let secondaryDarkText = UIColor(red: 0.235, green: 0.235, blue: 0.263, alpha: 0.6)
  private static let secondaryLightText = UIColor(red: 0.922, green: 0.922, blue: 0.961, alpha: 0.6)

  convenience init(
    light lightModeColor: @escaping @autoclosure () -> UIColor,
    dark darkModeColor: @escaping @autoclosure () -> UIColor
  ) {
    self.init { traitCollection in
      switch traitCollection.userInterfaceStyle {
      case .light:
        return lightModeColor()
      case .dark:
        return darkModeColor()
      case .unspecified:
        return lightModeColor()
      @unknown default:
        return lightModeColor()
      }
    }
  }
}

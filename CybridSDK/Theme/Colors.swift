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
    return UIColor(light: lightBackground, dark: darkBackground)
  }
  static var secondaryBackground: UIColor {
    return UIColor(light: lightBackground, dark: secondaryDarkBackground)
  }
  private static let lightBackground = UIColor.white
  private static let darkBackground = UIColor(red: 0.11, green: 0.11, blue: 0.118, alpha: 0.94)
  private static let secondaryDarkBackground = UIColor(red: 0.11, green: 0.11, blue: 0.118, alpha: 1)

  // Text Color
  static var primaryText: UIColor {
    return UIColor(light: primaryDarkText, dark: primaryLightText)
  }
  static var secondaryText: UIColor {
    return UIColor(light: secondaryDarkText, dark: secondaryLightText)
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

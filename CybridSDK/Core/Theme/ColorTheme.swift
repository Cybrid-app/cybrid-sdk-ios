//
//  ColorTheme.swift
//  CybridSDK
//
//  Created by Cybrid on 21/06/22.
//

import UIKit

public struct ColorTheme: Equatable {
  static var `default` = makeDefaultColorTheme()

  // Background Colors
  let primaryBackgroundColor: UIColor
  let secondaryBackgroundColor: UIColor
  let tertiaryBackgroundColor: UIColor

  // Text Color
  let primaryTextColor: UIColor
  let secondaryTextColor: UIColor

  static func makeDefaultColorTheme(overrideUserInterfaceStyle: UIUserInterfaceStyle? = nil) -> ColorTheme {
    return ColorTheme(
      primaryBackgroundColor: UIColor(
        light: UIConstants.lightestColor,
        dark: UIConstants.gray800,
        overrideUserInterfaceStyle: overrideUserInterfaceStyle),
      secondaryBackgroundColor: UIColor(
        light: UIConstants.lightestColor,
        dark: UIConstants.gray900,
        overrideUserInterfaceStyle: overrideUserInterfaceStyle),
      tertiaryBackgroundColor: UIColor(
        light: UIConstants.gray200,
        dark: UIConstants.gray300,
        overrideUserInterfaceStyle: overrideUserInterfaceStyle),
      primaryTextColor: UIColor(
        light: UIConstants.darkestColor,
        dark: UIConstants.lightestColor,
        overrideUserInterfaceStyle: overrideUserInterfaceStyle),
      secondaryTextColor: UIColor(
        light: UIConstants.gray400,
        dark: UIConstants.gray100,
        overrideUserInterfaceStyle: overrideUserInterfaceStyle)
    )
  }
}
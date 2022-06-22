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
        light: Tokens.lightestColor,
        dark: Tokens.gray800,
        overrideUserInterfaceStyle: overrideUserInterfaceStyle),
      secondaryBackgroundColor: UIColor(
        light: Tokens.lightestColor,
        dark: Tokens.gray900,
        overrideUserInterfaceStyle: overrideUserInterfaceStyle),
      tertiaryBackgroundColor: UIColor(
        light: Tokens.gray200,
        dark: Tokens.gray300,
        overrideUserInterfaceStyle: overrideUserInterfaceStyle),
      primaryTextColor: UIColor(
        light: Tokens.darkestColor,
        dark: Tokens.lightestColor,
        overrideUserInterfaceStyle: overrideUserInterfaceStyle),
      secondaryTextColor: UIColor(
        light: Tokens.gray400,
        dark: Tokens.gray100,
        overrideUserInterfaceStyle: overrideUserInterfaceStyle)
    )
  }
}

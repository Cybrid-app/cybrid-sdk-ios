//
//  ColorTheme.swift
//  CybridSDK
//
//  Created by Cybrid on 21/06/22.
//

import UIKit

public struct ColorTheme {
  static let `default` = ColorTheme(
    primaryBackgroundColor: UIColor(
      light: Tokens.lightestColor,
      dark: Tokens.gray800),
    secondaryBackgroundColor: UIColor(
      light: Tokens.lightestColor,
      dark: Tokens.gray900),
    tertiaryBackgroundColor: UIColor(
      light: Tokens.gray200,
      dark: Tokens.gray300),
    primaryTextColor: UIColor(
      light: Tokens.darkestColor,
      dark: Tokens.lightestColor),
    secondaryTextColor: UIColor(
      light: Tokens.gray400,
      dark: Tokens.gray100)
  )

  // Background Colors
  let primaryBackgroundColor: UIColor
  let secondaryBackgroundColor: UIColor
  let tertiaryBackgroundColor: UIColor

  // Text Color
  let primaryTextColor: UIColor
  let secondaryTextColor: UIColor
}

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
  let textFieldBackgroundColor: UIColor
  let separatorColor: UIColor
  let disabledBackgroundColor: UIColor
  let accentColor: UIColor
  let shadowColor: UIColor

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
      textFieldBackgroundColor: UIColor(
        light: UIConstants.gray150,
        dark: UIConstants.gray300, // TODO: Define dark mode color
        overrideUserInterfaceStyle: overrideUserInterfaceStyle),
      separatorColor: UIColor(
        light: UIConstants.gray180,
        dark: UIConstants.gray300, // TODO: Define dark mode color
        overrideUserInterfaceStyle: overrideUserInterfaceStyle),
      disabledBackgroundColor: UIColor(
        light: UIConstants.gray250,
        dark: UIConstants.gray300, // TODO: Define dark mode color
        overrideUserInterfaceStyle: overrideUserInterfaceStyle),
      accentColor: UIColor(
        light: UIConstants.brightBlue,
        dark: UIConstants.brightBlue, // TODO: Define dark mode color
        overrideUserInterfaceStyle: overrideUserInterfaceStyle),
      shadowColor: UIColor(
        light: UIConstants.overlayShadow,
        dark: UIConstants.overlayShadow, // TODO: Define dark mode color
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

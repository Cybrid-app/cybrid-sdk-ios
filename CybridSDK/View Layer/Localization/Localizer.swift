//
//  Localizer.swift
//  CybridSDK
//
//  Created by Cybrid on 30/06/22.
//

import Foundation

protocol Localizer {
  func localize(with localizationKey: LocalizationKey,
                parameters: CustomStringConvertible...) -> String

  func localize(with localizationKey: String,
                parameters: CustomStringConvertible...) -> String
}

struct CybridLocalizer: Localizer {
  let locale: Locale

  init(locale: Locale? = nil) {
    self.locale = locale ?? Cybrid.getPreferredLocale()
  }

  func localize(with localizationKey: LocalizationKey,
                parameters: CustomStringConvertible...) -> String {
    return self.localize(with: localizationKey.stringValue, parameters: parameters)
  }

  func localize(with localizationKey: String,
                parameters: CustomStringConvertible...) -> String {
    let localizationBundle = Bundle.localizationBundle(forLocale: locale)
    let localizedStringFormat = localizationBundle.localizedString(
      forKey: localizationKey,
      value: nil,
      table: nil
    )
    return String.localizedStringWithFormat(localizedStringFormat, parameters)
  }
}

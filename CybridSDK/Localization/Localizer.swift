//
//  Localizer.swift
//  CybridSDK
//
//  Created by Cybrid on 30/06/22.
//

import Foundation

struct CybridLocalizer {
  let localizationBundle = Bundle(for: CybridConfig.self)

  func localize(with localizationKey: CybridLocalizationKey, arguments: [CustomStringConvertible]) -> String {
    let localizedStringFormat = localizationBundle.localizedString(forKey: localizationKey.stringValue,
                                                                   value: nil,
                                                                   table: nil)
    return String.localizedStringWithFormat(localizedStringFormat, arguments)
  }

  func localize(with localizationKey: CybridLocalizationKey, parameters: CustomStringConvertible...) -> String {
    let localizedStringFormat = localizationBundle.localizedString(forKey: localizationKey.stringValue,
                                                                   value: nil,
                                                                   table: nil)
    return String.localizedStringWithFormat(localizedStringFormat, parameters)
  }
}

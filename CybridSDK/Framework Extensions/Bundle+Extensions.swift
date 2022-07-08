//
//  Bundle+Extensions.swift
//  CybridSDK
//
//  Created by Cybrid on 7/07/22.
//

import Foundation

extension Bundle {
  static var sdkBundle: Bundle {
    Bundle(for: CybridConfig.self)
  }

  static func localizationBundle(forLocale locale: Locale) -> Bundle {
    let localeBundlePath = sdkBundle.path(
      forResource: locale.languageCode,
      ofType: "lproj"
    )
    return Bundle(path: localeBundlePath ?? "") ?? sdkBundle
  }
}

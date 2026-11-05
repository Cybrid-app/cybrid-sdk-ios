//
//  Bundle+Extensions.swift
//  CybridSDK
//
//  Created by Cybrid on 7/07/22.
//

import Foundation

extension Bundle {
  static var sdkBundle: Bundle {
    #if SWIFT_PACKAGE
    Bundle.module
    #else
    Bundle(for: CybridConfig.self)
    #endif
  }

  static func localizationBundle(forLocale locale: Locale) -> Bundle {
    let localeBundlePath = sdkBundle.path(
      forResource: locale.languageCode,
      ofType: "lproj"
    )
    return Bundle(path: localeBundlePath ?? "") ?? sdkBundle
  }
}

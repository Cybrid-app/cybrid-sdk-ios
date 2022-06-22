//
//  FontTheme.swift
//  CybridSDK
//
//  Created by Cybrid on 21/06/22.
//

import UIKit

public struct FontTheme: Equatable {
  static let `default` = FontTheme(
    bodyLarge: UIFont.systemFont(ofSize: Tokens.fontSizeLg, weight: .regular),
    body: UIFont.systemFont(ofSize: Tokens.fontSizeMd, weight: .regular),
    caption: UIFont.systemFont(ofSize: Tokens.fontSizeSm, weight: .regular)
  )

  let bodyLarge: UIFont
  let body: UIFont
  let caption: UIFont

  public init(bodyLarge: UIFont, body: UIFont, caption: UIFont) {
    self.bodyLarge = bodyLarge
    self.body = body
    self.caption = caption
  }
}

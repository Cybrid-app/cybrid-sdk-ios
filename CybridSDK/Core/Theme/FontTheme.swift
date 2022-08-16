//
//  FontTheme.swift
//  CybridSDK
//
//  Created by Cybrid on 21/06/22.
//

import UIKit

public struct FontTheme: Equatable {
  static let `default` = FontTheme(
    header: UIFont.systemFont(ofSize: UIConstants.fontSizeXl, weight: .regular),
    bodyLarge: UIFont.systemFont(ofSize: UIConstants.fontSizeLg, weight: .regular),
    body: UIFont.systemFont(ofSize: UIConstants.fontSizeMd, weight: .regular),
    bodyStrong: UIFont.systemFont(ofSize: UIConstants.fontSizeMd, weight: .bold),
    caption: UIFont.systemFont(ofSize: UIConstants.fontSizeSm, weight: .regular)
  )

  let header: UIFont
  let body: UIFont
  let bodyLarge: UIFont
  let bodyStrong: UIFont
  let caption: UIFont

  public init(header: UIFont, bodyLarge: UIFont, body: UIFont, bodyStrong: UIFont, caption: UIFont) {
    self.header = header
    self.bodyLarge = bodyLarge
    self.body = body
    self.bodyStrong = bodyStrong
    self.caption = caption
  }
}

//
//  FontTheme.swift
//  CybridSDK
//
//  Created by Cybrid on 21/06/22.
//

import UIKit

public struct FontTheme: Equatable {
  static let `default` = FontTheme(
    header1: UIFont.systemFont(ofSize: UIConstants.fontSizeH1, weight: .regular),
    header2: UIFont.systemFont(ofSize: UIConstants.fontSizeH2, weight: .regular),
    body: UIFont.systemFont(ofSize: UIConstants.fontSizeBody1, weight: .regular),
    body2: UIFont.systemFont(ofSize: UIConstants.fontSizeBody2, weight: .regular),
    caption: UIFont.systemFont(ofSize: UIConstants.fontSizeCaption, weight: .regular)
  )

  let header1: UIFont
  let header2: UIFont
  let body: UIFont
  let body2: UIFont
  let caption: UIFont

  public init(header1: UIFont,
              header2: UIFont,
              body: UIFont,
              body2: UIFont,
              caption: UIFont) {
    self.header1 = header1
    self.header2 = header2
    self.body = body
    self.body2 = body2
    self.caption = caption
  }
}

//
//  UILabel+Extensions.swift
//  CybridSDK
//
//  Created by Cybrid on 21/06/22.
//

import UIKit

extension UILabel {
  
  public enum Side {
    case left
    case right
  }
  
  static func makeLabel(with style: FormatStyle, _ onDidMake: @escaping (UILabel) -> Void) -> UILabel {
    let label = UILabel()
    label.formatLabel(with: style)
    onDidMake(label)
    return label
  }

  func formatLabel(with style: FormatStyle) {
    numberOfLines = 0
    translatesAutoresizingMaskIntoConstraints = false
    sizeToFit()
    font = style.font
    textColor = style.textColor
    if style.isUppercased {
      text = text?.uppercased()
    }
  }
}

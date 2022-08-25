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
    case center
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

  func setAttributedText(
    mainText: String,
    mainTextFont: UIFont,
    mainTextColor: UIColor?,
    attributedText: String,
    attributedTextFont: UIFont,
    attributedTextColor: UIColor?,
    side: UILabel.Side = .center) {

    let paragraphStyle = NSMutableParagraphStyle()
    switch side {
    case .left:
      paragraphStyle.alignment = .left
    case .right:
      paragraphStyle.alignment = .right
    case .center:
      paragraphStyle.alignment = .center
    }
    let attributedTitle = NSMutableAttributedString(
      string: "\(mainText) \(attributedText)",
      attributes: [
        NSAttributedString.Key.paragraphStyle: paragraphStyle,
        NSAttributedString.Key.foregroundColor: mainTextColor,
        NSAttributedString.Key.font: mainTextFont
      ]
    )
    attributedTitle.addAttributes(
      [
        NSAttributedString.Key.foregroundColor: attributedTextColor,
        NSAttributedString.Key.font: attributedTextFont
      ],
      range: NSRange(location: mainText.count + 1, length: attributedText.count)
    )
    self.attributedText = attributedTitle
  }

  func setLocalizedText(key: String, localizer: Localizer) {

    let text = localizer.localize(with: key)
    self.text = text
  }
}

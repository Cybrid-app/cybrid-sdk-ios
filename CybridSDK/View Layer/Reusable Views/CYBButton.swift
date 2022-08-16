//
//  CYBButton.swift
//  CybridSDK
//
//  Created by Cybrid on 26/07/22.
//

import Foundation
import UIKit

final class CYBButton: UIButton {
  override var intrinsicContentSize: CGSize {
    let baseSize = super.intrinsicContentSize
    return CGSize(width: baseSize.width + Constants.horizontalPadding * 2,
                  height: baseSize.height)
  }
  override var isEnabled: Bool {
    didSet {
      setColor()
    }
  }

  let style: ButtonStyle
  let theme: Theme

  init(style: ButtonStyle = .primary, theme: Theme = CybridTheme.default) {
    self.style = style
    self.theme = theme
    super.init(frame: .zero)
    setupView()
  }

  @available(iOS, deprecated: 10, message: "You should never use this init method.")
  required init?(coder: NSCoder) {
    assertionFailure("init(coder:) should never be used")
    return nil
  }

  private func setupView() {
    layer.cornerRadius = Constants.cornerRadius
    setContentHuggingPriority(.required, for: .horizontal)
    translatesAutoresizingMaskIntoConstraints = false

    constraint(attribute: .height,
               relatedBy: .greaterThanOrEqual,
               toItem: nil,
               attribute: .notAnAttribute,
               constant: Constants.minimumHeight)

    setColor()
  }

  private func setColor() {
    switch style {
    case .primary:
      if isEnabled {
        backgroundColor = theme.colorTheme.accentColor
      } else {
        backgroundColor = theme.colorTheme.disabledBackgroundColor
      }
    case .secondary:
      if isEnabled {
        setTitleColor(theme.colorTheme.accentColor, for: .normal)
      } else {
        setTitleColor(theme.colorTheme.disabledBackgroundColor, for: .normal)
      }
    }
  }
}

// MARK: - Styles
extension CYBButton {
  enum ButtonStyle {
    case primary // highlighted
    case secondary // plain
  }
}

// MARK: - Constants

extension CYBButton {
  enum Constants {
    static let horizontalPadding: CGFloat = 20
    static let cornerRadius: CGFloat = UIConstants.radiusLg
    static let minimumHeight: CGFloat = UIConstants.minimumTargetSize
  }
}

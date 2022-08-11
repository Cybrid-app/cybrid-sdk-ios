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
      setBackgroundColor()
    }
  }

  let theme: Theme

  init(theme: Theme = CybridTheme.default) {
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
    setBackgroundColor()
  }

  private func setBackgroundColor() {
    if isEnabled {
      backgroundColor = theme.colorTheme.accentColor
    } else {
      backgroundColor = theme.colorTheme.disabledBackgroundColor
    }
  }
}

// MARK: - Constants

extension CYBButton {
  enum Constants {
    static let horizontalPadding: CGFloat = 20
    static let cornerRadius: CGFloat = UIConstants.radiusLg
  }
}

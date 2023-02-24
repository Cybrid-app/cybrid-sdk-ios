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

  var customState: ButtonState = .normal {
    didSet {
      switch customState {
      case .processing, .normal:
        isEnabled = true
      case .disabled:
        isEnabled = false
      }
      setColor()
      setContent()
    }
  }

  var action: () -> Void
  var title: String?
  let style: ButtonStyle
  let theme: Theme

  private lazy var spinner: UIActivityIndicatorView = {
    let spinner = UIActivityIndicatorView(style: .medium)
    spinner.color = UIColor.white
    return spinner
  }()

  init(title: String?,
       style: ButtonStyle = .primary,
       theme: Theme = CybridTheme.default,
       action: @escaping () -> Void) {
    self.action = action
    self.title = title
    self.style = style
    self.theme = theme
    super.init(frame: .zero)
    setupView()
    addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
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
    setContent()
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

  private func setContent() {
    switch customState {
    case .normal:
      spinner.stopAnimating()
      // restore title label
      setTitle(title, for: .normal)
      spinner.removeFromSuperview()
    case .disabled:
      spinner.stopAnimating()
      // restore title label
      setTitle(title, for: .normal)
      spinner.removeFromSuperview()
    case .processing:
      // create backup
      title = titleLabel?.text
      setTitle(nil, for: .normal)
      addSubview(spinner)
      spinner.constraint(attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX)
      spinner.constraint(attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY)
      spinner.startAnimating()
    }
    layoutSubviews()
  }

  @objc
  private func didTapButton() {
      action()
  }
}

// MARK: - Styles
extension CYBButton {
  enum ButtonStyle {
    case primary // highlighted
    case secondary // plain
  }
}

// MARK: - State
extension CYBButton {
  enum ButtonState {
    case normal
    case disabled
    case processing
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

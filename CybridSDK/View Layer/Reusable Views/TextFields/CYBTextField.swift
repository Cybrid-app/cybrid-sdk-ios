//
//  CYBTextField.swift
//  CybridSDK
//
//  Created by Cybrid on 6/08/22.
//

import Foundation
import UIKit

final class CYBTextField: UITextField {
  enum Icon {
    case text(String)
    case urlImage(_ url: String)
  }

  enum Style {
    case rounded
    case plain
  }

  let style: Style
  let theme: Theme
  private var icon: Icon?

  private var insets: UIEdgeInsets {
    return style == .rounded ? Constants.insets : .zero
  }

  private lazy var iconContainer: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()

  init(style: Style, icon: Icon?, theme: Theme) {
    self.style = style
    self.icon = icon
    self.theme = theme

    super.init(frame: CGRect.zero)
    setupView(theme: theme)
  }

  @available(iOS, deprecated: 10, message: "You should never use this init method.")
  required init?(coder: NSCoder) {
    assertionFailure("init(coder:) should never be used")
    return nil
  }

  func updateIcon(_ icon: Icon?) {
    self.icon = icon
    setupIcon()
  }

  private func setupView(theme: Theme) {
    switch style {
    case .rounded:
      backgroundColor = theme.colorTheme.textFieldBackgroundColor
      layer.cornerRadius = Constants.cornerRadius
      textColor = theme.colorTheme.primaryTextColor
    case .plain:
      backgroundColor = .clear
      borderStyle = UITextField.BorderStyle.none
      layer.cornerRadius = 0
      textColor = theme.colorTheme.secondaryTextColor
    }
    leftViewMode = .always
    leftView = iconContainer
    iconContainer.constraint(attribute: .width,
                             relatedBy: .equal,
                             toItem: nil,
                             attribute: .notAnAttribute,
                             constant: Constants.IconContainer.minWidth)
    setupIcon()
  }

  private func setupIcon() {
    iconContainer.subviews.forEach { subview in
      subview.removeFromSuperview()
    }
    switch icon {
    case .text(let content):
      setupTextIcon(content: content)
    case .urlImage(let imageURLString):
      setupImageIcon(urlString: imageURLString)
    case .none:
      return
    }
    layoutSubviews()
  }

  private func setupTextIcon(content: String) {
    let label = UILabel()
    label.text = content
    label.textColor = theme.colorTheme.secondaryTextColor
    label.translatesAutoresizingMaskIntoConstraints = false
    iconContainer.addSubview(label)
    let border = UIView()
    border.backgroundColor = theme.colorTheme.separatorColor
    border.translatesAutoresizingMaskIntoConstraints = false
    iconContainer.addSubview(border)

    label.constraintEdges(to: iconContainer)
    border.constraint(attribute: .leading, relatedBy: .equal, toItem: label, attribute: .trailing, constant: -7)
    border.constraint(attribute: .centerY, relatedBy: .equal, toItem: label, attribute: .centerY)
    border.constraint(attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, constant: 22)
    border.constraint(attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, constant: 1)
  }

  private func setupImageIcon(urlString: String) {
    guard let imageView = URLImageView(urlString: urlString) else { return }
    imageView.translatesAutoresizingMaskIntoConstraints = false
    iconContainer.addSubview(imageView)
    imageView.constraintEdges(to: iconContainer, insets: Constants.Icon.insets)
    imageView.constraint(attribute: .height,
                         relatedBy: .equal,
                         toItem: nil,
                         attribute: .notAnAttribute,
                         constant: Constants.Icon.size.height)
    imageView.constraint(attribute: .width,
                         relatedBy: .equal,
                         toItem: nil,
                         attribute: .notAnAttribute,
                         constant: Constants.Icon.size.width)
  }
}

extension CYBTextField {
  enum Constants {
    static let cornerRadius = UIConstants.radiusLg
    static let insets = UIEdgeInsets(top: 0,
                                     left: UIConstants.spacingMd,
                                     bottom: 0,
                                     right: UIConstants.spacingMd)
    enum IconContainer {
      static let minWidth: CGFloat = UIConstants.sizeLg
    }
    enum Icon {
      static let insets = UIEdgeInsets(top: 0,
                                       left: UIConstants.spacingXl2,
                                       bottom: 0,
                                       right: UIConstants.spacingMd)
      static let size = CGSize(width: UIConstants.sizeMd, height: UIConstants.sizeMd)
    }
  }
}

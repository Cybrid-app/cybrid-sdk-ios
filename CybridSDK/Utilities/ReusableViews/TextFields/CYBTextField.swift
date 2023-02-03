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
    case .plain:
      backgroundColor = .clear
      borderStyle = UITextField.BorderStyle.none
      layer.cornerRadius = 0
    }
    leftViewMode = .always
    leftView = iconContainer
    textColor = theme.colorTheme.primaryTextColor
    setupConstraints()
    setupIcon()
    setupUnderline()
  }

  private func setupConstraints() {
    iconContainer.constraint(attribute: .width,
                             relatedBy: .equal,
                             toItem: nil,
                             attribute: .notAnAttribute,
                             constant: Constants.IconContainer.minWidth)
    constraint(attribute: .height,
               relatedBy: .greaterThanOrEqual,
               toItem: nil,
               attribute: .notAnAttribute,
               constant: Constants.minHeight)
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
  }

  private func setupUnderline() {
    switch style {
    case .plain:
      let underline = UIView()
      underline.backgroundColor = theme.colorTheme.separatorColor
      underline.translatesAutoresizingMaskIntoConstraints = false
      self.addSubview(underline)
      underline.constraint(attribute: .leading,
                           relatedBy: .equal,
                           toItem: self,
                           attribute: .leading)
      underline.constraint(attribute: .trailing,
                           relatedBy: .equal,
                           toItem: self,
                           attribute: .trailing)
      underline.constraint(attribute: .top,
                           relatedBy: .equal,
                           toItem: self,
                           attribute: .bottom)
      underline.constraint(attribute: .height,
                           relatedBy: .equal,
                           toItem: nil,
                           attribute: .notAnAttribute,
                           constant: Constants.borderWidth)
    default:
      return
    }
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
    border.constraint(attribute: .leading,
                      relatedBy: .equal,
                      toItem: label,
                      attribute: .trailing,
                      constant: Constants.Divider.trailing)
    border.constraint(attribute: .centerY,
                      relatedBy: .equal,
                      toItem: label,
                      attribute: .centerY)
    border.constraint(attribute: .height,
                      relatedBy: .equal,
                      toItem: nil,
                      attribute: .notAnAttribute,
                      constant: Constants.Divider.height)
    border.constraint(attribute: .width,
                      relatedBy: .equal,
                      toItem: nil,
                      attribute: .notAnAttribute,
                      constant: Constants.borderWidth)
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
    static let minHeight: CGFloat = UIConstants.minimumTargetSize
    static let borderWidth: CGFloat = 1

    enum Divider {
      static let trailing: CGFloat = -7
      static let height: CGFloat = 22
    }

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
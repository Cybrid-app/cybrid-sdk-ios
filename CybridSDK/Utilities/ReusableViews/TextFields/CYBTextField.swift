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
        case image(_ name: String)
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
        setupConstraints()
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

        var widhtConstraint: CGFloat = Constants.IconContainer.minWidth
        if case .text(let value) = self.icon {
            if value.count > 3 {
                widhtConstraint = Constants.IconContainer.maxWidth
            }
        }

        iconContainer.removeConstraint(attribute: .width)
        iconContainer.constraint(attribute: .width,
                                 relatedBy: .equal,
                                 toItem: nil,
                                 attribute: .notAnAttribute,
                                 constant: widhtConstraint)
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
        case .image(let name):
            setupImage(name: name)
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
        label.accessibilityIdentifier = "CYBTextField_Left_Text"
        label.translatesAutoresizingMaskIntoConstraints = false
        iconContainer.addSubview(label)
        label.constraint(attribute: .top,
                         relatedBy: .equal,
                         toItem: iconContainer,
                         attribute: .topMargin,
                         constant: 0
        )
        label.constraint(attribute: .bottom,
                         relatedBy: .equal,
                         toItem: iconContainer,
                         attribute: .bottomMargin,
                         constant: 0
        )
        label.constraint(attribute: .leading,
                         relatedBy: .equal,
                         toItem: iconContainer,
                         attribute: .leading,
                         constant: 0
        )

        let border = UIView()
        border.backgroundColor = theme.colorTheme.separatorColor
        border.translatesAutoresizingMaskIntoConstraints = false
        iconContainer.addSubview(border)
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

    private func setupImage(name: String) {

        let image = UIImage(named: name, in: Bundle(for: Self.self), with: nil)!
        let imageView = UIImageView(image: image)
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

            static let trailing: CGFloat = 8
            static let height: CGFloat = 22
        }

        enum IconContainer {

            static let minWidth: CGFloat = UIConstants.sizeLg
            static let maxWidth: CGFloat = 62
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

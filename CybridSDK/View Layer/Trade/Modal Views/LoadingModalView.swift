//
//  LoadingModalView.swift
//  CybridSDK
//
//  Created by Cybrid on 16/08/22.
//

import UIKit

final class LoadingModalView: UIView {
  private let message: String
  private let theme: Theme

  private lazy var contentStackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [
      titleLabel,
      spinner
    ])
    stackView.axis = .vertical
    stackView.spacing = Constants.spacing
    stackView.alignment = .center
    return stackView
  }()

  private lazy var titleLabel: UILabel = .makeLabel(.header1) { [weak self] label in
    label.text = self?.message ?? ""
    label.textAlignment = .center
  }

  private lazy var spinner: UIActivityIndicatorView = {
    let indicator = UIActivityIndicatorView(style: .large)
    indicator.color = theme.colorTheme.accentColor
    return indicator
  }()

  init(message: String, theme: Theme = Cybrid.theme) {
    self.message = message
    self.theme = theme

    super.init(frame: .zero)

    setupViews()
  }

  @available(iOS, deprecated: 10, message: "You should never use this init method.")
  required init?(coder: NSCoder) {
    assertionFailure("init(coder:) should never be used")
    return nil
  }

  private func setupViews() {
    contentStackView.translatesAutoresizingMaskIntoConstraints = false
    addSubview(contentStackView)

    contentStackView.constraintEdges(to: self, insets: .init(top: 94, left: 0, bottom: 94, right: 0))
    spinner.startAnimating()
  }
}

// MARK: - Constants

extension LoadingModalView {
  enum Constants {
    static let spacing: CGFloat = UIConstants.spacingXl2
  }
}

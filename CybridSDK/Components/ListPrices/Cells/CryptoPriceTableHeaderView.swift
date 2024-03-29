//
//  CryptoPriceTableHeaderView.swift
//  CybridSDK
//
//  Created by Cybrid on 21/06/22.
//

import UIKit

class CryptoPriceTableHeaderView: UITableViewHeaderFooterView {
  private let localizer: Localizer

  private lazy var searchTextField: UISearchTextField = {
    let searchBar = UISearchTextField()
    let placeholder = NSAttributedString(
      string: localizer.localize(with: CybridLocalizationKey.cryptoPriceList(.headerSearchPlaceholder)),
      attributes: [
        NSAttributedString.Key.foregroundColor: FormatStyle.inputPlaceholder.textColor,
        NSAttributedString.Key.font: FormatStyle.inputPlaceholder.font
      ]
    )
    searchBar.attributedPlaceholder = placeholder
    searchBar.textColor = FormatStyle.header2.textColor
    searchBar.font = FormatStyle.inputPlaceholder.font
    searchBar.tintColor = FormatStyle.header2.textColor
    return searchBar
  }()

  private lazy var contentStackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [
      nameLabel,
      priceLabel
    ])
    stackView.axis = .horizontal
    stackView.spacing = Constants.ContentStackView.itemSpacing
    stackView.distribution = .fill
    stackView.alignment = .center
    return stackView
  }()

  private lazy var nameLabel: UILabel = {
    let label = UILabel()
    label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
    label.setContentHuggingPriority(.defaultHigh, for: .vertical)
    label.translatesAutoresizingMaskIntoConstraints = false
    label.baselineAdjustment = .alignCenters
    label.sizeToFit()
    label.font = FormatStyle.header4.font
    label.textColor = FormatStyle.header4.textColor
    let text = localizer.localize(with: CybridLocalizationKey.cryptoPriceList(.headerCurrency))
    label.text = text.uppercased()
    return label
  }()

  private lazy var priceLabel: UILabel = {
    let label = UILabel()
    label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    label.translatesAutoresizingMaskIntoConstraints = false
    label.sizeToFit()
    label.font = FormatStyle.header4.font
    label.textColor = FormatStyle.header4.textColor
    let text = localizer.localize(with: CybridLocalizationKey.cryptoPriceList(.headerPrice))
    label.text = text.uppercased()
    return label
  }()

  convenience init(delegate: UISearchTextFieldDelegate?) {
    self.init(reuseIdentifier: nil)
    searchTextField.delegate = delegate
  }

  override init(reuseIdentifier: String?) {
    self.localizer = CybridLocalizer()
    super.init(reuseIdentifier: reuseIdentifier)
    setupView()
  }

  @available(iOS, deprecated: 10, message: "You should never use this init method.")
  required init?(coder: NSCoder) {
    assertionFailure("init(coder:) should never be used")
    return nil
  }

  // MARK: Private functions

  private func setupView() {
    setupSearchBar()
    setupContentStackView()
  }

  private func setupSearchBar() {
    addSubview(searchTextField)
    searchTextField.translatesAutoresizingMaskIntoConstraints = false
    searchTextField.constraint(attribute: .top,
                               relatedBy: .equal,
                               toItem: self,
                               attribute: .top,
                               constant: Constants.SearchBar.topMargin)
    searchTextField.constraint(attribute: .leading,
                               relatedBy: .equal,
                               toItem: self,
                               attribute: .leading,
                               constant: Constants.ContentStackView.horizontalMargin)
    searchTextField.constraint(attribute: .trailing,
                               relatedBy: .equal,
                               toItem: self,
                               attribute: .trailing,
                               constant: -Constants.ContentStackView.horizontalMargin)
    searchTextField.constraint(attribute: .height,
                               relatedBy: .equal,
                               toItem: nil,
                               attribute: .notAnAttribute,
                               constant: Constants.SearchBar.height)
  }

  private func setupContentStackView() {
    addSubview(contentStackView)
    contentStackView.translatesAutoresizingMaskIntoConstraints = false
    contentStackView.constraint(attribute: .top,
                                relatedBy: .equal,
                                toItem: searchTextField,
                                attribute: .bottom,
                                constant: Constants.SearchBar.bottomMargin)
    contentStackView.constraint(attribute: .bottom,
                                relatedBy: .equal,
                                toItem: self,
                                attribute: .bottom,
                                constant: -Constants.ContentStackView.verticalMargin)
    contentStackView.constraint(attribute: .leading,
                                relatedBy: .equal,
                                toItem: self,
                                attribute: .leading,
                                constant: Constants.ContentStackView.horizontalMargin)
    contentStackView.constraint(attribute: .trailing,
                                relatedBy: .equal,
                                toItem: self,
                                attribute: .trailing,
                                constant: -Constants.ContentStackView.horizontalMargin)
  }
}

// MARK: - Constants

extension CryptoPriceTableHeaderView {
  enum Constants {
    enum SearchBar {
      static let topMargin: CGFloat = 0
      static let bottomMargin: CGFloat = UIConstants.spacingXl4 // 32.0
      static let height: CGFloat = UIConstants.minimumTargetSize // 44.0
    }
    enum ContentStackView {
      static let itemSpacing: CGFloat = UIConstants.spacingLg // 10.0
      static let horizontalMargin: CGFloat = UIConstants.spacingXl2 // 16.0
      static let verticalMargin: CGFloat = UIConstants.spacingLg // 10.0
    }
    enum Icon {
      static let size = CGSize(width: UIConstants.sizeMd, height: UIConstants.sizeMd)
    }
  }
}

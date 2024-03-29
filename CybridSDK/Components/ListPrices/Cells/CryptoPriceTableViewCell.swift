//
//  CryptoPriceTableViewCell.swift
//  CybridSDK
//
//  Created by Cybrid on 20/06/22.
//

import UIKit

class CryptoPriceTableViewCell: UITableViewCell {

  static let reuseIdentifier: String = "cryptoPriceTableViewCell"
  override var reuseIdentifier: String? { Self.reuseIdentifier }

  private lazy var contentStackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [
      iconImage,
      nameLabel,
      priceLabel

    ])
    stackView.axis = .horizontal
    stackView.spacing = Constants.ContentStackView.itemSpacing
    stackView.distribution = .fill
    stackView.alignment = .center
    return stackView
  }()
  private lazy var nameLabel = UILabel.makeLabel(.header2) { label in
    label.setContentCompressionResistancePriority(.defaultHigh - 1, for: .horizontal)
    label.setContentHuggingPriority(.required, for: .horizontal)
    label.setContentHuggingPriority(.defaultHigh, for: .vertical)
  }
  private var priceLabel = UILabel.makeLabel(.body) { label in
    label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
    label.setContentHuggingPriority(.defaultHigh, for: .vertical)
  }
  private var iconImage = URLImageView(url: nil)
  private let theme: Theme

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    self.theme = Cybrid.theme
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupView()
  }

  @available(iOS, deprecated: 10, message: "You should never use this init method.")
  required init?(coder: NSCoder) {
    assertionFailure("init(coder:) should never be used")
    return nil
  }

  // MARK: Private functions

  private func setupView() {
    backgroundColor = theme.colorTheme.primaryBackgroundColor
    setupIcon()
    setupContentStackView()
  }

  private func setupContentStackView() {
    addSubview(contentStackView)
    contentStackView.translatesAutoresizingMaskIntoConstraints = false
    contentStackView.constraint(attribute: .top,
                                relatedBy: .equal,
                                toItem: self,
                                attribute: .top,
                                constant: Constants.ContentStackView.verticalMargin)
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

  private func setupIcon() {
    iconImage.translatesAutoresizingMaskIntoConstraints = false
    iconImage.constraint(attribute: .height,
                         relatedBy: .equal,
                         toItem: nil,
                         attribute: .notAnAttribute,
                         constant: Constants.Icon.size.height)
    iconImage.constraint(attribute: .width,
                         relatedBy: .equal,
                         toItem: nil,
                         attribute: .notAnAttribute,
                         constant: Constants.Icon.size.width)
  }

  private func customizeNameLabel(with dataModel: CryptoPriceModel) {
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.alignment = .left
    let currencyTitle = dataModel.assetName + " " + dataModel.assetCode.uppercased()
    let attributedTitle = NSMutableAttributedString(
      string: currencyTitle,
      attributes: [
        NSAttributedString.Key.paragraphStyle: paragraphStyle,
        NSAttributedString.Key.foregroundColor: FormatStyle.header2.textColor,
        NSAttributedString.Key.font: FormatStyle.header2.font
      ]
    )
    attributedTitle.addAttributes(
      [
        NSAttributedString.Key.foregroundColor: FormatStyle.caption.textColor,
        NSAttributedString.Key.font: FormatStyle.caption.font
      ],
      range: NSRange(location: dataModel.assetName.count + 1, length: dataModel.assetCode.count)
    )
    nameLabel.attributedText = attributedTitle
  }

  private func customizePriceLabel(with dataModel: CryptoPriceModel) {
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.alignment = .right
    let fiatCodeString = "(\(dataModel.counterAssetCode.uppercased()))"
    let priceLabelText = dataModel.formattedPrice + " " + fiatCodeString
    let attributedTitle = NSMutableAttributedString(
      string: priceLabelText,
      attributes: [
        NSAttributedString.Key.paragraphStyle: paragraphStyle,
        NSAttributedString.Key.foregroundColor: FormatStyle.body.textColor,
        NSAttributedString.Key.font: FormatStyle.body.font
      ]
    )
    attributedTitle.addAttributes(
      [
        NSAttributedString.Key.foregroundColor: FormatStyle.caption.textColor,
        NSAttributedString.Key.font: FormatStyle.caption.font
      ],
      range: NSRange(location: dataModel.formattedPrice.count + 1, length: fiatCodeString.count)
    )
    priceLabel.attributedText = attributedTitle
  }

  // MARK: Internal functions

  func customize(dataModel: CryptoPriceModel) {
    customizeNameLabel(with: dataModel)
    customizePriceLabel(with: dataModel)
    iconImage.setURL(dataModel.imageURL)
  }
}

// MARK: - Constants

extension CryptoPriceTableViewCell {
  enum Constants {
    enum ContentStackView {
      static let itemSpacing: CGFloat = 10
      static let horizontalMargin: CGFloat = 16
      static let verticalMargin: CGFloat = 10
    }
    enum Icon {
      static let size = CGSize(width: 24, height: 24)
    }
  }
}

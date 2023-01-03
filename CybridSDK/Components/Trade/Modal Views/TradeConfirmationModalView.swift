//
//  TradeConfirmationModalView.swift
//  CybridSDK
//
//  Created by Cybrid on 16/08/22.
//

import BigInt
import CybridApiBankSwift
import UIKit

final class TradeConfirmationModalView: UIView {

  private var dataModel: DataModel
  private let localizer: Localizer
  private let theme: Theme
  private var onCancel: (() -> Void)?
  private var onConfirm: (() -> Void)?

  private lazy var contentStackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [
      titleLabel,
      disclosureLabel,
      fiatAmountTitleLabel,
      fiatAmountLabel,
      cryptoAmountTitleLabel,
      cryptoAmountLabel,
      feeAmountTitleLabel,
      feeAmountLabel,
      divider,
      buttonStackView
    ])
    stackView.axis = .vertical
    stackView.setCustomSpacing(Constants.titleSpacing, after: titleLabel)
    stackView.setCustomSpacing(Constants.subtitleSpacing, after: disclosureLabel)
    stackView.setCustomSpacing(Constants.fiatAmountTitleSpacing, after: fiatAmountTitleLabel)
    stackView.setCustomSpacing(Constants.fiatAmountSpacing, after: fiatAmountLabel)
    stackView.setCustomSpacing(Constants.cryptoAmountTitleSpacing, after: cryptoAmountTitleLabel)
    stackView.setCustomSpacing(Constants.cryptoAmountSpacing, after: cryptoAmountLabel)
    stackView.setCustomSpacing(Constants.feeAmountTitleSpacing, after: feeAmountTitleLabel)
    stackView.setCustomSpacing(Constants.feeAmountSpacing, after: feeAmountLabel)
    stackView.setCustomSpacing(Constants.dividerSpacing, after: divider)
    return stackView
  }()

  private lazy var titleLabel: UILabel = .makeLabel(.header1) { [localizer] label in
    label.text = localizer.localize(with: CybridLocalizationKey.trade(.confirmationModal(.title)))
  }

  private lazy var disclosureLabel: UILabel = .makeLabel(.disclaimer) { [localizer] label in
    label.text = localizer.localize(with: CybridLocalizationKey.trade(.confirmationModal(.subtitle)))
    label.sizeToFit()
  }

  private lazy var fiatAmountTitleLabel: UILabel = .makeLabel(.caption) { [localizer] label in
    label.text = localizer.localize(with: CybridLocalizationKey.trade(.confirmationModal(.purchaseAmount)))
  }

  private lazy var fiatAmountLabel: UILabel = .makeLabel(.body)

  private lazy var cryptoAmountTitleLabel: UILabel = .makeLabel(.caption) { [localizer] label in
    label.text = localizer.localize(with: CybridLocalizationKey.trade(.confirmationModal(.purchaseQuantity)))
  }

  private lazy var cryptoAmountLabel: UILabel = .makeLabel(.body)

  private lazy var feeAmountTitleLabel: UILabel = .makeLabel(.caption) { [localizer] label in
    label.text = localizer.localize(with: CybridLocalizationKey.trade(.confirmationModal(.transactionFee)))
  }

  private lazy var feeAmountLabel: UILabel = .makeLabel(.body)

  private lazy var divider: UIView = {
    let underline = UIView()
    underline.backgroundColor = theme.colorTheme.separatorColor
    underline.translatesAutoresizingMaskIntoConstraints = false
    return underline
  }()

  private lazy var buttonStackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [cancelButton, confirmButton])
    stackView.axis = .horizontal
    stackView.alignment = .trailing
    stackView.distribution = .fillEqually
    return stackView
  }()

  private lazy var confirmButton: CYBButton = {
    let button = CYBButton(
      title: localizer.localize(with: CybridLocalizationKey.trade(.confirmationModal(.confirm))),
      theme: theme
    ) { [weak self] in
      self?.didTapConfirmButton()
    }
    return button
  }()

  private lazy var cancelButton: CYBButton = {
    let button = CYBButton(
      title: localizer.localize(with: CybridLocalizationKey.trade(.confirmationModal(.cancel))),
      style: .secondary,
      theme: theme
    ) { [weak self] in
      self?.didTapCancelButton()
    }
    return button
  }()

  init(theme: Theme, localizer: Localizer, dataModel: DataModel, onCancel: (() -> Void)?, onConfirm: (() -> Void)?) {
    self.dataModel = dataModel
    self.localizer = localizer
    self.theme = theme
    self.onCancel = onCancel
    self.onConfirm = onConfirm

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

    contentStackView.constraintEdges(to: self)
    setupAmountLabels()
    divider.constraint(attribute: .width,
                       relatedBy: .equal,
                       toItem: contentStackView,
                       attribute: .width)
    divider.constraint(attribute: .height,
                       relatedBy: .equal,
                       toItem: nil,
                       attribute: .notAnAttribute,
                       constant: Constants.borderWidth)
  }

  func setupAmountLabels() {
    cryptoAmountLabel.text = dataModel.cryptoAmount + " " + dataModel.cryptoCode
    fiatAmountLabel.text = dataModel.fiatAmount + " " + dataModel.fiatCode
    feeAmountLabel.text = dataModel.transactionFee + " " + dataModel.fiatCode

    fiatAmountTitleLabel.text = dataModel.quoteType == .buy
      ? localizer.localize(with: CybridLocalizationKey.trade(.confirmationModal(.purchaseAmount)))
      : localizer.localize(with: CybridLocalizationKey.trade(.confirmationModal(.sellAmount)))
    cryptoAmountTitleLabel.text = dataModel.quoteType == .buy
      ? localizer.localize(with: CybridLocalizationKey.trade(.confirmationModal(.purchaseQuantity)))
      : localizer.localize(with: CybridLocalizationKey.trade(.confirmationModal(.sellQuantity)))
  }

  func didTapCancelButton() {
    onCancel?()
  }

  func didTapConfirmButton() {
    onConfirm?()
  }

  func updateData(_ dataModel: DataModel) {
    self.dataModel = dataModel
    setupAmountLabels()
  }
}

extension TradeConfirmationModalView {
  struct DataModel {
    let quoteGUID: String
    let fiatAmount: String
    let fiatCode: String
    let cryptoAmount: String
    let cryptoCode: String
    let transactionFee: String
    let quoteType: TradeType
  }
}

// MARK: - Constants

extension TradeConfirmationModalView {
  enum Constants {
    static let titleSpacing: CGFloat = UIConstants.spacingXl2
    static let subtitleSpacing: CGFloat = UIConstants.spacingXl3
    static let fiatAmountTitleSpacing: CGFloat = UIConstants.spacingXs
    static let fiatAmountSpacing: CGFloat = UIConstants.spacingXl3
    static let cryptoAmountTitleSpacing: CGFloat = UIConstants.spacingXs
    static let cryptoAmountSpacing: CGFloat = UIConstants.spacingXl3
    static let feeAmountTitleSpacing: CGFloat = UIConstants.spacingXs
    static let feeAmountSpacing: CGFloat = UIConstants.spacingXl3
    static let dividerSpacing: CGFloat = UIConstants.spacingXl3
    static let borderWidth: CGFloat = 1.0
  }
}

//
//  TradeConfirmationModalView.swift
//  CybridSDK
//
//  Created by Cybrid on 16/08/22.
//

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
    return stackView
  }()

  private lazy var titleLabel: UILabel = .makeLabel(.header) { [localizer] label in
    label.text = localizer.localize(with: CybridLocalizationKey.trade(.confirmationModal(.title)))
  }

  private lazy var disclosureLabel: UILabel = .makeLabel(.body) { [localizer] label in
    label.text = localizer.localize(with: CybridLocalizationKey.trade(.confirmationModal(.subtitle)))
    label.sizeToFit()
  }

  private lazy var fiatAmountTitleLabel: UILabel = .makeLabel(.bodyStrong) { [localizer] label in
    label.text = localizer.localize(with: CybridLocalizationKey.trade(.confirmationModal(.purchaseAmount)))
  }

  private lazy var fiatAmountLabel: UILabel = .makeLabel(.body)

  private lazy var cryptoAmountTitleLabel: UILabel = .makeLabel(.bodyStrong) { [localizer] label in
    label.text = localizer.localize(with: CybridLocalizationKey.trade(.confirmationModal(.purchaseQuantity)))
  }

  private lazy var cryptoAmountLabel: UILabel = .makeLabel(.body)

  private lazy var feeAmountTitleLabel: UILabel = .makeLabel(.bodyStrong) { [localizer] label in
    label.text = localizer.localize(with: CybridLocalizationKey.trade(.confirmationModal(.transactionFee)))
  }

  private lazy var feeAmountLabel: UILabel = .makeLabel(.body)

  private lazy var buttonStackView: UIStackView = {
    let spacerView = UIView()
    spacerView.setContentHuggingPriority(.fittingSizeLevel, for: .horizontal)
    let stackView = UIStackView(arrangedSubviews: [spacerView, cancelButton, confirmButton])
    stackView.axis = .horizontal
    stackView.alignment = .trailing
    stackView.distribution = .fill
    return stackView
  }()

  private lazy var confirmButton: CYBButton = {
    let button = CYBButton(theme: theme)
    button.setTitle(localizer.localize(with: CybridLocalizationKey.trade(.confirmationModal(.confirm))), for: .normal)
    button.addTarget(self, action: #selector(didTapConfirmButton), for: .touchUpInside)
    return button
  }()

  private lazy var cancelButton: CYBButton = {
    let button = CYBButton(style: .secondary, theme: theme)
    button.setTitle(localizer.localize(with: CybridLocalizationKey.trade(.confirmationModal(.cancel))), for: .normal)
    button.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
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

  @objc
  func didTapCancelButton() {
    onCancel?()
  }

  @objc
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
    let fiatAmount: String
    let fiatCode: String
    let cryptoAmount: String
    let cryptoCode: String
    let transactionFee: String
    let quoteType: TradeSegment
  }
}

// MARK: - Constants

extension TradeConfirmationModalView {
  enum Constants {
    static let titleSpacing: CGFloat = UIConstants.spacingXl2
    static let subtitleSpacing: CGFloat = UIConstants.spacingXl3
    static let fiatAmountTitleSpacing: CGFloat = UIConstants.spacingXs
    static let fiatAmountSpacing: CGFloat = UIConstants.spacingXl4
    static let cryptoAmountTitleSpacing: CGFloat = UIConstants.spacingXs
    static let cryptoAmountSpacing: CGFloat = UIConstants.spacingXl4
    static let feeAmountTitleSpacing: CGFloat = UIConstants.spacingXs
    static let feeAmountSpacing: CGFloat = UIConstants.spacingXl4
  }
}

//
//  TradeConfirmationModalView.swift
//  CybridSDK
//
//  Created by Cybrid on 16/08/22.
//

import CybridApiBankSwift
import UIKit

final class TradeConfirmationModalView: UIView {
  private var dataModel: QuoteDataModel
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
    stackView.setCustomSpacing(16, after: titleLabel)
    stackView.setCustomSpacing(24, after: disclosureLabel)
    stackView.setCustomSpacing(4, after: fiatAmountTitleLabel)
    stackView.setCustomSpacing(32, after: fiatAmountLabel)
    stackView.setCustomSpacing(4, after: cryptoAmountTitleLabel)
    stackView.setCustomSpacing(32, after: cryptoAmountLabel)
    stackView.setCustomSpacing(4, after: feeAmountTitleLabel)
    stackView.setCustomSpacing(32, after: feeAmountLabel)
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

  init(theme: Theme, localizer: Localizer, dataModel: QuoteDataModel, onCancel: (() -> Void)?, onConfirm: (() -> Void)?) {
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

  func updatePrices(cryptoAmount: String, fiatAmount: String, quoteType: QuoteDataModel.QuoteType) {
    var newDataModel = dataModel
    newDataModel.cryptoAmount = cryptoAmount
    newDataModel.fiatAmount = fiatAmount
    newDataModel.quoteType = quoteType
    self.dataModel = newDataModel
    setupAmountLabels()
  }
}

struct QuoteDataModel {
  enum QuoteType {
    case buy
    case sell
  }

  var fiatAmount: String
  let fiatCode: String
  var cryptoAmount: String
  let cryptoCode: String
  let transactionFee: String
  var quoteType: QuoteType
}

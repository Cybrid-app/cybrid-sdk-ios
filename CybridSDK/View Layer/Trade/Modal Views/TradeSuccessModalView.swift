//
//  TradeSuccessModalView.swift
//  CybridSDK
//
//  Created by Cybrid on 16/08/22.
//

import CybridApiBankSwift
import UIKit

final class TradeSuccessModalView: UIView {
  private var dataModel: QuoteDataModel
  private let localizer: Localizer
  private let theme: Theme
  private var onBuyMoreTap: (() -> Void)?

  private lazy var contentStackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [
      titleLabel,
      disclosureLabel,
      transactionTitleLabel,
      transactionIDLabel,
      dateTitleLabel,
      dateLabel,
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
    stackView.setCustomSpacing(4, after: transactionTitleLabel)
    stackView.setCustomSpacing(32, after: transactionIDLabel)
    stackView.setCustomSpacing(4, after: dateTitleLabel)
    stackView.setCustomSpacing(32, after: dateLabel)
    stackView.setCustomSpacing(4, after: fiatAmountTitleLabel)
    stackView.setCustomSpacing(32, after: fiatAmountLabel)
    stackView.setCustomSpacing(4, after: cryptoAmountTitleLabel)
    stackView.setCustomSpacing(32, after: cryptoAmountLabel)
    stackView.setCustomSpacing(4, after: feeAmountTitleLabel)
    stackView.setCustomSpacing(32, after: feeAmountLabel)
    return stackView
  }()

  private lazy var titleLabel: UILabel = .makeLabel(.header) { [localizer] label in
    label.text = localizer.localize(with: CybridLocalizationKey.trade(.successModal(.title)))
  }

  private lazy var disclosureLabel: UILabel = .makeLabel(.body) { [localizer] label in
    label.text = localizer.localize(with: CybridLocalizationKey.trade(.successModal(.subtitle)))
    label.sizeToFit()
  }

  private lazy var transactionTitleLabel: UILabel = .makeLabel(.bodyStrong) { [localizer] label in
    label.text = localizer.localize(with: CybridLocalizationKey.trade(.successModal(.transactionId)))
  }

  private lazy var transactionIDLabel: UILabel = .makeLabel(.bodyStrong) { label in
    label.text = "#980019" // FIXME: Replace this mocked data
  }

  private lazy var dateTitleLabel: UILabel = .makeLabel(.bodyStrong) { [localizer] label in
    label.text = localizer.localize(with: CybridLocalizationKey.trade(.successModal(.date)))
  }

  private lazy var dateLabel: UILabel = .makeLabel(.bodyStrong) { label in
    label.text = "August 16, 2022" // FIXME: Replace this mocked data
  }

  private lazy var fiatAmountTitleLabel: UILabel = .makeLabel(.bodyStrong) { [localizer] label in
    label.text = localizer.localize(with: CybridLocalizationKey.trade(.successModal(.purchaseAmount)))
  }

  private lazy var fiatAmountLabel: UILabel = .makeLabel(.body)

  private lazy var cryptoAmountTitleLabel: UILabel = .makeLabel(.bodyStrong) { [localizer] label in
    label.text = localizer.localize(with: CybridLocalizationKey.trade(.successModal(.purchaseQuantity)))
  }

  private lazy var cryptoAmountLabel: UILabel = .makeLabel(.body)

  private lazy var feeAmountTitleLabel: UILabel = .makeLabel(.bodyStrong) { [localizer] label in
    label.text = localizer.localize(with: CybridLocalizationKey.trade(.successModal(.transactionFee)))
  }

  private lazy var feeAmountLabel: UILabel = .makeLabel(.body)

  private lazy var buttonStackView: UIStackView = {
    let spacerView = UIView()
    spacerView.setContentHuggingPriority(.fittingSizeLevel, for: .horizontal)
    let stackView = UIStackView(arrangedSubviews: [spacerView, moreButton])
    stackView.axis = .horizontal
    stackView.alignment = .trailing
    stackView.distribution = .fill
    return stackView
  }()

  private lazy var moreButton: CYBButton = {
    let button = CYBButton(style: .secondary, theme: theme)
    button.setTitle(localizer.localize(with: CybridLocalizationKey.trade(.successModal(.buyMore))), for: .normal)
    button.addTarget(self, action: #selector(didTapBuyMoreButton), for: .touchUpInside)
    return button
  }()

  init(theme: Theme = Cybrid.theme, localizer: Localizer, dataModel: QuoteDataModel, onBuyMoreTap: (() -> Void)?) {
    self.dataModel = dataModel
    self.localizer = localizer
    self.theme = theme
    self.onBuyMoreTap = onBuyMoreTap

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
      ? localizer.localize(with: CybridLocalizationKey.trade(.successModal(.purchaseAmount)))
      : localizer.localize(with: CybridLocalizationKey.trade(.successModal(.sellAmount)))
    cryptoAmountTitleLabel.text = dataModel.quoteType == .buy
      ? localizer.localize(with: CybridLocalizationKey.trade(.successModal(.purchaseQuantity)))
      : localizer.localize(with: CybridLocalizationKey.trade(.successModal(.sellQuantity)))
    moreButton.setTitle(
      dataModel.quoteType == .buy
        ? localizer.localize(with: CybridLocalizationKey.trade(.successModal(.buyMore)))
        : localizer.localize(with: CybridLocalizationKey.trade(.successModal(.sellMore))),
      for: .normal
    )
  }

  @objc
  func didTapBuyMoreButton() {
    onBuyMoreTap?()
  }

  func updatePrices(cryptoAmount: String, fiatAmount: String) {
    var newDataModel = dataModel
    newDataModel.cryptoAmount = cryptoAmount
    newDataModel.fiatAmount = fiatAmount
    self.dataModel = newDataModel
    setupAmountLabels()
  }
}

//
//  TradeSuccessModalView.swift
//  CybridSDK
//
//  Created by Cybrid on 16/08/22.
//

import CybridApiBankSwift
import UIKit

final class TradeSuccessModalView: UIView {
  private var dataModel: DataModel
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
    stackView.setCustomSpacing(Constants.titleSpacing, after: titleLabel)
    stackView.setCustomSpacing(Constants.subtitleSpacing, after: disclosureLabel)
    stackView.setCustomSpacing(Constants.transactionTitleSpacing, after: transactionTitleLabel)
    stackView.setCustomSpacing(Constants.transactionIDSpacing, after: transactionIDLabel)
    stackView.setCustomSpacing(Constants.dateTitleSpacing, after: dateTitleLabel)
    stackView.setCustomSpacing(Constants.dateSpacing, after: dateLabel)
    stackView.setCustomSpacing(Constants.fiatAmountTitleSpacing, after: fiatAmountTitleLabel)
    stackView.setCustomSpacing(Constants.fiatAmountSpacing, after: fiatAmountLabel)
    stackView.setCustomSpacing(Constants.cryptoAmountTitleSpacing, after: cryptoAmountTitleLabel)
    stackView.setCustomSpacing(Constants.cryptoAmountSpacing, after: cryptoAmountLabel)
    stackView.setCustomSpacing(Constants.feeAmountTitleSpacing, after: feeAmountTitleLabel)
    stackView.setCustomSpacing(Constants.feeAmountSpacing, after: feeAmountLabel)
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

  private lazy var transactionIDLabel: UILabel = .makeLabel(.bodyStrong) { [dataModel] label in
    label.text = dataModel.transactionFee
  }

  private lazy var dateTitleLabel: UILabel = .makeLabel(.bodyStrong) { [localizer] label in
    label.text = localizer.localize(with: CybridLocalizationKey.trade(.successModal(.date)))
  }

  private lazy var dateLabel: UILabel = .makeLabel(.bodyStrong) { [dataModel] label in
    label.text = dataModel.date
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

  init(theme: Theme = Cybrid.theme, localizer: Localizer, dataModel: DataModel, onBuyMoreTap: (() -> Void)?) {
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
}

// MARK: - Constants

extension TradeSuccessModalView {
  enum Constants {
    static let titleSpacing: CGFloat = UIConstants.spacingXl2
    static let subtitleSpacing: CGFloat = UIConstants.spacingXl3
    static let transactionTitleSpacing: CGFloat = UIConstants.spacingXs
    static let transactionIDSpacing: CGFloat = UIConstants.spacingXl4
    static let dateTitleSpacing: CGFloat = UIConstants.spacingXs
    static let dateSpacing: CGFloat = UIConstants.spacingXl4
    static let fiatAmountTitleSpacing: CGFloat = UIConstants.spacingXs
    static let fiatAmountSpacing: CGFloat = UIConstants.spacingXl4
    static let cryptoAmountTitleSpacing: CGFloat = UIConstants.spacingXs
    static let cryptoAmountSpacing: CGFloat = UIConstants.spacingXl4
    static let feeAmountTitleSpacing: CGFloat = UIConstants.spacingXs
    static let feeAmountSpacing: CGFloat = UIConstants.spacingXl4
  }
}

extension TradeSuccessModalView {
  struct DataModel {
    let transactionId: String
    let date: String
    let fiatAmount: String
    let fiatCode: String
    let cryptoAmount: String
    let cryptoCode: String
    let transactionFee: String
    let quoteType: TradeSegment
  }
}

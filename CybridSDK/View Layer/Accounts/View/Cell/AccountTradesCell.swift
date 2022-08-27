//
//  File.swift
//  CybridSDK
//
//  Created by Erick Sanchez Perez on 26/08/22.
//

import Foundation
import UIKit

class AccountTradesCell: UITableViewCell {

    static let reuseIdentifier = "accountTradesCell"
    override var reuseIdentifier: String? { Self.reuseIdentifier }
    private let theme: Theme
    private var icon = UIImageView()
    private var tradeType = UILabel()
    private var tradeAmount = UILabel()
    private var tradeDate = UILabel()
    private var tradeAmountInFiat = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {

      self.theme = Cybrid.theme
      super.init(style: style, reuseIdentifier: reuseIdentifier)
      setupViews()
    }

    @available(iOS, deprecated: 10, message: "You should never use this init method.")
    required init?(coder: NSCoder) {
      assertionFailure("init(coder:) should never be used")
      return nil
    }

    private func setupViews() {

        backgroundColor = theme.colorTheme.primaryBackgroundColor
        self.setupIcon()
        self.setupLabels()

        // -- Vertical Stacks
        let leftSide = createVerticalStackView(
            top: tradeType,
            bottom: tradeDate)
        let rightSide = createVerticalStackView(
            top: tradeAmount,
            bottom: tradeAmountInFiat,
            withConstraints: true)

        // -- Horizontal Stack
        self.createStackView(left: icon,
                             center: leftSide,
                             right: rightSide)
    }

    func setData(trade: TradeUIModel) {

        self.setLabelsData(trade: trade)
    }
}

extension AccountTradesCell {

    private func setupIcon() {

        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.constraint(attribute: .height,
                        relatedBy: .equal,
                        toItem: nil,
                        attribute: .notAnAttribute,
                        constant: UIValues.iconWidht)
        icon.constraint(attribute: .width,
                        relatedBy: .equal,
                        toItem: nil,
                        attribute: .notAnAttribute,
                        constant: UIValues.iconHeight)
    }

    private func setupLabels() {

        // -- Trade Type
        self.setupBasicLabel(tradeType,
                             side: .left,
                             font: UIFont.make(ofSize: UIValues.tradeTypeSize),
                             color: UIValues.tradeTypeColor)

        // -- Trade Amount
        self.setupBasicLabel(tradeAmount,
                             side: .right,
                             font: UIFont.make(ofSize: UIValues.tradeAmountSize),
                             color: UIValues.tradeAmountColor)

        // -- Trade Date
        self.setupBasicLabel(tradeDate,
                             side: .left,
                             font: UIFont.make(ofSize: UIValues.tradeDateSize),
                             color: UIValues.tradeDateColor)

        // -- Trade Amount in Fiat
        self.setupBasicLabel(tradeAmountInFiat,
                             side: .right,
                             font: UIFont.make(ofSize: UIValues.tradeAmountInFiatSize),
                             color: UIValues.tradeAmountInFiatColor)
    }

    private func createVerticalStackView(top: UIView, bottom: UIView, withConstraints: Bool = false) -> UIStackView {

        let stack = UIStackView(arrangedSubviews: [top, bottom])
        if withConstraints {
            self.setConstraintsInVerticalStacks(view: top, parent: stack)
            self.setConstraintsInVerticalStacks(view: bottom, parent: stack)
        }
        stack.axis = .vertical
        stack.spacing = UIValues.verticalStakSeparation
        stack.distribution = .equalSpacing
        stack.alignment = .leading
        return stack
    }

    private func createStackView(left: UIView, center: UIView, right: UIView) {

      center.setContentCompressionResistancePriority(.defaultHigh - 1, for: .horizontal)
      center.setContentHuggingPriority(.required, for: .horizontal)
      center.setContentHuggingPriority(.defaultHigh, for: .vertical)

      right.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
      right.setContentHuggingPriority(.defaultHigh, for: .vertical)

      let contentStackView = UIStackView(arrangedSubviews: [left, center, right])
      contentStackView.axis = .horizontal
        contentStackView.spacing = UIValues.margin
      contentStackView.distribution = .fill
      contentStackView.alignment = .center
      addSubview(contentStackView)
      contentStackView.translatesAutoresizingMaskIntoConstraints = false
      contentStackView.constraint(attribute: .top,
                                  relatedBy: .equal,
                                  toItem: self,
                                  attribute: .top,
                                  constant: UIValues.margin)
      contentStackView.constraint(attribute: .bottom,
                                  relatedBy: .equal,
                                  toItem: self,
                                  attribute: .bottom,
                                  constant: -UIValues.margin)
      contentStackView.constraint(attribute: .leading,
                                  relatedBy: .equal,
                                  toItem: self,
                                  attribute: .leading,
                                  constant: UIValues.margin)
      contentStackView.constraint(attribute: .trailing,
                                  relatedBy: .equal,
                                  toItem: self,
                                  attribute: .trailing,
                                  constant: -UIValues.margin)
    }

    private func setupBasicLabel(_ label: UILabel, side: UILabel.Side, font: UIFont, color: UIColor?) {

        switch side {
        case .left:
            label.setContentCompressionResistancePriority(.defaultHigh - 1, for: .horizontal)
            label.setContentHuggingPriority(.required, for: .horizontal)
            label.setContentHuggingPriority(.defaultHigh, for: .vertical)

        case .right:
            label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
            label.setContentHuggingPriority(.defaultHigh, for: .vertical)
            label.textAlignment = .right

        case .center:
            label.textAlignment = .center
        }
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.sizeToFit()
        label.font = font
        label.textColor = color ?? UIColor.black
    }

    private func setConstraintsInVerticalStacks(view: UIView, parent: UIStackView) {

        view.constraint(attribute: .leading,
                        relatedBy: .equal,
                        toItem: parent,
                        attribute: .leading,
                        constant: UIConstants.zero)
        view.constraint(attribute: .trailing,
                        relatedBy: .equal,
                        toItem: parent,
                        attribute: .trailing,
                        constant: UIConstants.zero)
    }

    private func setLabelsData(trade: TradeUIModel) {

        // -- Setup icon
        icon.image = UIImage(
            named: trade.tradeBankModel.side == .sell ? "sellIcon" : "buyIcon",
            in: Bundle(for: Self.self),
            with: nil)

        // -- Trade Type
        let tradeTypeKey = (trade.tradeBankModel.side == .sell) ? UIString.tradeTYpeSell : UIString.tradeTypeBuy
        tradeType.setLocalizedText(key: tradeTypeKey, localizer: CybridLocalizer())

        // -- Trade Amount
        tradeAmount.setAttributedText(
            mainText: trade.getTradeAmount(),
            mainTextFont: UIFont.systemFont(ofSize: UIValues.tradeAmountSize, weight: .medium),
            mainTextColor: UIValues.tradeAmountColor,
            attributedText: trade.asset.code,
            attributedTextFont: UIFont.systemFont(ofSize: UIValues.tradeAmountCodeSize),
            attributedTextColor: UIValues.tradeAmountCodeColor,
            side: .right)

        // -- Trade Date
        tradeDate.text = getFormattedDate(trade.tradeBankModel.createdAt, format: "MMM dd, YYYY")

        // -- Trade Amount in Fiat
        tradeAmountInFiat.text = trade.getTradeFiatAmount()
    }
}

extension AccountTradesCell {

    enum UIString {

        static let tradeTYpeSell = "cybrid.account.trades.sellType"
        static let tradeTypeBuy = "cybrid.account.trades.buyType"
    }

    enum UIValues {

        // -- Sizes
        static let verticalStakSeparation: CGFloat = 3
        static let margin: CGFloat = 10
        static let iconWidht: CGFloat = 24
        static let iconHeight: CGFloat = 24
        static let tradeTypeSize: CGFloat = 14
        static let tradeAmountSize: CGFloat = 14
        static let tradeAmountCodeSize: CGFloat = 13
        static let tradeDateSize: CGFloat = 13
        static let tradeAmountInFiatSize: CGFloat = 14

        // -- Colors
        static let tradeTypeColor = UIColor.black
        static let tradeAmountColor = UIColor.black
        static let tradeAmountCodeColor = UIColor(hex: "#757575")
        static let tradeDateColor = UIColor(hex: "#636366")
        static let tradeAmountInFiatColor = UIColor(hex: "#636366")
    }
}

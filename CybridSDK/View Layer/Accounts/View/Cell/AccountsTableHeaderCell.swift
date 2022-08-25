//
//  AccountsTableHeaderCell.swift
//  CybridSDK
//
//  Created by Erick Sanchez Perez on 24/08/22.
//

import UIKit

class AccountsTableHeaderCell: UITableViewHeaderFooterView {

    private let localizer: Localizer
    private var currentCurrency: String = "USD"

    @available(iOS, deprecated: 10, message: "You should never use this init method.")
    required init?(coder: NSCoder) {
      assertionFailure("init(coder:) should never be used")
      return nil
    }

    override init(reuseIdentifier: String? = nil) {

        localizer = CybridLocalizer()
        super.init(reuseIdentifier: reuseIdentifier)
        self.setupViews()
    }

    convenience init(reuseIdentifier: String? = nil, currency: String = "USD") {

        self.init(reuseIdentifier: reuseIdentifier)
        self.currentCurrency = currency
    }

    func setupViews() {

        // -- Creating left view
        let asseTitle = createTitleLabel()
        asseTitle.setLocalizedText(key: UIStrings.asseTitle, localizer: localizer)

        let marketPriceLabel = createSubTitleLabel()
        marketPriceLabel.setLocalizedText(key: UIStrings.marketPriceTitle, localizer: localizer)

        let leftSide = createVerticalStack(
            labelOne: asseTitle,
            labelTwo: marketPriceLabel)

        // -- Creatin right side
        let balanceTitle = createTitleLabel()
        balanceTitle.setLocalizedText(key: UIStrings.balanceTitle, localizer: localizer)

        let currecnyTitle = createSubTitleLabel()
        currecnyTitle.text = self.currentCurrency
        currecnyTitle.textAlignment = .right

        let rightSide = createVerticalStack(
            labelOne: balanceTitle,
            labelTwo: currecnyTitle,
            withConstraints: true)

        // -- Join
        let stack = createHorizontalStack(one: leftSide, two: rightSide)
        addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = true
        self.setStackToMatchParent(stack: stack)
    }
}

extension AccountsTableHeaderCell {

    private func createTitleLabel() -> UILabel {

        let label = UILabel()
        label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.baselineAdjustment = .alignCenters
        label.sizeToFit()
        label.font = UIFont.make(ofSize: UIValues.assetTileSize)
        label.textColor = UIValues.assetTitleColor
        return label
    }

    private func createSubTitleLabel() -> UILabel {

        let label = UILabel()
        label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.baselineAdjustment = .alignCenters
        label.sizeToFit()
        label.font = UIFont.make(ofSize: UIValues.assetSubTitleSize)
        label.textColor = UIValues.assetSubTitleColor
        return label
    }

    private func createVerticalStack(labelOne: UILabel, labelTwo: UILabel, withConstraints: Bool = false) -> UIStackView {

        let stack = UIStackView(arrangedSubviews: [labelOne, labelTwo])
        if withConstraints {
            self.setConstraintsInVerticalStacks(view: labelOne, parent: stack)
            self.setConstraintsInVerticalStacks(view: labelTwo, parent: stack)
        }
        stack.axis = .vertical
        stack.spacing = UIValues.verticalStakSeparation
        stack.distribution = .equalSpacing
        stack.alignment = .leading
        return stack
    }

    private func createHorizontalStack(one: UIStackView, two: UIStackView) -> UIStackView {

        let stack = UIStackView(arrangedSubviews: [one, two])
        stack.axis = .horizontal
        stack.spacing = UIConstants.spacingLg
        stack.distribution = .fill
        stack.alignment = .center
        return stack
    }

    private func setStackToMatchParent(stack: UIStackView) {

        stack.constraint(attribute: .top,
                         relatedBy: .equal,
                         toItem: self,
                         attribute: .top,
                         constant: UIConstants.zero)
        stack.constraint(attribute: .bottom,
                         relatedBy: .equal,
                         toItem: self,
                         attribute: .bottom,
                         constant: UIConstants.zero)
        stack.constraint(attribute: .leading,
                         relatedBy: .equal,
                         toItem: self,
                         attribute: .leading,
                         constant: UIValues.cellHorizontalMargin)
        stack.constraint(attribute: .trailing,
                         relatedBy: .equal,
                         toItem: self,
                         attribute: .trailing,
                         constant: -UIValues.cellHorizontalMargin)
        stack.constraint(attribute: .height,
                         relatedBy: .equal,
                         toItem: nil,
                         attribute: .notAnAttribute,
                         constant: UIValues.headerHeight)
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
}

extension AccountsTableHeaderCell {

    enum UIValues {

        static let cellHorizontalMargin: CGFloat = 6
        static let headerHeight: CGFloat = 60
        static let verticalStakSeparation: CGFloat = 5

        static let assetTileSize: CGFloat = 12
        static let assetSubTitleSize: CGFloat = 12

        static let assetTitleColor = UIColor(hex: "#48484A")
        static let assetSubTitleColor = UIColor(hex: "#636366")
    }

    enum UIStrings {

        static let asseTitle = "cybrid.accounts.assetTitle"
        static let marketPriceTitle = "cybrid.accounts.marketPriceTitle"
        static let balanceTitle = "cybrid.accounts.balanceTitle"
    }
}

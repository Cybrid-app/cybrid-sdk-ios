//
//  AccountTransfersHeaderCell.swift
//  CybridSDK
//
//  Created by Erick Sanchez Perez on 03/04/23.
//

import Foundation
import UIKit

class AccountTransfersHeaderCell: UITableViewHeaderFooterView {

    private let localizer: Localizer

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

    func setupViews() {

        // -- Creating left view
        let asseTitle = createTitleLabel()
        asseTitle.setLocalizedText(key: UIStrings.recentTranfersTitle, localizer: localizer)

        // -- Creating right side
        let amountTitle = createSubTitleLabel()
        amountTitle.setLocalizedText(key: UIStrings.amountTitle, localizer: localizer)

        // -- Join
        let stack = createHorizontalStack(one: asseTitle, two: amountTitle)
        addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = true
        self.setStackToMatchParent(stack: stack)
    }
}

extension AccountTransfersHeaderCell {

    private func createTitleLabel() -> UILabel {

        let label = UILabel()
        label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.baselineAdjustment = .alignCenters
        label.sizeToFit()
        label.font = UIValues.assetTileFont
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

    private func createHorizontalStack(one: UIView, two: UIView) -> UIStackView {

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
}

extension AccountTransfersHeaderCell {

    enum UIValues {

        static let cellHorizontalMargin: CGFloat = 6
        static let headerHeight: CGFloat = 60
        static let verticalStakSeparation: CGFloat = 5

        static let assetTileFont = UIFont.make(ofSize: 12, weight: .medium)
        static let assetSubTitleSize: CGFloat = 12

        static let assetTitleColor = UIColor.black
        static let assetSubTitleColor = UIColor(hex: "#636366")
    }

    enum UIStrings {

        static let recentTranfersTitle = "cybrid.accounts.transfers.recentTransfersTitle"
        static let amountTitle = "cybrid.accounts.transfers.amount"
    }
}

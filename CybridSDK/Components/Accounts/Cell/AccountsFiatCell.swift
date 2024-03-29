//
//  AccountsFiatCell.swift
//  CybridSDK
//
//  Created by Erick Sanchez Perez on 06/03/23.
//

import Foundation
import UIKit

class AccountsFiatCell: UITableViewCell {

    static let reuseIdentifier = "accountsFiatCell"
    override var reuseIdentifier: String? { Self.reuseIdentifier }
    private let theme: Theme
    private var icon = URLImageView(url: nil)
    private var assetName = UILabel()
    private var accountBalance = UILabel()
    private var accountBalancePending = UILabel()

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

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    private func setupViews() {

        self.accessibilityIdentifier = "AccountsComponent_Content_Table_Item_Fiat"
        backgroundColor = theme.colorTheme.primaryBackgroundColor
        self.setupIcon()
        self.setupLabels()

        // -- Vertical Stacks
        let leftSide = createVerticalStackView(
            top: assetName,
            bottom: UILabel())
        let rightSide = createVerticalStackView(
            top: accountBalance,
            bottom: accountBalancePending,
            withConstraints: true)

        // -- Horizontal Stack
        self.createStackView(left: icon,
                             center: leftSide,
                             right: rightSide)
    }

    func setData(balance: BalanceUIModel) {

        // -- Setup icon
        icon.setURL(balance.accountAssetURL)

        // -- Setup labels
        self.setLabelsData(balance: balance)
    }
}

extension AccountsFiatCell {

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

        // -- Asset name
        self.setupBasicLabel(assetName,
                             side: .left,
                             font: UIFont.make(ofSize: UIValues.assetNameSize),
                             color: UIValues.assetNameColor)
        self.assetName.accessibilityIdentifier = "AccountsComponent_Content_Table_Item_Name"

        // -- Account balance fiat
        self.setupBasicLabel(accountBalance,
                             side: .right,
                             font: UIFont.make(ofSize: UIValues.accountBalanceSize, weight: .medium),
                             color: UIValues.accountBalanceColor)
        self.accountBalance.accessibilityIdentifier = "AccountsComponent_Content_Table_Item_Balance"

        // -- Account pending balance fiat
        self.setupBasicLabel(accountBalancePending,
                             side: .right,
                             font: UIFont.make(ofSize: UIValues.accountBalanceFiatSize),
                             color: UIValues.accountsITemFiatPendingColor)
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

    private func setupBasicLabel(_ label: UILabel, side: UILabel.AttributedSide, font: UIFont, color: UIColor?) {

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

    private func setLabelsData(balance: BalanceUIModel) {

        // -- Asset name
        assetName.setAttributedText(
            mainText: balance.asset?.name ?? "",
            mainTextFont: UIFont.systemFont(ofSize: UIValues.assetNameSize),
            mainTextColor: UIValues.assetNameColor,
            attributedText: balance.asset?.code ?? "",
            attributedTextFont: UIFont.systemFont(ofSize: UIValues.assetNameCodeSize),
            attributedTextColor: UIValues.assetNameCodeColor,
            side: .left)

        // -- Account balance fiat
        accountBalance.text = balance.accountBalanceInFiatFormatted

        // -- Account pending balance fiat
        let pendignString = CybridLocalizer().localize(with: UIStrings.accountsItemFiatPending)
        let pendingValue = "\(balance.accountPendingBalanceFormatted)\(pendignString)"
        accountBalancePending.text = pendingValue
    }
}

extension AccountsFiatCell {

    enum UIValues {

        // -- Sizes
        static let verticalStakSeparation: CGFloat = 3
        static let margin: CGFloat = 10
        static let iconWidht: CGFloat = 24
        static let iconHeight: CGFloat = 24
        static let assetNameSize: CGFloat = 14
        static let assetNameCodeSize: CGFloat = 13
        static let accountBalanceSize: CGFloat = 14
        static let assetPriceSize: CGFloat = 13
        static let accountBalanceFiatSize: CGFloat = 14

        // -- Colors
        static let assetNameColor = UIColor.black
        static let assetNameCodeColor = UIColor(hex: "#757575")
        static let accountBalanceColor = UIColor.black
        static let assetPriceColor = UIColor(hex: "#636366")
        static let accountBalanceFiatColor = UIColor(hex: "#636366")
        static let accountsITemFiatPendingColor = UIColor(hex: "#007AFF")
    }

    enum UIStrings {

        static let accountsItemFiatPending = "cybrid.accounts.item.fiat.pending"
    }
}

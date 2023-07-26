//
//  AccountTransfersCell.swift
//  CybridSDK
//
//  Created by Erick Sanchez Perez on 03/04/23.
//

import Foundation
import UIKit
import CybridApiBankSwift

class AccountTransfersCell: UITableViewCell {

    static let reuseIdentifier = "accountTransfersCell"
    override var reuseIdentifier: String? { Self.reuseIdentifier }
    private let theme: Theme
    private var icon = UIImageView()
    private var transferType = UILabel()
    private var amount = UILabel()
    private var transferDate = UILabel()
    private var statusChip = UILabel()
    private var typeDateStack = UIStackView()

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

        // -- Setup icon
        self.setupIcon()

        // -- Setup type and date
        self.setupTypeAndDateStack()

        // -- Transfer chip status
        self.setupStatusChip()

        // -- Amount label
        self.setupAmountLabel()
    }
}

extension AccountTransfersCell {

    private func setupIcon() {

        self.addSubview(self.icon)
        self.icon.translatesAutoresizingMaskIntoConstraints = false
        self.icon.constraint(attribute: .height,
                             relatedBy: .equal,
                             toItem: nil,
                             attribute: .notAnAttribute,
                             constant: UIValues.iconWidht)
        self.icon.constraint(attribute: .width,
                             relatedBy: .equal,
                             toItem: nil,
                             attribute: .notAnAttribute,
                             constant: UIValues.iconHeight)
        self.icon.constraint(attribute: .leading,
                             relatedBy: .equal,
                             toItem: self,
                             attribute: .leading,
                             constant: UIValues.iconMargin.left)
        self.icon.constraint(attribute: .centerY,
                              relatedBy: .equal,
                              toItem: self,
                              attribute: .centerY)
    }

    private func setupTypeAndDateStack() {

        self.setupBasicLabel(transferType,
                             side: .left,
                             font: UIFont.make(ofSize: UIValues.tradeTypeSize),
                             color: UIValues.tradeTypeColor)
        self.setupBasicLabel(transferDate,
                             side: .left,
                             font: UIFont.make(ofSize: UIValues.tradeDateSize),
                             color: UIValues.tradeDateColor)
        self.typeDateStack = createVerticalStackView(top: transferType, bottom: transferDate)

        self.addSubview(self.typeDateStack)
        self.typeDateStack.translatesAutoresizingMaskIntoConstraints = false
        self.typeDateStack.constraint(attribute: .leading,
                                      relatedBy: .equal,
                                      toItem: self.icon,
                                      attribute: .trailing,
                                      constant: UIValues.typeDateMargin.left)
        self.typeDateStack.constraint(attribute: .width,
                                      relatedBy: .equal,
                                      toItem: nil,
                                      attribute: .notAnAttribute,
                                      constant: UIValues.typeDateSize.width)
        self.typeDateStack.constraint(attribute: .height,
                                      relatedBy: .equal,
                                      toItem: nil,
                                      attribute: .notAnAttribute,
                                      constant: UIValues.typeDateSize.height)
        self.typeDateStack.constraint(attribute: .centerY,
                                      relatedBy: .equal,
                                      toItem: self,
                                      attribute: .centerY)
    }

    private func setupStatusChip() {

        self.statusChip.layer.masksToBounds = true
        self.statusChip.layer.cornerRadius = CGFloat(10)
        self.statusChip.setContentHuggingPriority(.required, for: .horizontal)
        self.statusChip.translatesAutoresizingMaskIntoConstraints = false
        self.statusChip.font = UIValues.statusChipFont
        self.statusChip.textAlignment = .center

        self.addSubview(self.statusChip)
        self.statusChip.translatesAutoresizingMaskIntoConstraints = false
        self.statusChip.constraint(attribute: .leading,
                                   relatedBy: .equal,
                                   toItem: self.typeDateStack,
                                   attribute: .trailing,
                                   constant: UIValues.chipMargin.left)
        self.statusChip.constraint(attribute: .width,
                                   relatedBy: .equal,
                                   toItem: nil,
                                   attribute: .notAnAttribute,
                                   constant: UIValues.chipSize.width)
        self.statusChip.constraint(attribute: .height,
                                   relatedBy: .equal,
                                   toItem: nil,
                                   attribute: .notAnAttribute,
                                   constant: UIValues.chipSize.height)
        self.statusChip.constraint(attribute: .centerY,
                                   relatedBy: .equal,
                                   toItem: self,
                                   attribute: .centerY)
    }

    private func setupAmountLabel() {

        self.setupBasicLabel(amount,
                             side: .right,
                             font: UIFont.make(ofSize: UIValues.tradeAmountSize),
                             color: UIValues.tradeAmountColor)

        self.addSubview(self.amount)
        self.amount.translatesAutoresizingMaskIntoConstraints = false
        self.amount.constraint(attribute: .trailing,
                               relatedBy: .equal,
                               toItem: self,
                               attribute: .trailing,
                               constant: -UIValues.amountMargin.right)
        self.amount.constraint(attribute: .width,
                               relatedBy: .equal,
                               toItem: nil,
                               attribute: .notAnAttribute,
                               constant: UIValues.amountSize.width)
        self.amount.constraint(attribute: .height,
                               relatedBy: .equal,
                               toItem: nil,
                               attribute: .notAnAttribute,
                               constant: UIValues.amountSize.height)
        self.amount.constraint(attribute: .centerY,
                               relatedBy: .equal,
                               toItem: self,
                               attribute: .centerY)
    }

    private func createVerticalStackView(top: UIView, bottom: UIView) -> UIStackView {

        let stack = UIStackView(arrangedSubviews: [top, bottom])
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

    func setData(transfer: TransferBankModel) {

        // -- Setup icon
        self.icon.image = UIImage(
            named: transfer.side == .withdrawal ? "sellIcon" : "buyIcon",
            in: Bundle(for: Self.self),
            with: nil)

        // -- Transfer Type
        let transferTypeKey = (transfer.side == .withdrawal) ? UIString.transferWithdraw : UIString.transferDeposit
        self.transferType.setLocalizedText(key: transferTypeKey, localizer: CybridLocalizer())

        // -- Transfer Date
        self.transferDate.text = getFormattedDate(transfer.createdAt, format: "MMM dd, YYYY")

        // -- Transfer Amount
        let amountValue = AccountTransfersViewModel.getAmountOfTransferInFormat(transfer)
        self.amount.text = amountValue

        // -- Status chip
        let localizer = CybridLocalizer()
        switch transfer.state {
        case .initiating, .storing, .pending:

            self.statusChip.isHidden = false
            self.statusChip.textColor = UIColor.black
            self.statusChip.backgroundColor = UIValues.transferPending
            self.statusChip.setLocalizedText(key: UIString.transferPending, localizer: localizer)

        case .failed:

            self.statusChip.isHidden = false
            self.statusChip.textColor = UIColor.white
            self.statusChip.backgroundColor = UIValues.transferFailed
            self.statusChip.setLocalizedText(key: UIString.transferFailed, localizer: localizer)

        default:
            self.statusChip.isHidden = true
        }
        self.statusChip.layoutSubviews()
    }
}

extension AccountTransfersCell {

    enum UIString {

        static let tradeTYpeSell = "cybrid.account.trades.sellType"
        static let tradeTypeBuy = "cybrid.account.trades.buyType"
        static let transferWithdraw = "cybrid.accounts.transfers.withdraw"
        static let transferDeposit = "cybrid.accounts.transfers.deposit"
        static let transferPending = "cybrid.accounts.transfers.pending"
        static let transferFailed = "cybrid.accounts.transfers.failed"
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
        static let typeDateSize = CGSize(width: 90, height: 30)
        static let amountSize = CGSize(width: 130, height: 40)
        static let chipSize = CGSize(width: 65, height: 22)

        // -- Margins
        static let iconMargin = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        static let typeDateMargin = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 0)
        static let amountMargin = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)
        static let chipMargin = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)

        // -- Colors
        static let tradeTypeColor = UIColor.black
        static let tradeAmountColor = UIColor.black
        static let tradeAmountCodeColor = UIColor(hex: "#757575")
        static let tradeDateColor = UIColor(hex: "#636366")
        static let tradeAmountInFiatColor = UIColor(hex: "#636366")
        static let transferFailed = UIColor(hex: "#D45736")
        static let transferPending = UIColor(hex: "#FCDA66")

        // -- Font
        static let statusChipFont = UIFont.make(ofSize: 12)
    }
}

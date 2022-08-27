//
//  AccountTradeDetailModal.swift
//  CybridSDK
//
//  Created by Erick Sanchez Perez on 26/08/22.
//

import Foundation
import UIKit

class AccountTradeDetailModal: UIModal {

    private var trade: TradeUIModel
    private let localizer: Localizer
    private var onConfirm: (() -> Void)?

    private var titleView = UILabel.makeBasic(
        font: UIValues.titleFont, color: UIValues.titleColor, aligment: .left)
    private var subTitleView = UILabel.makeBasic(
        font: UIValues.subTitleFont, color: UIValues.subTitleColor, aligment: .left)
    
    private lazy var divider: UIView = {
        let underline = UIView()
        underline.backgroundColor = UIValues.dividerColor
        underline.translatesAutoresizingMaskIntoConstraints = false
        return underline
      }()

    init(trade: TradeUIModel, theme: Theme, localizer: Localizer, onConfirm: (() -> Void)?) {

        self.trade = trade
        self.localizer = localizer
        self.onConfirm = onConfirm
        super.init(theme: theme, height: UIValues.modalSize)

        setupViews()
    }

    @available(iOS, deprecated: 10, message: "You should never use this init method.")
    required init?(coder: NSCoder) {

        assertionFailure("init(coder:) should never be used")
        return nil
    }

    private func setupViews() {

        // -- Title View
        let titleType = trade.tradeBankModel.side == .sell ? UIString.sold : UIString.bought
        let localizedTitle = localizer.localize(with: titleType)
        titleView.asFirstIn(self.containerView, height: UIValues.titleSize, margins: UIValues.titleSizeMargin)
        titleView.text = "\(trade.asset.code) \(localizedTitle)"

        // -- Sub Title View
        subTitleView.addBelow(
            toItem: self.titleView, height: UIValues.subTitleSize, margins: UIValues.subTitleMargin)
        subTitleView.setAttributedText(
            mainText: trade.getTradeFiatAmount(),
            mainTextFont: UIValues.subTitleFont,
            mainTextColor: UIValues.subTitleColor,
            attributedText: "\(trade.counterAsset.code) in \(trade.asset.code)",
            attributedTextFont: UIValues.subTitleCodeFont,
            attributedTextColor: UIValues.subTitleCodeColor,
            side: .left)

        // -- Status
        let statusTitle = addItemTitle(belowOf: subTitleView, titleKey: UIString.status, firstElement: true)
        let statusValue = addItemValue(belowOf: statusTitle, mainValue: trade.tradeBankModel.state?.rawValue ?? "")

        // -- Order Placed
        let orderPlaceTitle = addItemTitle(belowOf: statusValue, titleKey: UIString.orderPlaced)
        let orderPlaceValue = addItemValue(
            belowOf: orderPlaceTitle,
            mainValue: trade.getTradeFiatAmount(),
            secondaryValue: trade.counterAsset.code)

        // -- Order Finalized
        let orderFinalized = addItemTitle(belowOf: orderPlaceValue, titleKey: UIString.orderFinalized)
        let orderFinalizedValue = addItemValue(
            belowOf: orderFinalized,
            mainValue: trade.getTradeAmount(),
            secondaryValue: trade.asset.code)

        // -- Transaction Date & Time
        let date = getFormattedDate(trade.tradeBankModel.createdAt, format: "MMMM dd, YYYY HH:mm a")
        let transactionDate = addItemTitle(belowOf: orderFinalizedValue, titleKey: UIString.transactionDate)
        let transactionDateValue = addItemValue(
            belowOf: transactionDate,
            mainValue: date)

        // -- Account ID
        let accountID = addItemTitle(belowOf: transactionDateValue, titleKey: UIString.accountID)
        let accountIDValue = addItemValue(belowOf: accountID, mainValue: trade.accoountGuid)

        // -- Order ID
        let orderID = addItemTitle(belowOf: accountIDValue, titleKey: UIString.orderID)
        let orderIDValue = addItemValue(belowOf: orderID, mainValue: trade.tradeBankModel.guid ?? "")

        // -- Divider
        divider.addBelow(toItem: orderIDValue, height: UIValues.dividerSize, margins: UIValues.dividerMargin)

        // -- Close Button
        let closeButtonText = localizer.localize(with: UIString.close)
        let closeButton = UIButton()
        closeButton.backgroundColor = .clear
        closeButton.setTitle(closeButtonText, for: .normal)
        closeButton.setTitleColor(UIValues.closeButtonColor, for: .normal)
        closeButton.addTarget(self, action: #selector(close), for: .touchUpInside)
        closeButton.addBelowToBottom(topItem: orderIDValue, bottomItem: self.view, margins: UIValues.closeButtonMargin)

    }
}

extension AccountTradeDetailModal {

    private func addItemTitle(belowOf: UIView, titleKey: String, firstElement: Bool = false) -> UILabel {

        let itemTitle = UILabel.makeBasic(
            font: UIValues.itemTitleFont,
            color: UIValues.itemTitleColor,
            aligment: .left)
        let margins = firstElement ? UIValues.itemTitleFirstMargin : UIValues.itemTitleMargin
        itemTitle.addBelow(
            toItem: belowOf, height: UIValues.itemTitleSize, margins: margins)
        itemTitle.setLocalizedText(key: titleKey, localizer: localizer)
        return itemTitle
    }

    private func addItemValue(belowOf: UIView, mainValue: String, secondaryValue: String = "") -> UILabel {

        let itemValue = UILabel.makeBasic(
            font: UIValues.itemValueFont,
            color: UIValues.itemValueColor,
            aligment: .left)
        itemValue.addBelow(
            toItem: belowOf, height: UIValues.itemValueSize, margins: UIValues.itemValueMarigin)
        if secondaryValue.isEmpty {
            itemValue.text = mainValue
        } else {
            itemValue.setAttributedText(
                mainText: mainValue,
                mainTextFont: UIValues.itemValueFont,
                mainTextColor: UIValues.itemValueColor,
                attributedText: secondaryValue,
                attributedTextFont: UIValues.itemValueFont,
                attributedTextColor: UIValues.itemValueCodeColor,
                side: .left)
        }
        return itemValue
    }

    @objc func close() {
        self.dismiss(animated: true)
    }
}

extension AccountTradeDetailModal {

    enum UIString {

        static let bought = "cybrid.account.trade.detail.bought"
        static let sold = "cybrid.account.trade.detail.sold"
        static let status = "cybrid.account.trade.detail.status"
        static let orderPlaced = "cybrid.account.trade.detail.orderPlaced"
        static let orderFinalized = "cybrid.account.trade.detail.orderFinalized"
        static let transactionDate = "cybrid.account.trade.detail.transactionDate"
        static let accountID = "cybrid.account.trade.detail.accountID"
        static let orderID = "cybrid.account.trade.detail.orderID"
        static let close = "cybrid.account.trade.detail.close"
    }

    enum UIValues {

        // -- Font
        static let titleFont = UIFont.make(ofSize: 22)
        static let subTitleFont = UIFont.make(ofSize: 13, weight: .bold)
        static let subTitleCodeFont = UIFont.make(ofSize: 13)
        static let itemTitleFont = UIFont.make(ofSize: 12)
        static let itemValueFont = UIFont.make(ofSize: 14)

        // -- Size
        static let modalSize: CGFloat = 550
        static let titleSize: CGFloat = 28
        static let subTitleSize: CGFloat = 18
        static let itemTitleSize: CGFloat = 26
        static let itemValueSize: CGFloat = 16
        static let dividerSize: CGFloat = 1

        // -- Margin
        static let titleSizeMargin = UIEdgeInsets(top: 28, left: 24, bottom: 0, right: 24)
        static let subTitleMargin = UIEdgeInsets(top: 8, left: 24, bottom: 0, right: 24)
        static let itemTitleFirstMargin = UIEdgeInsets(top: 25, left: 24, bottom: 0, right: 24)
        static let itemTitleMargin = UIEdgeInsets(top: 7.5, left: 24, bottom: 0, right: 24)
        static let itemValueMarigin = UIEdgeInsets(top: 5, left: 24, bottom: 0, right: 24)
        static let dividerMargin = UIEdgeInsets(top: 22, left: 24, bottom: 0, right: 24)
        static let closeButtonMargin = UIEdgeInsets(top: 28, left: 24, bottom: 26, right: 24)

        // -- Color
        static let titleColor = UIColor.black
        static let subTitleColor = UIColor(hex: "#48484A") ?? UIColor.black
        static let subTitleCodeColor = UIColor(hex: "#636366") ?? UIColor.black
        static let itemTitleColor = UIColor(hex: "#424242") ?? UIColor.black
        static let itemValueColor = UIColor.black
        static let itemValueCodeColor = UIColor(hex: "#757575") ?? UIColor.black
        static let dividerColor = UIColor(hex: "#C6C6C8") ?? UIColor.black
        static let closeButtonColor = UIColor(hex: "#007AFF") ?? UIColor.black
    }
}

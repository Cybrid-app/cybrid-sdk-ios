//
//  AccountTransferModal.swift
//  CybridSDK
//
//  Created by Erick Sanchez Perez on 17/05/23.
//

import CybridApiBankSwift
import UIKit

class AccountTransferModal: UIModal {

    private var transfer: TransferBankModel
    private var asset: AssetBankModel
    private var currentAssetURL: String
    private let localizer = CybridLocalizer()
    private var onConfirm: (() -> Void)?

    private lazy var divider: UIView = {
        let underline = UIView()
        underline.backgroundColor = UIValues.dividerColor
        underline.translatesAutoresizingMaskIntoConstraints = false
        return underline
    }()

    init(transfer: TransferBankModel, fiatAsset: AssetBankModel, assetURL: String, onConfirm: (() -> Void)?) {

        self.transfer = transfer
        self.asset = fiatAsset
        self.currentAssetURL = assetURL
        self.onConfirm = onConfirm
        super.init(height: UIValues.modalSize)
        setupViews()
    }

    @available(iOS, deprecated: 10, message: "You should never use this init method.")
    required init?(coder: NSCoder) {

        assertionFailure("init(coder:) should never be used")
        return nil
    }

    private func setupViews() {

        // -- Title View
        let titleType = transfer.side == "deposit" ? UIString.deposit : UIString.withdraw
        let localizedTitle = localizer.localize(with: titleType)
        let balanceAssetIcon = URLImageView(urlString: self.currentAssetURL) ?? UIImageView()

        // Title
        let titleView = UILabel.makeBasic(
            font: UIValues.titleFont, color: UIValues.titleColor, aligment: .left)
        titleView.asFirstWithImage(
            self.containerView,
            icon: balanceAssetIcon,
            height: UIValues.titleSize,
            margins: UIValues.titleSizeMargin)
        titleView.text = localizedTitle

        // -- Sub Title View
        let amountFormatted = AccountTransfersViewModel.getAmountOfTransfer(transfer)
        let subTitleView = UILabel.makeBasic(
            font: UIValues.subTitleFont, color: UIValues.subTitleColor, aligment: .left)
        subTitleView.addBelow(
            toItem: titleView, height: UIValues.subTitleSize, margins: UIValues.subTitleMargin)
        subTitleView.setAttributedText(
            mainText: "\(asset.symbol)\(amountFormatted)",
            mainTextFont: UIValues.subTitleFont,
            mainTextColor: UIValues.subTitleColor,
            attributedText: "\(asset.code)",
            attributedTextFont: UIValues.subTitleCodeFont,
            attributedTextColor: UIValues.subTitleCodeColor,
            side: .left)

        // -- Status
        let statusTitle = addItemTitle(belowOf: subTitleView, titleKey: UIString.statusTitle, firstElement: true)
        let statusValue = addItemValue(belowOf: statusTitle, mainValue: transfer.state?.capitalized ?? "")

        // -- Transfer Placed
        let transferTitle = addItemTitle(belowOf: statusValue, titleKey: UIString.transferTitle)
        let transferValue = addItemValue(
            belowOf: transferTitle,
            mainValue: "\(asset.symbol)\(amountFormatted)",
            secondaryValue: asset.code)

        // -- Fee
        let feeCDecimal = CDecimal(transfer.fee ?? 0)
        let feeFormatted = AssetFormatter.forBase(asset, amount: feeCDecimal)
        let feeTitle = addItemTitle(belowOf: transferValue, titleKey: UIString.feeTitle)
        let feeValue = addItemValue(
            belowOf: feeTitle,
            mainValue: "\(asset.symbol)\(feeFormatted)",
            secondaryValue: asset.code)

        // -- Transfer Date & Time
        let date = getFormattedDate(transfer.createdAt, format: "MMMM dd, YYYY HH:mm a")
        let transferDate = addItemTitle(belowOf: feeValue, titleKey: UIString.dateTimeTitle)
        let transferDateValue = addItemValue(
            belowOf: transferDate,
            mainValue: date)

        // -- Order ID
        let transferId = addItemTitle(belowOf: transferDateValue, titleKey: UIString.transferIdTitle)
        let transferIdValue = addItemValue(belowOf: transferId, mainValue: transfer.guid ?? "")

        // -- Divider
        divider.addBelow(toItem: transferIdValue, height: UIValues.dividerSize, margins: UIValues.dividerMargin)

        // -- Close Button
        let closeButtonText = localizer.localize(with: UIString.closeButton)
        let closeButton = UIButton()
        closeButton.backgroundColor = .clear
        closeButton.setTitle(closeButtonText, for: .normal)
        closeButton.setTitleColor(UIValues.closeButtonColor, for: .normal)
        closeButton.addTarget(self, action: #selector(close), for: .touchUpInside)
        closeButton.addBelowToBottom(topItem: transferIdValue, bottomItem: self.view, margins: UIValues.closeButtonMargin)

    }
}

extension AccountTransferModal {

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

extension AccountTransferModal {

    enum UIString {

        static let deposit = "cybrid.accounts.transfers.detail.deposit"
        static let withdraw = "cybrid.accounts.transfers.detail.withdraw"
        static let statusTitle = "cybrid.accounts.transfers.detail.status.title"
        static let transferTitle = "cybrid.accounts.transfers.detail.transferPlaced.title"
        static let feeTitle = "cybrid.accounts.transfers.detail.fee.title"
        static let dateTimeTitle = "cybrid.accounts.transfers.detail.date.title"
        static let transferIdTitle = "cybrid.accounts.transfers.detail.id.title"
        static let closeButton = "cybrid.accounts.transfers.detail.close.button"
    }

    enum UIValues {

        // -- Font
        static let titleFont = UIFont.make(ofSize: 22)
        static let subTitleFont = UIFont.make(ofSize: 13, weight: .bold)
        static let subTitleCodeFont = UIFont.make(ofSize: 13)
        static let itemTitleFont = UIFont.make(ofSize: 12)
        static let itemValueFont = UIFont.make(ofSize: 14)

        // -- Size
        static let modalSize: CGFloat = 500
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
        static let subTitleColor = UIColor(hex: "#48484A")
        static let subTitleCodeColor = UIColor(hex: "#636366")
        static let itemTitleColor = UIColor(hex: "#424242")
        static let itemValueColor = UIColor.black
        static let itemValueCodeColor = UIColor(hex: "#757575")
        static let dividerColor = UIColor(hex: "#C6C6C8")
        static let closeButtonColor = UIColor(hex: "#007AFF")
    }
}

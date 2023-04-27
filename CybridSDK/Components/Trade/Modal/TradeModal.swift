//
//  TradeModal.swift
//  CybridSDK
//
//  Created by Erick Sanchez Perez on 21/04/23.
//

import CybridApiBankSwift
import Foundation
import UIKit

class TradeModal: UIModal {

    internal var localizer: Localizer!

    internal var tradeViewModel: TradeViewModel

    internal var componentContent = UIView()

    init(tradeViewModel: TradeViewModel) {

        self.tradeViewModel = tradeViewModel

        super.init(height: UIValues.modalSize)

        self.localizer = CybridLocalizer()
        self.setupViews()
    }

    @available(iOS, deprecated: 10, message: "You should never use this init method.")
    required init?(coder: NSCoder) {

        assertionFailure("init(coder:) should never be used")
        return nil
    }

    private func setupViews() {

        self.initComponentContent()
        self.manageCurrentStateUI()
    }
}

extension TradeModal {

    private func initComponentContent() {

        // -- Component Container
        self.containerView.addSubview(self.componentContent)
        self.componentContent.constraint(attribute: .top,
                                         relatedBy: .equal,
                                         toItem: self.containerView,
                                         attribute: .topMargin,
                                         constant: 10)
        self.componentContent.constraint(attribute: .leading,
                                         relatedBy: .equal,
                                         toItem: self.containerView,
                                         attribute: .leading,
                                         constant: 10)
        self.componentContent.constraint(attribute: .trailing,
                                         relatedBy: .equal,
                                         toItem: self.containerView,
                                         attribute: .trailing,
                                         constant: -10)
        self.componentContent.constraint(attribute: .bottom,
                                         relatedBy: .equal,
                                         toItem: self.containerView,
                                         attribute: .bottomMargin,
                                         constant: 10)
    }

    private func manageCurrentStateUI() {

        // -- Await for UI State changes
        self.tradeViewModel.modalState.bind { state in

            self.removeSubViewsFromContent()
            switch state {

            case .LOADING:
                self.tradeModal_Loading()

            case .CONTENT:
                self.tradeModal_Content()

            case .CONFIRM:
                self.tradeModal_Loading()
            }
        }
    }

    internal func removeSubViewsFromContent() {

        for view in self.componentContent.subviews {
            view.removeFromSuperview()
        }
    }

    private func createTitle(key: String) -> UILabel {

        let title = UILabel()
        title.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.sizeToFit()
        title.font = UIValues.titleFont
        title.textColor = UIValues.titleColor
        title.textAlignment = .left
        title.setLocalizedText(key: key, localizer: localizer)
        return title
    }

    private func createSubTitle(key: String) -> UILabel {

        let title = UILabel()
        title.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.sizeToFit()
        title.font = UIValues.subTitleFont
        title.textColor = UIValues.contentSubTitleColor
        title.textAlignment = .left
        title.setLocalizedText(key: key, localizer: localizer)
        return title
    }

    private func createItemTitle(key: String) -> UILabel {

        let title = UILabel()
        title.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.sizeToFit()
        title.font = UIValues.itemTitleFont
        title.textColor = UIValues.itemTitleColor
        title.textAlignment = .left
        title.setLocalizedText(key: key, localizer: localizer)
        return title
    }

    private func createItemValue(value: String) -> UILabel {

        let title = UILabel()
        title.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.sizeToFit()
        title.font = UIValues.itemValueFont
        title.textColor = UIValues.itemValueColor
        title.textAlignment = .left
        title.text = value
        return title
    }

    private func createActionButtons() -> UIStackView {

        let theme = Cybrid.theme
        let cancelText = localizer.localize(with: UIStrings.contentCancelString)
        let confirmText = localizer.localize(with: UIStrings.contentConfirmString)

        // -- Cancel button
        let cancelButton = CYBButton(title: cancelText,
                                     style: .secondary,
                                     theme: theme
        ) { [weak self] in

            self?.tradeViewModel.dismissModal()
            self?.dismiss(animated: true)
        }

        // -- Confirm button
        let confirmButton = CYBButton(title: confirmText,
                                  theme: theme,
                                  action: { [weak self] in

            self?.tradeViewModel.createTrade()
        })

        // -- Stack
        let stackView = UIStackView(arrangedSubviews: [cancelButton, confirmButton])
        stackView.axis = .horizontal
        stackView.alignment = .trailing
        stackView.distribution = .fillEqually
        return stackView
    }
}

extension TradeModal {

    internal func tradeModal_Loading() {

        let title = UILabel()
        title.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.sizeToFit()
        title.font = UIValues.loadingTitleFont
        title.textColor = UIValues.loadingTitleColor
        title.textAlignment = .center
        title.setLocalizedText(key: UIStrings.loadingTitleString, localizer: localizer)

        self.componentContent.addSubview(title)
        title.constraint(attribute: .centerY,
                         relatedBy: .equal,
                         toItem: self.componentContent,
                         attribute: .centerY)
        title.constraint(attribute: .leading,
                         relatedBy: .equal,
                         toItem: self.componentContent,
                         attribute: .leading,
                         constant: UIValues.loadingTitleMargin.left)
        title.constraint(attribute: .trailing,
                         relatedBy: .equal,
                         toItem: self.componentContent,
                         attribute: .trailing,
                         constant: -UIValues.loadingTitleMargin.right)
        title.constraint(attribute: .height,
                         relatedBy: .equal,
                         toItem: nil,
                         attribute: .notAnAttribute,
                         constant: UIValues.loadingTitleHeight)

        // -- Spinner
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.addBelow(toItem: title, height: UIValues.loadingSpinnerHeight, margins: UIValues.loadingSpinnerMargin)
        spinner.color = UIColor.black
        spinner.startAnimating()
    }

    internal func tradeModal_Content() {

        // -- Title
        let title = self.createTitle(key: UIStrings.contentTitleString)
        title.asFirstIn(self.componentContent, height: UIValues.contentTitleHeight, margins: UIValues.contentTitleMargins)

        // -- Subtitle
        let sub = self.createSubTitle(key: UIStrings.contentSubTitleString)
        sub.addBelow(toItem: title, height: UIValues.contentSubTitleHeight, margins: UIValues.contentSubTitleMargins)

        // -- Amount
        let amountKey = self.tradeViewModel.segmentSelection.value == .buy ? UIStrings.contentAmountBuyString : UIStrings.contentAmountSellString
        let amountTitle = self.createItemTitle(key: amountKey)
        amountTitle.addBelow(toItem: sub, height: UIValues.contentAmountTitleHeight, margins: UIValues.contentAmountTitleMargins)

        let amountValueString = self.tradeViewModel.segmentSelection.value == .buy ? tradeViewModel.currentQuote.value?.deliverAmount : tradeViewModel.currentQuote.value?.receiveAmount
        let amountBase = AssetFormatter.forBase(Cybrid.fiat, amount: CDecimal(amountValueString!))
        let amountBaseFormatted = AssetFormatter.format(Cybrid.fiat, amount: amountBase)
        let amountValue = self.createItemValue(value: amountBaseFormatted)
        amountValue.addBelow(toItem: amountTitle, height: UIValues.contentAmountValueHeight, margins: UIValues.contentAmountValueMargins)

        // -- Quantity
        let quantityKey = self.tradeViewModel.segmentSelection.value == .buy ? UIStrings.contentQuantityBuyString : UIStrings.contentQuantitySellString
        let quantityTitle = self.createItemTitle(key: quantityKey)
        quantityTitle.addBelow(toItem: amountValue, height: UIValues.contentAmountTitleHeight, margins: UIValues.contentAmountTitleMargins)

        let quantityValueString = self.tradeViewModel.segmentSelection.value == .buy ? tradeViewModel.currentQuote.value?.receiveAmount : tradeViewModel.currentQuote.value?.deliverAmount
        let quantityBase = AssetFormatter.forBase(tradeViewModel.currentAsset.value!, amount: CDecimal(quantityValueString!)).removeTrailingZeros()
        let quantityBaseFormatted = AssetFormatter.format(tradeViewModel.currentAsset.value!, amount: quantityBase)
        let quantityValue = self.createItemValue(value: quantityBaseFormatted)
        quantityValue.addBelow(toItem: quantityTitle, height: UIValues.contentAmountValueHeight, margins: UIValues.contentAmountValueMargins)

        // -- Fee
        let feeTitle = self.createItemTitle(key: UIStrings.contentFeeTitleString)
        feeTitle.addBelow(toItem: quantityValue, height: UIValues.contentAmountTitleHeight, margins: UIValues.contentAmountTitleMargins)

        let feeValueString = tradeViewModel.currentQuote.value?.fee ?? "0"
        let feeBase = AssetFormatter.forBase(Cybrid.fiat, amount: CDecimal(feeValueString))
        let feeBaseFormatted = AssetFormatter.format(Cybrid.fiat, amount: feeBase)
        let feeValue = self.createItemValue(value: feeBaseFormatted)
        feeValue.addBelow(toItem: feeTitle, height: UIValues.contentAmountValueHeight, margins: UIValues.contentAmountValueMargins)

        // -- Buttons
        let buttons = self.createActionButtons()
        buttons.addBelow(toItem: feeValue, height: 48, margins: UIValues.contentButtonsMargins)
    }
}

extension TradeModal {

    enum UIValues {

        // -- Sizes
        static let modalSize: CGFloat = 380
        static let loadingTitleHeight: CGFloat = 20
        static let loadingSpinnerHeight: CGFloat = 30
        static let contentTitleHeight: CGFloat = 28
        static let contentSubTitleHeight: CGFloat = 26
        static let contentAmountTitleHeight: CGFloat = 26
        static let contentAmountValueHeight: CGFloat = 20

        // -- Fonts
        static let loadingTitleFont = UIFont.make(ofSize: 17, weight: .bold)
        static let titleFont = UIFont.make(ofSize: 22)
        static let subTitleFont = UIFont.make(ofSize: 14)
        static let itemTitleFont = UIFont.make(ofSize: 13, weight: .bold)
        static let itemValueFont = UIFont.make(ofSize: 14)

        // -- Colors
        static let loadingTitleColor = UIColor.black
        static let titleColor = UIColor.black
        static let contentSubTitleColor = UIColor(hex: "#424242")
        static let itemTitleColor = UIColor(hex: "#424242")
        static let itemValueColor = UIColor.black

        // -- Margins
        static let loadingTitleMargin = UIEdgeInsets(top: 40, left: 10, bottom: 0, right: 10)
        static let loadingSpinnerMargin = UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
        static let contentTitleMargins = UIEdgeInsets(top: 10, left: 24, bottom: 0, right: 24)
        static let contentSubTitleMargins = UIEdgeInsets(top: 5, left: 24, bottom: 0, right: 24)
        static let contentAmountTitleMargins = UIEdgeInsets(top: 15, left: 24, bottom: 0, right: 24)
        static let contentAmountValueMargins = UIEdgeInsets(top: 1, left: 24, bottom: 0, right: 24)
        static let contentButtonsMargins = UIEdgeInsets(top: 15, left: 24, bottom: 0, right: 24)
    }

    enum UIStrings {

        static let loadingTitleString = "cybrid.account.trade.modal.loading.title"
        static let contentTitleString = "cybrid.account.trade.modal.content.title"
        static let contentSubTitleString = "cybrid.account.trade.modal.content.sub.title"
        static let contentAmountBuyString = "cybrid.account.trade.modal.content.amount.buy"
        static let contentAmountSellString = "cybrid.account.trade.modal.content.amount.sell"
        static let contentQuantityBuyString = "cybrid.account.trade.modal.content.quantity.buy"
        static let contentQuantitySellString = "cybrid.account.trade.modal.content.quantity.sell"
        static let contentFeeTitleString = "cybrid.account.trade.modal.content.fee.title"
        static let contentCancelString = "cybrid.account.trade.modal.content.cancel.button"
        static let contentConfirmString = "cybrid.account.trade.modal.content.confirm.button"
    }
}

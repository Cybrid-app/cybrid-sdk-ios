//
//  TransferModal.swift
//  CybridSDK
//
//  Created by Erick Sanchez Perez on 20/03/23.
//

import UIKit

class TransferModal: UIModal {

    internal var localizer: Localizer!
    internal var transferViewModel: TransferViewModel!

    internal var componentContent = UIView()

    init(transferViewModel: TransferViewModel) {

        self.transferViewModel = transferViewModel
        super.init(height: UIValues.modalHeightSize)

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

extension TransferModal {

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
        self.transferViewModel.modalUIState.bind { state in

            self.removeSubViewsFromContent()
            switch state {

            case .LOADING:
                self.transferViewModal_Loading()

            case .CONFIRM:
                self.transferViewModal_Confirm()

            case .DETAILS:
                self.transferViewModal_Details()

            case .ERROR:
                self.transferViewModal_Error()
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

    private func createAccountTitle(key: String) -> UILabel {

        let title = UILabel()
        title.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.sizeToFit()
        title.font = UIValues.accountTitleFont
        title.textColor = UIValues.accountTitleColor
        title.textAlignment = .left
        title.setLocalizedText(key: key, localizer: localizer)
        return title
    }

    private func createAccountValue(value: String) -> UILabel {

        let title = UILabel()
        title.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.sizeToFit()
        title.font = UIValues.accountValueFont
        title.textColor = UIValues.accountValueColor
        title.textAlignment = .left
        title.text = value
        return title
    }
}

extension TransferModal {

    internal func transferViewModal_Loading() {

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

    internal func transferViewModal_Confirm() {

        // -- Title
        let titleKey = transferViewModel.isWithdraw.value ? UIStrings.contentWithdrawTitleString : UIStrings.contentDepositTitleString
        let title = self.createTitle(key: titleKey)
        title.asFirstIn(self.componentContent, height: UIValues.contentTitleHeight, margins: UIValues.contentTitleMargins)

        // -- Amount name/value
        let amountTitle = self.createAccountTitle(key: UIStrings.contentAmountString)
        amountTitle.addBelow(toItem: title, height: UIValues.contentAmountHeight, margins: UIValues.contentAmountMargins)

        let amountValueString = self.transferViewModel.currentQuote.value?.receiveAmount
        let amountBase = AssetFormatter.forBase(Cybrid.fiat, amount: CDecimal(amountValueString!))
        let amountBaseFormatted = AssetFormatter.format(Cybrid.fiat, amount: amountBase)
        let amountValue = self.createAccountValue(value: amountBaseFormatted)
        amountValue.addBelow(toItem: amountTitle, height: UIValues.contentAmountValueHeight, margins: UIValues.contentAmountValueMargins)

        // -- Deposit/Withdraw date value
        let dateKey = transferViewModel.isWithdraw.value ? UIStrings.contentWithdrawDateString : UIStrings.contentDepositDateString
        let dateTitle = self.createAccountTitle(key: dateKey)
        dateTitle.addBelow(toItem: amountValue, height: UIValues.contentDepositDateHeight, margins: UIValues.contentDepositDateMargins)

        let dateValueString = getFormattedDate(Date(), format: "MMMM dd, YYYY")
        let dateValue = self.createAccountValue(value: dateValueString)
        dateValue.addBelow(toItem: dateTitle, height: UIValues.contentDateValueHeight, margins: UIValues.contentDateValueMargins)

        // -- From/To
        let fromToKey = transferViewModel.isWithdraw.value ? UIStrings.contentToString : UIStrings.contentFromString
        let fromToTitle = self.createAccountTitle(key: fromToKey)
        fromToTitle.addBelow(toItem: dateValue, height: UIValues.contentFromToHeight, margins: UIValues.contentFromToMargins)

        let accoutnName = self.transferViewModel.getAccountNameInFormat(self.transferViewModel.currentExternalBankAccount.value)
        let fromToValue = self.createAccountValue(value: accoutnName)
        fromToValue.addBelow(toItem: fromToTitle, height: UIValues.contentFromToValueHeight, margins: UIValues.contentFromToValueMargins)

        // -- Continue Button
        let confirmButtonKey = transferViewModel.isWithdraw.value ? UIStrings.contentButtonWithdrawString : UIStrings.contentButtonDepositString
        let confirmButtonText = localizer.localize(with: confirmButtonKey)
        let confirmButton = CYBButton(title: confirmButtonText,
                                      theme: Cybrid.theme,
                                      action: {
            self.transferViewModel.createTransfer()
        })
        confirmButton.addBelow(toItem: fromToValue, height: 48, margins: UIValues.contentButtonMargins)
    }

    internal func transferViewModal_Details() {

        self.modifyHeight(height: UIValues.modalSuccessHeightSize)

        // -- Icon
        let image = UIImage(named: "kyc_verified", in: Bundle(for: Self.self), with: nil)
        let icon = UIImageView(image: image)
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.asFirstInCenter(self.componentContent, size: UIValues.successIconSize, margins: UIValues.successIconMargins)

        // -- Value
        let amountValueString = self.transferViewModel.currentTransfer.value?.amount
        let amountBase = AssetFormatter.forBase(Cybrid.fiat, amount: CDecimal(amountValueString!))
        let amountBaseFormatted = AssetFormatter.format(Cybrid.fiat, amount: amountBase)
        let amountValue = UILabel()
        amountValue.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        amountValue.translatesAutoresizingMaskIntoConstraints = false
        amountValue.font = UIValues.successBigTitleFont
        amountValue.textColor = UIValues.successTitleColor
        amountValue.textAlignment = .center
        amountValue.text = amountBaseFormatted
        amountValue.addBelow(toItem: icon, height: UIValues.successValueTitleHeight, margins: UIValues.successValueTitleMargins)

        // -- Title
        let title = UILabel()
        title.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = UIValues.successTitleFont
        title.textColor = UIValues.successTitleColor
        title.textAlignment = .center
        title.text = localizer.localize(with: UIStrings.successTitle)
        title.addBelow(toItem: amountValue, height: UIValues.successTitleHeight, margins: UIValues.successTitleMargins)

        // -- Button
        let confirmText = localizer.localize(with: UIStrings.detailsButtonString)
        let confirmButton = CYBButton(title: confirmText,
                                      theme: Cybrid.theme,
                                      action: { [weak self] in

            self?.transferViewModel.fetchAccountsInPolling()
            self?.dismiss(animated: true)
        })
        confirmButton.accessibilityIdentifier = "TransferComponent_Modal_Details_Continue"
        confirmButton.addBelow(toItem: title, height: UIValues.successConfirmButtonHeight, margins: UIValues.successConfirmButtonMargins)
    }

    internal func transferViewModal_Error() {

        self.modifyHeight(height: UIValues.modalErrorHeightSize)

        // -- Icon
        let image = UIImage(named: "kyc_error", in: Bundle(for: Self.self), with: nil)!
        let icon = UIImageView(image: image)
        self.componentContent.addSubview(icon)
        icon.constraint(attribute: .top,
                        relatedBy: .equal,
                        toItem: self.componentContent,
                        attribute: .topMargin,
                        constant: UIValues.errorIconMargins.top)
        icon.constraint(attribute: .leading,
                        relatedBy: .equal,
                        toItem: self.componentContent,
                        attribute: .leading,
                        constant: UIValues.errorIconMargins.left)
        icon.constraint(attribute: .width,
                        relatedBy: .equal,
                        toItem: nil,
                        attribute: .notAnAttribute,
                        constant: UIValues.errorIconSize.width)
        icon.constraint(attribute: .height,
                        relatedBy: .equal,
                        toItem: nil,
                        attribute: .notAnAttribute,
                        constant: UIValues.errorIconSize.height)

        // -- Title
        let title = UILabel()
        title.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.sizeToFit()
        title.font = UIValues.errorTitleFont
        title.textColor = UIColor.black
        title.textAlignment = .left
        title.setLocalizedText(key: UIStrings.errorTitleText, localizer: localizer)
        self.componentContent.addSubview(title)
        title.constraint(attribute: .leading,
                         relatedBy: .equal,
                         toItem: icon,
                         attribute: .trailing,
                         constant: UIValues.errorTitleMargins.left)
        title.constraint(attribute: .top,
                         relatedBy: .equal,
                         toItem: self.componentContent,
                         attribute: .topMargin,
                         constant: UIValues.errorTitleMargins.top)
        title.constraint(attribute: .trailing,
                         relatedBy: .equal,
                         toItem: self.componentContent,
                         attribute: .trailing,
                         constant: -UIValues.errorTitleMargins.right)
        title.constraint(attribute: .height,
                         relatedBy: .equal,
                         toItem: nil,
                         attribute: .notAnAttribute,
                         constant: UIValues.errorTitleHeight)

        // -- Description
        let desc = UILabel()
        desc.font = UIValues.errorDescFont
        desc.textColor = UIColor.black
        desc.textAlignment = .left
        desc.numberOfLines = 0
        desc.setLocalizedText(key: UIStrings.errorDescText, localizer: localizer)
        desc.addBelow(toItem: title, height: UIValues.errorDescHeight, margins: UIValues.errorDescMargins)

        // -- Done button
        let doneButtonText = localizer.localize(with: UIStrings.errorDoneButtonText)
        let doneButton = CYBButton(title: doneButtonText,
                                   theme: Cybrid.theme,
                                   action: {
            self.dismiss(animated: true)
        })
        doneButton.addBelow(toItem: desc, height: 48, margins: UIValues.errorDoneButtonMargins)
    }
}

extension TransferModal {

    enum UIValues {

        // -- Sizes
        static let modalHeightSize: CGFloat = 374
        static let modalErrorHeightSize: CGFloat = 260
        static let modalSuccessHeightSize: CGFloat = 290
        static let loadingTitleHeight: CGFloat = 20
        static let loadingSpinnerHeight: CGFloat = 30
        static let contentTitleHeight: CGFloat = 28
        static let contentAmountHeight: CGFloat = 26
        static let contentAmountValueHeight: CGFloat = 16
        static let contentDepositDateHeight: CGFloat = 26
        static let contentDateValueHeight: CGFloat = 16
        static let contentFromToHeight: CGFloat = 26
        static let contentFromToValueHeight: CGFloat = 16
        static let errorIconSize = CGSize(width: 24, height: 24)
        static let errorTitleHeight: CGFloat = 28
        static let errorDescHeight: CGFloat = 50
        static let successIconSize = CGSize(width: 80, height: 80)
        static let successValueTitleHeight: CGFloat = 35
        static let successTitleHeight: CGFloat = 30
        static let successConfirmButtonHeight: CGFloat = 48

        // -- Fonts
        static let loadingTitleFont = UIFont.make(ofSize: 17, weight: .bold)
        static let titleFont = UIFont.make(ofSize: 22)
        static let accountTitleFont = UIFont.make(ofSize: 13, weight: .bold)
        static let accountValueFont = UIFont.make(ofSize: 14)
        static let errorTitleFont = UIFont.make(ofSize: 22, weight: .medium)
        static let errorDescFont = UIFont.make(ofSize: 16)
        static let successBigTitleFont = UIFont.make(ofSize: 22)
        static let successTitleFont = UIFont.make(ofSize: 18)

        // -- Colors
        static let loadingTitleColor = UIColor.black
        static let titleColor = UIColor.black
        static let accountTitleColor = UIColor(hex: "#424242")
        static let accountValueColor = UIColor.black
        static let successTitleColor = UIColor(hex: "#424242")

        // -- Margins
        static let loadingTitleMargin = UIEdgeInsets(top: 40, left: 10, bottom: 0, right: 10)
        static let loadingSpinnerMargin = UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
        static let contentTitleMargins = UIEdgeInsets(top: 10, left: 24, bottom: 0, right: 24)
        static let contentAmountMargins = UIEdgeInsets(top: 24, left: 24, bottom: 0, right: 24)
        static let contentAmountValueMargins = UIEdgeInsets(top: 5, left: 24, bottom: 0, right: 24)
        static let contentDepositDateMargins = UIEdgeInsets(top: 13, left: 24, bottom: 0, right: 24)
        static let contentDateValueMargins = UIEdgeInsets(top: 5, left: 24, bottom: 0, right: 24)
        static let contentFromToMargins = UIEdgeInsets(top: 13, left: 24, bottom: 0, right: 24)
        static let contentFromToValueMargins = UIEdgeInsets(top: 5, left: 24, bottom: 0, right: 24)
        static let contentButtonMargins = UIEdgeInsets(top: 30, left: 24, bottom: 26, right: 24)
        static let errorIconMargins = UIEdgeInsets(top: 30, left: 24, bottom: 0, right: 24)
        static let errorTitleMargins = UIEdgeInsets(top: 30, left: 10, bottom: 0, right: 24)
        static let errorDescMargins = UIEdgeInsets(top: 20, left: 24, bottom: 0, right: 24)
        static let errorDoneButtonMargins = UIEdgeInsets(top: 20, left: 24, bottom: 0, right: 24)
        static let successIconMargins = UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0)
        static let successValueTitleMargins = UIEdgeInsets(top: 10, left: 24, bottom: 0, right: 24)
        static let successTitleMargins = UIEdgeInsets(top: 5, left: 24, bottom: 0, right: 24)
        static let successConfirmButtonMargins = UIEdgeInsets(top: 20, left: 24, bottom: 0, right: 24)
    }

    enum UIStrings {

        static let loadingTitleString = "cybrid.transfer.modal.loading.text"
        static let contentDepositTitleString = "cybrid.transfer.modal.content.title.deposit.text"
        static let contentWithdrawTitleString = "cybrid.transfer.modal.content.title.withdraw.text"
        static let contentAmountString = "cybrid.transfer.modal.content.amount.text"
        static let contentDepositDateString = "cybrid.transfer.modal.content.deposit.text"
        static let contentWithdrawDateString = "cybrid.transfer.modal.content.withdraw.text"
        static let contentFromString = "cybrid.transfer.modal.content.from.text"
        static let contentToString = "cybrid.transfer.modal.content.to.text"
        static let contentButtonDepositString = "cybrid.transfer.modal.content.button.deposit.text"
        static let contentButtonWithdrawString = "cybrid.transfer.modal.content.button.withdraw.text"

        static let detailsDepositTitleString = "cybrid.transfer.modal.details.title.deposit.text"
        static let detailsWithdrawTitleString = "cybrid.transfer.modal.details.title.withdraw.text"
        static let detailsButtonString = "cybrid.transfer.modal.details.button.text"

        static let errorTitleText = "cybrid.transfer.modal.error.title.text"
        static let errorDescText = "cybrid.transfer.modal.error.desc.text"
        static let errorDoneButtonText = "cybrid.transfer.modal.error.doneButton.text"

        static let successTitle = "cybrid.transfer.modal.success.title"
    }
}

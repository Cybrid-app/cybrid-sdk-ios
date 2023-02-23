//
//  BankAccountDetail.swift
//  CybridSDK
//
//  Created by Erick Sanchez Perez on 20/02/23.
//

import CybridApiBankSwift
import Foundation
import UIKit

class BankAccountDetailModal: UIModal {

    internal var localizer: Localizer!

    private var bankAccountsViewModel: BankAccountsViewModel
    private var account: ExternalBankAccountBankModel

    internal var componentContent = UIView()
    internal var confirmButton: CYBButton?

    init(bankAccountsViewModel: BankAccountsViewModel, account: ExternalBankAccountBankModel) {

        self.bankAccountsViewModel = bankAccountsViewModel
        self.account = account

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

extension BankAccountDetailModal {

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
        self.bankAccountsViewModel.modalState.bind { state in

            self.removeSubViewsFromContent()
            switch state {

            case .CONTENT:
                self.bankAccountDetail_Content()

            case .CONFIRM:
                self.bankAccountsDetail_Confirm()
            }
        }
    }

    internal func removeSubViewsFromContent() {

        for view in self.componentContent.subviews {
            view.removeFromSuperview()
        }
    }
}

extension BankAccountDetailModal {

    internal func bankAccountDetail_Content() {

        // -- Title
        let title = self.createTitle(key: UIStrings.titleString)
        title.asFirstIn(self.componentContent, height: UIValues.titleHeight, margins: UIValues.titleMargins)

        // -- Account name
        let accountNameTitle = self.createAccountTitle(key: UIStrings.accountString)
        accountNameTitle.addBelow(toItem: title, height: UIValues.accountTitleHeight, margins: UIValues.accountTitleFirstMargin)

        let accountNameValue = self.createAccountValue(value: self.account.name ?? "")
        accountNameValue.addBelow(toItem: accountNameTitle, height: UIValues.accountValueHeight, margins: UIValues.accountValueMargin)

        // -- Account Status
        let accountStatusTitle = self.createAccountTitle(key: UIStrings.accountStatusString)
        accountStatusTitle.addBelow(toItem: accountNameValue, height: UIValues.accountTitleHeight, margins: UIValues.accountTitleMargin)

        let accountStatusValue = self.createAccountValue(value: self.account.state?.rawValue ?? "")
        accountStatusValue.addBelow(toItem: accountStatusTitle, height: UIValues.accountValueHeight, margins: UIValues.accountValueMargin)

        // -- Account Number
        let accountNumberTitle = self.createAccountTitle(key: UIStrings.accountNumberString)
        accountNumberTitle.addBelow(toItem: accountStatusValue, height: UIValues.accountTitleHeight, margins: UIValues.accountTitleMargin)

        let accountNumberValue = self.createAccountValue(value: self.account.plaidAccountMask ?? "")
        accountNumberValue.addBelow(toItem: accountNumberTitle, height: UIValues.accountValueHeight, margins: UIValues.accountValueMargin)

        // -- Divider
        let divider = UIView()
        divider.backgroundColor = UIValues.dividerColor
        divider.translatesAutoresizingMaskIntoConstraints = false
        divider.addBelow(toItem: accountNumberValue, height: 1, margins: UIValues.dividerMargin)

        // -- Close Button
        let nextButtonText = localizer.localize(with: UIStrings.disconnectButtonString)
        let nextButton = UIButton()
        nextButton.backgroundColor = .clear
        nextButton.setTitle(nextButtonText, for: .normal)
        nextButton.setTitleColor(UIValues.closeButtonColor, for: .normal)
        nextButton.addTarget(self, action: #selector(bankAccountDetail_Content_Action), for: .touchUpInside)
        nextButton.addBelowToBottom(topItem: divider, bottomItem: self.view, margins: UIValues.closeButtonMargin)
    }

    internal func bankAccountsDetail_Confirm() {

        self.modifyHeight(height: UIValues.modalCofirmSize)

        // -- Title
        let title = self.createTitle(key: UIStrings.confirmTitleString)
        title.asFirstIn(self.componentContent, height: UIValues.titleHeight, margins: UIValues.titleMargins)

        // -- Body
        let bodyOne = localizer.localize(with: UIStrings.confirmBodyOneString)
        let bodyTwo = localizer.localize(with: UIStrings.confirmBodyTwoString)
        let accountName = self.account.plaidAccountName ?? ""
        let accountMask = self.account.plaidAccountMask ?? ""
        let bodyData = "\(accountName) (\(accountMask))"
        let bodyText = "\(bodyOne)\(bodyData)\(bodyTwo)"

        let body = UILabel()
        body.font = UIValues.confirmBodyFont
        body.textColor = UIValues.confirmBodyColor
        body.text = bodyText
        body.numberOfLines = 4
        body.addBelow(toItem: title, height: UIValues.confirmBodyHeight, margins: UIValues.confirmBodyMargin)

        // -- Divider
        let divider = UIView()
        divider.backgroundColor = UIValues.dividerColor
        divider.translatesAutoresizingMaskIntoConstraints = false
        divider.addBelow(toItem: body, height: 1, margins: UIValues.dividerMargin)

        // -- Buttons
        let actionButtons = self.createActionButtons()
        actionButtons.addBelow(toItem: divider, height: UIValues.confirmActionButtonsHeight, margins: UIValues.confirmActionButtonsMargin)
    }

    @objc
    internal func bankAccountDetail_Content_Action() {

        self.bankAccountsViewModel.modalState.value = .CONFIRM
    }

    @objc
    internal func bankAccountDetail_Confirm_Action() {

        self.disableDismiss = true
        self.confirmButton?.customState = .processing
        self.bankAccountsViewModel.disconnectExternalBankAccount(account: account) {
            self.dismiss(animated: true)
        }
    }
}

extension BankAccountDetailModal {

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

    private func createActionButtons() -> UIStackView {

        let theme = Cybrid.theme
        let cancelText = localizer.localize(with: UIStrings.confirmCancelButton)
        let confirmText = localizer.localize(with: UIStrings.confirmConfirmButton)

        // -- Cancel button
        let cancelButton = CYBButton(title: cancelText,
                                     style: .secondary,
                                     theme: theme
        ) { [weak self] in

            if !(self?.disableDismiss ?? false) {
                self?.bankAccountsViewModel.modalState.value = .CONTENT
            }
            self?.cancel()
        }

        // -- Confirm button
        confirmButton = CYBButton(title: confirmText,
                                  theme: theme,
                                  action: {})
        confirmButton?.addTarget(self, action: #selector(bankAccountDetail_Confirm_Action), for: .touchUpInside)

        // -- Stack
        let stackView = UIStackView(arrangedSubviews: [cancelButton, confirmButton!])
        stackView.axis = .horizontal
        stackView.alignment = .trailing
        stackView.distribution = .fillEqually
        return stackView
    }
}

extension BankAccountDetailModal {

    enum UIValues {

        // -- Sizes
        static let modalSize: CGFloat = 411
        static let modalCofirmSize: CGFloat = 300
        static let titleHeight: CGFloat = 28
        static let accountTitleHeight: CGFloat = 26
        static let accountValueHeight: CGFloat = 16
        static let confirmBodyHeight: CGFloat = 64
        static let confirmActionButtonsHeight: CGFloat = 50

        // -- Fonts
        static let titleFont = UIFont.make(ofSize: 22)
        static let accountTitleFont = UIFont.make(ofSize: 12)
        static let accountValueFont = UIFont.make(ofSize: 14)
        static let confirmBodyFont = UIFont.make(ofSize: 16)

        // -- Colors
        static let titleColor = UIColor.black
        static let accountTitleColor = UIColor(hex: "#424242")
        static let accountValueColor = UIColor.black
        static let dividerColor = UIColor(hex: "#C6C6C8")
        static let closeButtonColor = UIColor(hex: "#007AFF")
        static let confirmBodyColor = UIColor.black

        // -- Margins
        static let titleMargins = UIEdgeInsets(top: 28, left: 24, bottom: 0, right: 24)
        static let accountTitleFirstMargin = UIEdgeInsets(top: 30, left: 24, bottom: 0, right: 24)
        static let accountTitleMargin = UIEdgeInsets(top: 13, left: 24, bottom: 0, right: 24)
        static let accountValueMargin = UIEdgeInsets(top: 5, left: 24, bottom: 0, right: 24)
        static let dividerMargin = UIEdgeInsets(top: 22, left: 24, bottom: 0, right: 24)
        static let closeButtonMargin = UIEdgeInsets(top: 18, left: 24, bottom: 26, right: 24)
        static let confirmBodyMargin = UIEdgeInsets(top: 35, left: 24, bottom: 0, right: 24)
        static let confirmActionButtonsMargin = UIEdgeInsets(top: 15, left: 24, bottom: 0, right: 24)
    }

    enum UIStrings {

        static let titleString = "cybrid.bank.accounts.detail.title.text"
        static let accountString = "cybrid.bank.accounts.detail.account.name.title"
        static let accountStatusString = "cybrid.bank.accounts.detail.account.status.title"
        static let accountNumberString = "cybrid.bank.accounts.detail.account.number.title"
        static let disconnectButtonString = "cybrid.bank.accounts.detail.account.disconnect.button"
        static let confirmTitleString = "cybrid.bank.accounts.detail.confirm.title.text"
        static let confirmBodyOneString = "cybrid.bank.accounts.detail.confirm.body.one.text"
        static let confirmBodyTwoString = "cybrid.bank.accounts.detail.confirm.body.two.text"
        static let confirmCancelButton = "cybrid.bank.accounts.detail.confirm.cancel.button"
        static let confirmConfirmButton = "cybrid.bank.accounts.detail.confirm.confirm.button"
    }
}

//
//  BankAccountDetail.swift
//  CybridSDK
//
//  Created by Erick Sanchez Perez on 20/02/23.
//

import CybridApiBankSwift
import Foundation
import UIKit

class BankAccountDetail: UIModal {

    internal var localizer: Localizer!

    private var bankAccountsViewModel: BankAccountsViewModel
    private var account: ExternalBankAccountBankModel

    internal var componentContent = UIView()
    private lazy var divider: UIView = {
        let underline = UIView()
        underline.backgroundColor = UIValues.dividerColor
        underline.translatesAutoresizingMaskIntoConstraints = false
        return underline
      }()

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

extension BankAccountDetail {

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
                self.banAccountDetail_Content()

            default:
                print()
            }
        }
    }

    internal func removeSubViewsFromContent() {

        for view in self.componentContent.subviews {
            view.removeFromSuperview()
        }
    }
}

extension BankAccountDetail {

    internal func banAccountDetail_Content() {

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
        divider.addBelow(toItem: accountNumberValue, height: 1, margins: UIValues.dividerMargin)

        // -- Close Button
        let closeButtonText = localizer.localize(with: UIStrings.disconnectButtonString)
        let closeButton = UIButton()
        closeButton.backgroundColor = .clear
        closeButton.setTitle(closeButtonText, for: .normal)
        closeButton.setTitleColor(UIValues.closeButtonColor, for: .normal)
        //closeButton.addTarget(self, action: #selector(close), for: .touchUpInside)
        closeButton.addBelowToBottom(topItem: divider, bottomItem: self.view, margins: UIValues.closeButtonMargin)
    }
}

extension BankAccountDetail {

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

extension BankAccountDetail {

    enum UIValues {

        // -- Sizes
        static let modalSize: CGFloat = 411
        static let titleHeight: CGFloat = 28
        static let accountTitleHeight: CGFloat = 26
        static let accountValueHeight: CGFloat = 16

        // -- Fonts
        static let titleFont = UIFont.make(ofSize: 22)
        static let accountTitleFont = UIFont.make(ofSize: 12)
        static let accountValueFont = UIFont.make(ofSize: 14)

        // -- Colors
        static let titleColor = UIColor.black
        static let accountTitleColor = UIColor(hex: "#424242")
        static let accountValueColor = UIColor.black
        static let dividerColor = UIColor(hex: "#C6C6C8")
        static let closeButtonColor = UIColor(hex: "#007AFF")

        // -- Margins
        static let titleMargins = UIEdgeInsets(top: 28, left: 24, bottom: 0, right: 24)
        static let accountTitleFirstMargin = UIEdgeInsets(top: 30, left: 24, bottom: 0, right: 24)
        static let accountTitleMargin = UIEdgeInsets(top: 13, left: 24, bottom: 0, right: 24)
        static let accountValueMargin = UIEdgeInsets(top: 5, left: 24, bottom: 0, right: 24)
        static let dividerMargin = UIEdgeInsets(top: 22, left: 24, bottom: 0, right: 24)
        static let closeButtonMargin = UIEdgeInsets(top: 28, left: 24, bottom: 26, right: 24)
    }

    enum UIStrings {

        static let titleString = "cybrid.bank.accounts.detail.title.text"
        static let accountString = "cybrid.bank.accounts.detail.account.name.title"
        static let accountStatusString = "cybrid.bank.accounts.detail.account.status.title"
        static let accountNumberString = "cybrid.bank.accounts.detail.account.number.title"
        static let disconnectButtonString = "cybrid.bank.accounts.detail.account.disconnect.button"
    }
}

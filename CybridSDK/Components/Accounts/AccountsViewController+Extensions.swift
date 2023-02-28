//
//  AccountsViewController+Extensions.swift
//  CybridSDK
//
//

import Foundation
import UIKit

extension AccountsViewController {

    internal func accountsView_Loading() {

        let title = UILabel()
        title.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.sizeToFit()
        title.font = UIValues.componentTitleFont
        title.textColor = UIValues.componentTitleColor
        title.textAlignment = .center
        title.setLocalizedText(key: UIStrings.accountsLoadingTitle, localizer: localizer)

        self.componentContent.addSubview(title)
        title.constraint(attribute: .centerY,
                         relatedBy: .equal,
                         toItem: self.componentContent,
                         attribute: .centerY)
        title.constraint(attribute: .leading,
                         relatedBy: .equal,
                         toItem: self.componentContent,
                         attribute: .leading,
                         constant: UIValues.componentTitleMargin.left)
        title.constraint(attribute: .trailing,
                         relatedBy: .equal,
                         toItem: self.componentContent,
                         attribute: .trailing,
                         constant: -UIValues.componentTitleMargin.right)
        title.constraint(attribute: .height,
                         relatedBy: .equal,
                         toItem: nil,
                         attribute: .notAnAttribute,
                         constant: UIValues.componentTitleHeight)

        // -- Spinner
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.addBelow(toItem: title, height: UIValues.loadingSpinnerHeight, margins: UIValues.loadingSpinnerMargin)
        spinner.color = UIColor.black
        spinner.startAnimating()
    }
}

extension AccountsViewController {

    enum UIValues {

        // -- Sizes
        static let accountComponentTitleSize: CGFloat = 12
        static let accountComponentTitleHeight: CGFloat = 20
        static let accountComponentTitleMargin = UIEdgeInsets(top: 40, left: 10, bottom: 0, right: 10)
        static let accountValueTitleSize: CGFloat = 23
        static let accountValueTitleHeight: CGFloat = 40
        static let accountValueTitleMargin = UIEdgeInsets(top: 3, left: 10, bottom: 0, right: 10)
        static let accountsTableRowHeight: CGFloat = 64
        static let accountsTableMargin = UIEdgeInsets(top: 20, left: 10, bottom: 4, right: 10)

        // -- Colors
        static let accountComponentTitleColor = UIColor(hex: "#636366")
        static let accountValueTitleColor = UIColor.black

        // -- Sizes
        static let componentTitleSize: CGFloat = 17
        static let componentTitleHeight: CGFloat = 20
        static let componentTitleMargin = UIEdgeInsets(top: 40, left: 10, bottom: 0, right: 10)
        static let componentRequiredButtonsMargin = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: -10)

        static let loadingSpinnerHeight: CGFloat = 30
        static let loadingSpinnerMargin = UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
        static let componentRequiredButtonsHeight: CGFloat = 50
        static let bankAccountsRowHeight: CGFloat = 47

        // -- Colors
        static let componentTitleColor = UIColor.black
        static let contentNoAccountsTitleColor = UIColor.init(hex: "#636366")

        // -- Fonts
        static let compontntContentTitleFont = UIFont.make(ofSize: 25)
        static let componentTitleFont = UIFont.make(ofSize: 17, weight: .bold)
        static let contentNoAccountsTitleFont = UIFont.make(ofSize: 18)

        // -- Margins
        static let bankAccountsTableMargins = UIEdgeInsets(top: 35, left: 15, bottom: 30, right: 15)
    }

    enum UIStrings {

        static let accountsLoadingTitle = "cybrid.accounts.loading.title"

        static let componentContentTitleText = "cybrid.bank.content.title.text"
        static let componentContentNoAccountText = "cybrid.bank.content.noAccounts.text"

        static let loadingText = "cybrid.bank.accounts.loading.text"
        static let requiredText = "cybrid.bank.accounts.required.text"
        static let requiredButtonText = "cybrid.bank.accounts.required.button.text"
        static let doneText = "cybrid.bank.accounts.done.text"
        static let doneButtonText = "cybrid.bank.accounts.done.button.text"
        static let errorText = "cybrid.bank.accounts.error.text"
        static let errorButtonText = "cybrid.bank.accounts.error.button.text"
    }
}

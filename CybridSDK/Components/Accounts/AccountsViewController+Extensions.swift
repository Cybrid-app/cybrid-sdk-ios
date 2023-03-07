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

    internal func accountsView_Content() {

        // -- Title
        let accountsTitle = UILabel()
        accountsTitle.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        accountsTitle.translatesAutoresizingMaskIntoConstraints = false
        accountsTitle.sizeToFit()
        accountsTitle.font = UIFont.make(ofSize: UIValues.accountComponentTitleSize)
        accountsTitle.textColor = UIValues.accountComponentTitleColor
        accountsTitle.textAlignment = .center
        accountsTitle.setLocalizedText(key: UIStrings.accountsLoadingTitle, localizer: localizer)
        accountsTitle.asFirstIn(self.componentContent,
                                height: UIValues.accountComponentTitleHeight,
                                margins: UIValues.accountComponentTitleMargin)

        // -- Subtitle
        let accountsValueTitle = UILabel()
        accountsValueTitle.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        accountsValueTitle.translatesAutoresizingMaskIntoConstraints = false
        accountsValueTitle.sizeToFit()
        accountsValueTitle.font = UIFont.make(ofSize: UIValues.accountValueTitleSize)
        accountsValueTitle.textColor = UIValues.accountValueTitleColor
        accountsValueTitle.textAlignment = .center
        accountsValueTitle.text = "... \(accountsViewModel.currentCurrency)"
        accountsValueTitle.addBelow(toItem: accountsTitle,
                                    height: UIValues.accountValueTitleHeight,
                                    margins: UIValues.accountValueTitleMargin)

        // -- Live update - subtitle
        self.accountsViewModel.accountTotalBalance.bind { value in
            accountsValueTitle.text = value
        }

        // -- Table
        self.accountsTable.delegate = self.accountsViewModel
        self.accountsTable.dataSource = self.accountsViewModel

        self.accountsTable.register(AccountsCell.self, forCellReuseIdentifier: AccountsCell.reuseIdentifier)
        self.accountsTable.register(AccountsFiatCell.self, forCellReuseIdentifier: AccountsFiatCell.reuseIdentifier)

        self.accountsTable.rowHeight = UIValues.accountsTableRowHeight
        self.accountsTable.estimatedRowHeight = UIValues.accountsTableRowHeight
        self.accountsTable.translatesAutoresizingMaskIntoConstraints = false
        self.accountsTable.addBelowToBottom(topItem: accountsValueTitle,
                                            bottomItem: self.componentContent,
                                            margins: UIValues.accountsTableMargin)

        // -- Live Data - Table
        accountsViewModel.balances.bind { _ in
            self.accountsTable.reloadData()
        }
    }
}

extension AccountsViewController: AccountsViewProvider {

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath,
                   withData dataModel: AccountAssetPriceModel) -> UITableViewCell {

        if dataModel.account.type == .trading {
            let cell = (tableView.dequeueReusableCell(
                withIdentifier: AccountsCell.reuseIdentifier,
                for: indexPath) as? AccountsCell)!
            cell.setData(balance: dataModel)
            return cell
        } else {
            let cell = (tableView.dequeueReusableCell(
                withIdentifier: AccountsFiatCell.reuseIdentifier,
                for: indexPath) as? AccountsFiatCell)!
            cell.setData(balance: dataModel)
            return cell
        }
    }

    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath,
                   withBalance balance: AccountAssetPriceModel) {

        let accountTradesViewController = AccountTradesViewController(
            balance: balance,
            accountsViewModel: accountsViewModel)

        if self.navigationController != nil {
            self.navigationController?.pushViewController(accountTradesViewController, animated: true)
        } else {
            self.modalPresentationStyle = .fullScreen
            self.present(accountTradesViewController, animated: true)
        }
    }
}

extension AccountsViewController {

    enum UIValues {

        // -- Sizes
        static let accountComponentTitleSize: CGFloat = 12
        static let accountComponentTitleHeight: CGFloat = 20
        static let accountComponentTitleMargin = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        static let accountValueTitleSize: CGFloat = 23
        static let accountValueTitleHeight: CGFloat = 40
        static let accountValueTitleMargin = UIEdgeInsets(top: 3, left: 10, bottom: 0, right: 10)
        static let accountsTableRowHeight: CGFloat = 64
        static let accountsTableMargin = UIEdgeInsets(top: 10, left: 10, bottom: 4, right: 10)

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

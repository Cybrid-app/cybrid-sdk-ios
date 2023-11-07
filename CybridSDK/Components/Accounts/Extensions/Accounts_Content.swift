//
//  Accounts_Content.swift
//  CybridSDK
//
//  Created by Erick Sanchez on 06/11/23.
//

import UIKit

extension AccountsView {

    internal func accountsView_Content() {

        // -- Title
        let accountsTitle = UILabel()
        accountsTitle.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        accountsTitle.translatesAutoresizingMaskIntoConstraints = false
        accountsTitle.sizeToFit()
        accountsTitle.font = UIFont.make(ofSize: UIValues.accountComponentTitleSize)
        accountsTitle.textColor = UIValues.accountComponentTitleColor
        accountsTitle.textAlignment = .center
        accountsTitle.setLocalizedText(key: UIStrings.accountsContentTitle, localizer: localizer)
        accountsTitle.asFirstIn(self,
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
        accountsValueTitle.text = "... \(Cybrid.fiat.code)"
        accountsValueTitle.accessibilityIdentifier = "AccountsAcomponent_Content_Balance_Value_Label"
        accountsValueTitle.addBelow(toItem: accountsTitle,
                                    height: UIValues.accountValueTitleHeight,
                                    margins: UIValues.accountValueTitleMargin)

        // -- Live update - subtitle
        self.accountsViewModel.accountTotalBalance.bind { value in
            accountsValueTitle.text = value
        }

        // -- Button
        let transferButton = CYBButton(title: localizer.localize(with: UIStrings.accountsContentTransferButton)) {

            let transferController = TransferViewController()
            if self.parentController?.navigationController != nil {
                self.parentController?.navigationController?.pushViewController(transferController, animated: true)
            } else {
                self.parentController?.present(transferController, animated: true)
            }
        }
        transferButton.asLast(parent: self,
                              height: UIValues.accountsContentTransferButtonHeight,
                              margins: UIValues.accountsContentTransferButtonMargins)

        // -- Table
        accountsTable = UITableView()
        accountsTable.delegate = self
        accountsTable.dataSource = self
        accountsTable.register(AccountsCell.self, forCellReuseIdentifier: AccountsCell.reuseIdentifier)
        accountsTable.register(AccountsFiatCell.self, forCellReuseIdentifier: AccountsFiatCell.reuseIdentifier)
        accountsTable.rowHeight = UIValues.accountsTableRowHeight
        accountsTable.estimatedRowHeight = UIValues.accountsTableRowHeight
        accountsTable.translatesAutoresizingMaskIntoConstraints = false
        accountsTable.accessibilityIdentifier = "AccountsAcomponent_Content_Table"
        accountsTable.addInTheMiddle(topItem: accountsValueTitle,
                                     bottomItem: transferButton,
                                     margins: UIValues.accountsTableMargin)

        // -- Live Data - Table
        accountsViewModel.balances.bind { _ in
            self.accountsTable.reloadData()
        }
    }
}

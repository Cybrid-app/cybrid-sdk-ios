//
//  BankAccountsView_Content.swift
//  CybridSDK
//
//  Created by Erick Sanchez on 07/11/23.
//

import UIKit

extension BankAccountsView {

    internal func bankAccountsView_Content() {

        // -- Title
        let title = UILabel()
        title.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.sizeToFit()
        title.font = UIValues.compontntContentTitleFont
        title.textColor = UIValues.componentTitleColor
        title.textAlignment = .center
        title.setLocalizedText(key: UIStrings.componentContentTitleText, localizer: localizer)

        self.addSubview(title)
        title.constraint(attribute: .centerX,
                         relatedBy: .equal,
                         toItem: self,
                         attribute: .centerX)
        title.constraint(attribute: .top,
                         relatedBy: .equal,
                         toItem: self,
                         attribute: .topMargin,
                         constant: 15)
        title.constraint(attribute: .height,
                         relatedBy: .equal,
                         toItem: nil,
                         attribute: .notAnAttribute,
                         constant: 32)

        // -- No accounts
        let noAccountsTitle = UILabel()
        noAccountsTitle.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        noAccountsTitle.translatesAutoresizingMaskIntoConstraints = false
        noAccountsTitle.sizeToFit()
        noAccountsTitle.font = UIValues.contentNoAccountsTitleFont
        noAccountsTitle.textColor = UIValues.contentNoAccountsTitleColor
        noAccountsTitle.textAlignment = .center
        noAccountsTitle.setLocalizedText(key: UIStrings.componentContentNoAccountText, localizer: localizer)
        noAccountsTitle.isHidden = !self.bankAccountsViewModel.accounts.isEmpty

        self.addSubview(noAccountsTitle)
        noAccountsTitle.constraint(attribute: .centerX,
                                   relatedBy: .equal,
                                   toItem: self,
                                   attribute: .centerX)
        noAccountsTitle.constraint(attribute: .centerY,
                                   relatedBy: .equal,
                                   toItem: self,
                                   attribute: .centerY)
        noAccountsTitle.constraint(attribute: .height,
                                   relatedBy: .equal,
                                   toItem: nil,
                                   attribute: .notAnAttribute,
                                   constant: 20)

        // -- Accounts Table
        self.accountsTable.delegate = self
        self.accountsTable.dataSource = self
        self.accountsTable.register(BankAccountCell.self, forCellReuseIdentifier: BankAccountCell.reuseIdentifier)
        self.accountsTable.rowHeight = UIValues.bankAccountsRowHeight
        self.accountsTable.estimatedRowHeight = UIValues.bankAccountsRowHeight
        self.accountsTable.translatesAutoresizingMaskIntoConstraints = false

        // -- Constraints
        self.addSubview(self.accountsTable)
        self.accountsTable.translatesAutoresizingMaskIntoConstraints = false
        accountsTable.constraint(attribute: .top,
                                 relatedBy: .equal,
                                 toItem: title,
                                 attribute: .bottom,
                                 constant: UIValues.bankAccountsTableMargins.top)
        accountsTable.constraint(attribute: .bottom,
                                 relatedBy: .equal,
                                 toItem: self,
                                 attribute: .bottomMargin,
                                 constant: UIValues.bankAccountsTableMargins.bottom)
        accountsTable.constraint(attribute: .leading,
                                 relatedBy: .equal,
                                 toItem: self,
                                 attribute: .leading,
                                 constant: UIValues.bankAccountsTableMargins.left)
        accountsTable.constraint(attribute: .trailing,
                                 relatedBy: .equal,
                                 toItem: self,
                                 attribute: .trailing,
                                 constant: -UIValues.bankAccountsTableMargins.right)
        self.accountsTable.reloadData()
    }
}

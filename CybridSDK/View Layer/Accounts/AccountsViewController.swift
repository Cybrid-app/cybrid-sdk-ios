//
//  AccountsViewController.swift
//  CybridSDK
//
//  Created by Erick Sanchez Perez on 19/08/22.
//

import Foundation
import UIKit

public final class AccountsViewController: UIViewController {

    private var accountsViewModel: AccountsViewModel!
    private var theme: Theme!
    private var localizer: Localizer!

    // -- UI Vars
    let accountTile = UILabel()
    let accountValueTile = UILabel()
    let accountsTable = UITableView()

    public init() {

        super.init(nibName: nil, bundle: nil)
        self.accountsViewModel = AccountsViewModel(
            cellProvider: self,
            dataProvider: CybridSession.current,
            logger: Cybrid.logger
        )
        self.theme = Cybrid.theme
        self.localizer = CybridLocalizer()
        self.accountsViewModel.getAccounts()
        self.setupView()
    }

    @available(iOS, deprecated: 10, message: "You should never use this init method.")
    required init?(coder: NSCoder) {
      assertionFailure("init(coder:) should never be used")
      return nil
    }

    func setupView() {

        view.backgroundColor = .white
        self.setupBalanceView()
        self.setupTableView()
    }

    func setupBalanceView() {

        self.createAccountTitle()
        self.createAccountValueTitle()
    }

    func setupTableView() {

        self.createAccountsTable()
    }
}

extension AccountsViewController {

    private func createAccountTitle() {

        accountTile.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        accountTile.translatesAutoresizingMaskIntoConstraints = false
        accountTile.sizeToFit()
        accountTile.font = FormatStyle.headerSmall.font
        accountTile.textColor = FormatStyle.headerSmall.textColor
        accountTile.textAlignment = .center
        accountTile.text = "Account Value"
        self.view.addSubview(accountTile)
        accountTile.translatesAutoresizingMaskIntoConstraints = false
        accountTile.constraint(attribute: .top,
                               relatedBy: .equal,
                               toItem: self.view,
                               attribute: .topMargin,
                               constant: 40)
        accountTile.constraint(attribute: .leading,
                               relatedBy: .equal,
                               toItem: self.view,
                               attribute: .leading,
                               constant: 10)
        accountTile.constraint(attribute: .trailing,
                               relatedBy: .equal,
                               toItem: self.view,
                               attribute: .trailing,
                               constant: -10)
        accountTile.constraint(attribute: .height,
                               relatedBy: .equal,
                               toItem: nil,
                               attribute: .notAnAttribute,
                               constant: 20)
    }

    private func createAccountValueTitle(value: String = "$116,256.56 USD") {

        accountValueTile.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        accountValueTile.translatesAutoresizingMaskIntoConstraints = false
        accountValueTile.sizeToFit()
        accountValueTile.font = UIFont.systemFont(ofSize: 23, weight: .regular)
        accountValueTile.textColor = UIColor.black
        accountValueTile.textAlignment = .center
        accountValueTile.text = value
        self.view.addSubview(accountValueTile)
        accountValueTile.translatesAutoresizingMaskIntoConstraints = false
        accountValueTile.constraint(attribute: .top,
                                    relatedBy: .equal,
                                    toItem: self.accountTile,
                                    attribute: .bottom,
                                    constant: 3)
        accountValueTile.constraint(attribute: .leading,
                                    relatedBy: .equal,
                                    toItem: self.view,
                                    attribute: .leading,
                                    constant: 10)
        accountValueTile.constraint(attribute: .trailing,
                                    relatedBy: .equal,
                                    toItem: self.view,
                                    attribute: .trailing,
                                    constant: -10)
        accountValueTile.constraint(attribute: .height,
                                    relatedBy: .equal,
                                    toItem: nil,
                                    attribute: .notAnAttribute,
                                    constant: 40)
    }

    private func createAccountsTable() {

        self.accountsTable.delegate = self.accountsViewModel
        self.accountsTable.dataSource = self.accountsViewModel
        self.accountsTable.register(AccountsCell.self, forCellReuseIdentifier: AccountsCell.reuseIdentifier)
        self.accountsTable.rowHeight = 64
        self.accountsTable.estimatedRowHeight = 64
        self.accountsTable.translatesAutoresizingMaskIntoConstraints = false
        self.accountsTable.makeKeyboardHandler()

        // -- Constraints
        self.view.addSubview(self.accountsTable)
        self.accountsTable.translatesAutoresizingMaskIntoConstraints = false
        accountsTable.constraint(attribute: .top,
                                 relatedBy: .equal,
                                 toItem: self.accountValueTile,
                                 attribute: .bottom,
                                 constant: 40)
        accountsTable.constraint(attribute: .bottom,
                                 relatedBy: .equal,
                                 toItem: self.view,
                                 attribute: .bottomMargin,
                                 constant: 4)
        accountsTable.constraint(attribute: .leading,
                                 relatedBy: .equal,
                                 toItem: self.view,
                                 attribute: .leading,
                                 constant: 10)
        accountsTable.constraint(attribute: .trailing,
                                 relatedBy: .equal,
                                 toItem: self.view,
                                 attribute: .trailing,
                                 constant: -10)

        // -- Live Data
        accountsViewModel.balances.bind { _ in
            self.accountsTable.reloadData()
        }
    }
}

extension AccountsViewController: AccountsViewProvider {

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath,
                   withData dataModel: AccountAssetPriceModel) -> UITableViewCell {

        guard
            let cell = tableView.dequeueReusableCell(
                withIdentifier: AccountsCell.reuseIdentifier,
                for: indexPath) as? AccountsCell
        else {
            return UITableViewCell()
        }
        cell.setData(balance: dataModel)
        return cell
    }
}

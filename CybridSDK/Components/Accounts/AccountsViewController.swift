//
//  AccountsViewController.swift
//  CybridSDK
//
//  Created by Erick Sanchez Perez on 19/08/22.
//

import Foundation
import UIKit

public final class AccountsViewController: UIViewController {

    public enum ViewState { case LOADING, CONTENT }

    private var accountsViewModel: AccountsViewModel!
    private var theme: Theme!
    internal var localizer: Localizer!

    internal var componentContent = UIView()
    internal var currentState: Observable<ViewState> = .init(.LOADING)

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

        self.currentState = self.accountsViewModel.uiState
        self.setupView()
    }

    @available(iOS, deprecated: 10, message: "You should never use this init method.")
    required init?(coder: NSCoder) {
      assertionFailure("init(coder:) should never be used")
      return nil
    }

    func setupView() {

        view.backgroundColor = .white
        self.initComponentContent()
        self.manageCurrentStateUI()
        self.accountsViewModel.getAccounts()
        // self.createAccountTitle()
        // self.createAccountValueTitle()
        // self.createAccountsTable()
    }
}

extension AccountsViewController {

    private func initComponentContent() {

        // -- Component Container
        self.view.addSubview(self.componentContent)
        self.componentContent.constraint(attribute: .top,
                                         relatedBy: .equal,
                                         toItem: self.view,
                                         attribute: .topMargin,
                                         constant: 10)
        self.componentContent.constraint(attribute: .leading,
                                         relatedBy: .equal,
                                         toItem: self.view,
                                         attribute: .leading,
                                         constant: 10)
        self.componentContent.constraint(attribute: .trailing,
                                         relatedBy: .equal,
                                         toItem: self.view,
                                         attribute: .trailing,
                                         constant: -10)
        self.componentContent.constraint(attribute: .bottom,
                                         relatedBy: .equal,
                                         toItem: self.view,
                                         attribute: .bottomMargin,
                                         constant: 10)
    }

    private func manageCurrentStateUI() {

        self.currentState.bind { state in

            self.removeSubViewsFromContent()
            switch state {

            case .LOADING:
                self.accountsView_Loading()

            case .CONTENT:
                print() // self.bankAccountsView_Content()
            }
        }
    }

    internal func removeSubViewsFromContent() {

        for view in self.componentContent.subviews {
            view.removeFromSuperview()
        }
    }
}

extension AccountsViewController {

    private func createAccountTitle() {

        accountTile.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        accountTile.translatesAutoresizingMaskIntoConstraints = false
        accountTile.sizeToFit()
        accountTile.font = UIFont.make(ofSize: UIValues.accountComponentTitleSize)
        accountTile.textColor = UIValues.accountComponentTitleColor
        accountTile.textAlignment = .center
        accountTile.setLocalizedText(key: UIStrings.accountsLoadingTitle, localizer: localizer)

        self.view.addSubview(accountTile)
        accountTile.translatesAutoresizingMaskIntoConstraints = false
        accountTile.constraint(attribute: .top,
                               relatedBy: .equal,
                               toItem: self.view,
                               attribute: .topMargin,
                               constant: UIValues.accountComponentTitleMargin.top)
        accountTile.constraint(attribute: .leading,
                               relatedBy: .equal,
                               toItem: self.view,
                               attribute: .leading,
                               constant: UIValues.accountComponentTitleMargin.left)
        accountTile.constraint(attribute: .trailing,
                               relatedBy: .equal,
                               toItem: self.view,
                               attribute: .trailing,
                               constant: -UIValues.accountComponentTitleMargin.right)
        accountTile.constraint(attribute: .height,
                               relatedBy: .equal,
                               toItem: nil,
                               attribute: .notAnAttribute,
                               constant: UIValues.accountComponentTitleHeight)
    }

    private func createAccountValueTitle() {

        accountValueTile.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        accountValueTile.translatesAutoresizingMaskIntoConstraints = false
        accountValueTile.sizeToFit()
        accountValueTile.font = UIFont.make(ofSize: UIValues.accountValueTitleSize)
        accountValueTile.textColor = UIValues.accountValueTitleColor
        accountValueTile.textAlignment = .center
        accountValueTile.text = "... \(accountsViewModel.currentCurrency)"

        view.addSubview(accountValueTile)
        accountValueTile.translatesAutoresizingMaskIntoConstraints = false
        accountValueTile.constraint(attribute: .top,
                                    relatedBy: .equal,
                                    toItem: self.accountTile,
                                    attribute: .bottom,
                                    constant: UIValues.accountValueTitleMargin.top)
        accountValueTile.constraint(attribute: .leading,
                                    relatedBy: .equal,
                                    toItem: self.view,
                                    attribute: .leading,
                                    constant: UIValues.accountValueTitleMargin.left)
        accountValueTile.constraint(attribute: .trailing,
                                    relatedBy: .equal,
                                    toItem: self.view,
                                    attribute: .trailing,
                                    constant: -UIValues.accountValueTitleMargin.right)
        accountValueTile.constraint(attribute: .height,
                                    relatedBy: .equal,
                                    toItem: nil,
                                    attribute: .notAnAttribute,
                                    constant: UIValues.accountValueTitleHeight)

        // -- Live update
        accountsViewModel.accountTotalBalance.bind { value in
            self.accountValueTile.text = value
        }
    }

    private func createAccountsTable() {

        self.accountsTable.delegate = self.accountsViewModel
        self.accountsTable.dataSource = self.accountsViewModel
        self.accountsTable.register(AccountsCell.self, forCellReuseIdentifier: AccountsCell.reuseIdentifier)
        self.accountsTable.rowHeight = UIValues.accountsTableRowHeight
        self.accountsTable.estimatedRowHeight = UIValues.accountsTableRowHeight
        self.accountsTable.translatesAutoresizingMaskIntoConstraints = false

        // -- Constraints
        self.view.addSubview(self.accountsTable)
        self.accountsTable.translatesAutoresizingMaskIntoConstraints = false
        accountsTable.constraint(attribute: .top,
                                 relatedBy: .equal,
                                 toItem: self.accountValueTile,
                                 attribute: .bottom,
                                 constant: UIValues.accountsTableMargin.top)
        accountsTable.constraint(attribute: .bottom,
                                 relatedBy: .equal,
                                 toItem: self.view,
                                 attribute: .bottomMargin,
                                 constant: UIValues.accountsTableMargin.bottom)
        accountsTable.constraint(attribute: .leading,
                                 relatedBy: .equal,
                                 toItem: self.view,
                                 attribute: .leading,
                                 constant: UIValues.accountsTableMargin.left)
        accountsTable.constraint(attribute: .trailing,
                                 relatedBy: .equal,
                                 toItem: self.view,
                                 attribute: .trailing,
                                 constant: -UIValues.accountsTableMargin.right)

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

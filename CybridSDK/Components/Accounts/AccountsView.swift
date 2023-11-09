//
//  AccountsView.swift
//  CybridSDK
//
//  Created by Erick Sanchez on 06/11/23.
//

import UIKit

public final class AccountsView: Component {

    public enum State { case LOADING, CONTENT }

    internal var accountsViewModel: AccountsViewModel!
    internal var theme: Theme!
    internal var localizer: Localizer!

    var accountsTable = UITableView()

    public func initComponent(accountsViewModel: AccountsViewModel) {

        self.accountsViewModel = accountsViewModel
        self.theme = Cybrid.theme
        self.localizer = CybridLocalizer()
        self.setupView()
        self.accountsViewModel.getAccounts()

        // --
        self.accountsTable.register(AccountsCell.self, forCellReuseIdentifier: AccountsCell.reuseIdentifier)
        self.accountsTable.register(AccountsFiatCell.self, forCellReuseIdentifier: AccountsFiatCell.reuseIdentifier)
    }

    override func setupView() {

        self.backgroundColor = UIColor.white
        self.overrideUserInterfaceStyle = .light
        self.manageCurrentStateUI()
    }

    private func manageCurrentStateUI() {

        // -- Await for UI State changes
        self.accountsViewModel.uiState.bind { state in

            self.removeSubViewsFromContent()
            switch state {

            case .LOADING:
                self.accountsView_Loading()

            case .CONTENT:
                self.accountsView_Content()
            }
        }
    }
}

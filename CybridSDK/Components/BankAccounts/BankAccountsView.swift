//
//  BankAccountsView.swift
//  CybridSDK
//
//  Created by Erick Sanchez on 07/11/23.
//

import LinkKit
import UIKit

public final class BankAccountsView: Component {

    public enum State { case LOADING, CONTENT, REQUIRED, DONE, ERROR, AUTH }
    public enum ModalState { case CONTENT, CONFIRM }

    internal var bankAccountsViewModel: BankAccountsViewModel!
    internal var theme: Theme!
    internal var localizer: Localizer!

    // -- Views
    internal let accountsTable = UITableView()

    // -- Plaid
    internal var linkConfiguration: LinkTokenConfiguration!

    public func initComponent(bankAccountsViewModel: BankAccountsViewModel) {

        self.bankAccountsViewModel = bankAccountsViewModel
        self.theme = Cybrid.theme
        self.localizer = CybridLocalizer()
        self.setupView()
        self.bankAccountsViewModel.fetchExternalBankAccounts()
    }

    override func setupView() {

        self.backgroundColor = UIColor.white
        self.overrideUserInterfaceStyle = .light
        self.manageCurrentStateUI()
        self.accountsTable.register(BankAccountCell.self, forCellReuseIdentifier: BankAccountCell.reuseIdentifier)
    }
    
    private func manageCurrentStateUI() {

        // -- Await for UI State changes
        self.bankAccountsViewModel.uiState.bind { state in
            
            self.removeSubViewsFromContent()
            switch state {
            case .LOADING:
                self.bankAccountsView_Loading()

            case .CONTENT:
                self.bankAccountsView_Content()

            case .REQUIRED:
                self.bankAccountsView_Required()

            case .DONE:
                self.bankAccountsView_Done()

            case .ERROR:
                self.bankAccountsView_Error()

            case.AUTH:
                self.bankAccountsView_Authorization()
            }
        }
    }
}

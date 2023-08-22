//
//  BankAccountsViewController.swift
//  CybridSDK
//
//  Created by Erick Sanchez Perez on 15/11/22.
//

import Foundation
import UIKit
import LinkKit

public final class BankAccountsViewController: UIViewController {

    public enum BankAccountsViewState { case LOADING, CONTENT, REQUIRED, DONE, ERROR, AUTH }
    public enum BankAccountsModalViewState { case CONTENT, CONFIRM }

    internal var bankAccountsViewModel: BankAccountsViewModel!
    internal var theme: Theme!
    internal var localizer: Localizer!

    internal var componentContent = UIView()
    internal var currentState: Observable<BankAccountsViewState> = .init(.LOADING)

    // -- Views
    internal let accountsTable = UITableView()

    // -- Plaid
    internal var linkConfiguration: LinkTokenConfiguration!

    public init() {

        super.init(nibName: nil, bundle: nil)
        self.bankAccountsViewModel = BankAccountsViewModel(
            dataProvider: CybridSession.current,
            cellProvider: self,
            logger: Cybrid.logger)
        self.theme = Cybrid.theme
        self.localizer = CybridLocalizer()
        self.currentState = self.bankAccountsViewModel.uiState
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
        self.accountsTable.register(BankAccountCell.self, forCellReuseIdentifier: BankAccountCell.reuseIdentifier)
        self.bankAccountsViewModel.fetchExternalBankAccounts()
    }
}

extension BankAccountsViewController {

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

        // -- Await for UI State changes
        self.currentState.bind { state in

            self.removeSubViewsFromContent()
            switch state {

            case .LOADING:
                // self.bankAccountsView_Loading()
                self.bankAccountsView_Authorization()

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

    internal func removeSubViewsFromContent() {

        for view in self.componentContent.subviews {
            view.removeFromSuperview()
        }
    }

    internal func openPlaid() {

        self.createLinkConfiguration(token: self.bankAccountsViewModel.latestWorkflow?.plaidLinkToken ?? "") { [self] in

            let result = Plaid.create(self.linkConfiguration)
            switch result {
            case .failure(let error):
                print("Unable to create Plaid handler due to: \(error)")
            case .success(let handler):
                handler.open(presentUsing: .viewController(self))
            }
        }
    }

    private func createLinkConfiguration(token: String, _ completion: @escaping () -> Void) {

        self.linkConfiguration = LinkTokenConfiguration(token: token, onSuccess: { _ in
            completion()
        })
    }
}

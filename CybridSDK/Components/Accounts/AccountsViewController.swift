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

    internal var accountsViewModel: AccountsViewModel!
    internal var theme: Theme!
    internal var localizer: Localizer!

    internal var componentContent = UIView()
    internal var currentState: Observable<ViewState> = .init(.LOADING)

    // -- UI Vars
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

        self.accountsTable.register(AccountsCell.self, forCellReuseIdentifier: AccountsCell.reuseIdentifier)
        self.accountsTable.register(AccountsFiatCell.self, forCellReuseIdentifier: AccountsFiatCell.reuseIdentifier)

        self.accountsViewModel.getAccounts()
    }

    override public func viewWillDisappear(_ animated: Bool) {

        super.viewWillDisappear(animated)
        self.accountsViewModel.pricesPolling?.stop()
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
                self.accountsView_Content()
            }
        }
    }

    internal func removeSubViewsFromContent() {

        for view in self.componentContent.subviews {
            view.removeFromSuperview()
        }
    }
}

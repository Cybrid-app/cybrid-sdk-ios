//
//  AccountsViewController.swift
//  CybridSDK
//
//  Created by Erick Sanchez Perez on 19/08/22.
//

import Foundation
import UIKit

public final class AccountsViewController: UIViewController {

    let componentContainer = UIView()
    var accountsView: AccountsView!

    public init() {
        super.init(nibName: nil, bundle: nil)
    }

    @available(iOS, deprecated: 10, message: "You should never use this init method.")
    required init?(coder: NSCoder) {
        assertionFailure("init(coder:) should never be used")
        return nil
    }

    override public func viewDidLoad() {

        super.viewDidLoad()

        // -- Container
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(self.componentContainer)
        self.componentContainer.backgroundColor = UIColor.clear
        self.componentContainer.constraint(attribute: .top,
                                           relatedBy: .equal,
                                           toItem: self.view,
                                           attribute: .topMargin,
                                           constant: 0)
        self.componentContainer.constraint(attribute: .leading,
                                           relatedBy: .equal,
                                           toItem: self.view,
                                           attribute: .leading,
                                           constant: 10)
        self.componentContainer.constraint(attribute: .trailing,
                                           relatedBy: .equal,
                                           toItem: self.view,
                                           attribute: .trailing,
                                           constant: -10)
        self.componentContainer.constraint(attribute: .bottom,
                                           relatedBy: .equal,
                                           toItem: self.view,
                                           attribute: .bottomMargin,
                                           constant: 5)

        // -- ExternalWallets View
        self.accountsView = AccountsView()

        // -- AccountsViewModel
        let accountsViewModel = AccountsViewModel(
            dataProvider: CybridSession.current,
            logger: Cybrid.logger)

        // -- ExternalWallets View
        self.accountsView = AccountsView()
        self.accountsView.embed(in: self.componentContainer)
        self.accountsView.parentController = self
        self.accountsView.initComponent(accountsViewModel: accountsViewModel)
    }

    override public func viewWillDisappear(_ animated: Bool) {

        super.viewWillDisappear(animated)
        self.accountsView.accountsViewModel.pricesPolling?.stop()
    }
}

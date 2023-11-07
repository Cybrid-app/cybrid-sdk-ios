//
//  AccountTradesViewcontroller.swift
//  CybridSDK
//
//  Created by Erick Sanchez Perez on 25/08/22.
//

import UIKit

public final class AccountTradesViewController: UIViewController {

    var accountTradesView: AccountTradesView!
    var balance: BalanceUIModel!

    public init(balance: BalanceUIModel) {
        super.init(nibName: nil, bundle: nil)
        self.balance = balance
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

        // -- AccountsViewModel
        let accountTradesViewModel = AccountTradesViewModel(
            dataProvider: CybridSession.current,
            logger: Cybrid.logger)

        // -- ExternalWallets View
        self.accountTradesView = AccountTradesView()
        self.accountTradesView.embed(in: self.view)
        self.accountTradesView.parentController = self
        self.accountTradesView.initComponent(
            balance: self.balance,
            accountTradesViewModel: accountTradesViewModel)
    }
}

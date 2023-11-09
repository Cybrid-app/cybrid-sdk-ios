//
//  AccountTransfersViewController.swift
//  CybridSDK
//
//  Created by Erick Sanchez Perez on 03/04/23.
//

import UIKit
import CybridApiBankSwift

public final class AccountTransfersViewController: UIViewController {

    var accountTransfersView: AccountTransfersView!
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

        // -- AccountTransfersViewModel
        let accountTransfersViewModel = AccountTransfersViewModel(
            dataProvider: CybridSession.current,
            logger: Cybrid.logger)

        // -- AccountTransfersView
        self.accountTransfersView = AccountTransfersView()
        self.accountTransfersView.embed(in: self.view)
        self.accountTransfersView.parentController = self
        self.accountTransfersView.initComponent(
            balance: balance,
            accountTransfersViewModel: accountTransfersViewModel)
    }
}

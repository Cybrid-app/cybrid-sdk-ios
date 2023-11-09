//
//  BankAccountsViewController.swift
//  CybridSDK
//
//  Created by Erick Sanchez Perez on 15/11/22.
//

import UIKit

public final class BankAccountsViewController: UIViewController {

    let componentContainer = UIView()
    var bankAccountsView: BankAccountsView!

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

        // -- BankAccountsViewModel
        let bankAccountsViewModel = BankAccountsViewModel(
            dataProvider: CybridSession.current,
            logger: Cybrid.logger)

        // -- IdentityView
        self.bankAccountsView = BankAccountsView()
        self.bankAccountsView.embed(in: self.componentContainer)
        self.bankAccountsView.parentController = self
        self.bankAccountsView.initComponent(bankAccountsViewModel: bankAccountsViewModel)
    }
}

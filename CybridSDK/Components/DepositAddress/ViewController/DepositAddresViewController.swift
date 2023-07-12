//
//  DepositAddresViewController.swift
//  CybridSDK
//
//  Created by Erick Sanchez on 10/07/23.
//

import UIKit

public final class DepositAddresViewController: UIViewController {

    let componentContainer = UIView()
    var depositAddressView: DepositAddresView!

    public init() {

        super.init(nibName: nil, bundle: nil)
        // -- ViewModel init
        self.setupViewController()
    }

    @available(iOS, deprecated: 10, message: "You should never use this init method.")
    required init?(coder: NSCoder) {

        assertionFailure("init(coder:) should never be used")
        return nil
    }

    internal func setupViewController() {

        // -- Container
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(self.componentContainer)
        self.componentContainer.backgroundColor = UIColor.clear
        self.componentContainer.constraint(attribute: .top,
                                           relatedBy: .equal,
                                           toItem: self.view,
                                           attribute: .topMargin,
                                           constant: 10)
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
                                           constant: 10)

        // -- Deposit Address Component
        self.depositAddressView = DepositAddresView()
        self.depositAddressView.embed(in: self.componentContainer)
        self.depositAddressView.bindViewModel()
    }
}

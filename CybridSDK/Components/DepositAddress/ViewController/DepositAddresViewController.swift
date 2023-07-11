//
//  DepositAddresViewController.swift
//  CybridSDK
//
//  Created by Erick Sanchez on 10/07/23.
//

import UIKit

public final class DepositAddresViewController: UIViewController {

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

        self.view.backgroundColor = UIColor.white
        self.depositAddressView = DepositAddresView()
        self.depositAddressView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.depositAddressView)

        NSLayoutConstraint.activate([
            depositAddressView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            depositAddressView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            depositAddressView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            depositAddressView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

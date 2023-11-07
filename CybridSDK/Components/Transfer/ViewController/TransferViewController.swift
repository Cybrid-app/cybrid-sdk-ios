//
//  TransferViewController.swift
//  CybridSDK
//
//  Created by Erick Sanchez Perez on 23/12/22.
//

import UIKit

public final class TransferViewController: UIViewController {

    let componentContainer = UIView()
    var transferView: TransferView!

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

        // -- TradeViewModel
        let transferViewModel = TransferViewModel(
            dataProvider: CybridSession.current,
            logger: Cybrid.logger)

        // -- ExternalWallets View
        self.transferView = TransferView()
        self.transferView.embed(in: self.componentContainer)
        self.transferView.parentController = self
        self.transferView.initComponent(transferViewModel: transferViewModel)
    }
}

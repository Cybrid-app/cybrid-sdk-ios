//
//  ExternalWalletsViewController.swift
//  CybridSDK
//
//  Created by Erick Sanchez on 21/08/23.
//

import UIKit

public final class ExternalWalletsViewController: UIViewController {

    let componentContainer = UIView()
    var externalWalletsView: ExternalWalletsView!

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

        // -- ExternalWallets View Model
        let externalWalletsViewModel = ExternalWalletsViewModel()

        // -- ExternalWallets View
        self.externalWalletsView = ExternalWalletsView()
        self.externalWalletsView.embed(in: self.componentContainer)
        self.externalWalletsView.initComponent()
    }
}

//
//  IdentityVerificationViewController.swift
//  CybridSDK
//
//  Created by Erick Sanchez Perez on 31/10/22.
//

import UIKit

public final class IdentityVerificationViewController: UIViewController {

    let componentContainer = UIView()
    var identityView: IdentityView!

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

        // -- AccountsViewModel
        let identityVerificationViewModel = IdentityVerificationViewModel(
            dataProvider: CybridSession.current,
            logger: Cybrid.logger)

        // -- IdentityView
        self.identityView = IdentityView()
        self.identityView.embed(in: self.componentContainer)
        self.identityView.parentController = self
        self.identityView.initComponent(identityVerificationViewModel: identityVerificationViewModel)
    }
}

extension IdentityVerificationViewController {

    private func initComponentContent() {

        let logo = UIImageView(image: UIImage(
            named: "cybrid",
            in: Bundle(for: Self.self),
            with: nil
        ))

        self.view.addSubview(logo)
        logo.constraint(attribute: .top,
                        relatedBy: .equal,
                        toItem: self.view,
                        attribute: .topMargin,
                        constant: 40)
        logo.constraint(attribute: .centerX,
                        relatedBy: .equal,
                        toItem: self.view,
                        attribute: .centerX)
        logo.constraint(attribute: .height,
                        relatedBy: .equal,
                        toItem: nil,
                        attribute: .notAnAttribute,
                        constant: 30)
        logo.constraint(attribute: .width,
                        relatedBy: .equal,
                        toItem: nil,
                        attribute: .notAnAttribute,
                        constant: 180)
    }
}

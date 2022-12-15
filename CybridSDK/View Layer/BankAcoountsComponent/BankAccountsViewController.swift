//
//  BankAccountsViewController.swift
//  CybridSDK
//
//  Created by Erick Sanchez Perez on 15/11/22.
//

import Foundation
import UIKit
import LinkKit

public final class BankAccountsViewcontroller: UIViewController {

    public enum BankAccountsViewState { case LOADING, REQUIRED, DONE, ERROR }

    private var bankAccountsViewModel: BankAccountsViewModel!
    private var theme: Theme!
    private var localizer: Localizer!

    private var componentContent = UIView()
    private var currentState: Observable<BankAccountsViewState> = .init(.LOADING)

    public init() {

        super.init(nibName: nil, bundle: nil)
        self.bankAccountsViewModel = BankAccountsViewModel(
            dataProvider: CybridSession.current,
            UIState: self.currentState,
            logger: Cybrid.logger)
        self.theme = Cybrid.theme
        self.localizer = CybridLocalizer()
        self.setupView()
    }

    @available(iOS, deprecated: 10, message: "You should never use this init method.")
    required init?(coder: NSCoder) {

      assertionFailure("init(coder:) should never be used")
      return nil
    }

    func setupView() {

        view.backgroundColor = .white
    }
}

extension BankAccountsViewcontroller {

    enum UIValues {

        // -- Sizes
        static let componentTitleSize: CGFloat = 17
        static let componentTitleHeight: CGFloat = 20
        static let componentTitleMargin = UIEdgeInsets(top: 40, left: 10, bottom: 0, right: 10)
        static let componentRequiredButtonsMargin = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: -10)

        static let loadingSpinnerHeight: CGFloat = 30
        static let loadingSpinnerMargin = UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
        static let componentRequiredButtonsHeight: CGFloat = 50

        // -- Colors
        static let componentTitleColor = UIColor.black

        // -- Fonts
        static let componentTitleFont = UIFont.make(ofSize: 17, weight: .bold)
    }

    enum UIStrings {

        static let addAccountButtonText = "cybrid.bank.accounts.addAccount.button"

        static let loadingText = "cybrid.kyc.loading.text"
        static let requiredText = "cybrid.kyc.required.text"
        static let requiredCancelText = "cybrid.kyc.required.cancel"
        static let requiredBeginText = "cybrid.kyc.required.begin"
        static let verifiedText = "cybrid.kyc.verified.text"
        static let verifiedDone = "cybrid.kyc.verified.done"
        static let errorText = "cybrid.kyc.error.text"
        static let errorDone = "cybrid.kyc.error.done"
        static let reviewingText = "cybrid.kyc.reviewing.text"
        static let reviewingDone = "cybrid.kyc.reviewing.done"
    }
}

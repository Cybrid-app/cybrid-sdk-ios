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

    // private var identityVerificationViewModel: IdentityVerificationViewModel!
    private var theme: Theme!
    private var localizer: Localizer!

    private var componentContent = UIView()
    private var currentState: Observable<BankAccountsViewState> = .init(.LOADING)

    public init() {

        super.init(nibName: nil, bundle: nil)
        /*self.identityVerificationViewModel = IdentityVerificationViewModel(
            dataProvider: CybridSession.current,
            UIState: self.currentState,
            logger: Cybrid.logger)*/
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
        self.initComponentContent()
        self.manageCurrentStateUI()

        DispatchQueue.main.asyncAfter(deadline: .now() + 6.0) {
            self.currentState.value = .REQUIRED
        }
    }
}

extension BankAccountsViewcontroller {

    private func initComponentContent() {

        // -- Component Container
        self.view.addSubview(self.componentContent)
        self.componentContent.constraint(attribute: .top,
                                         relatedBy: .equal,
                                         toItem: self.view,
                                         attribute: .topMargin,
                                         constant: 10)
        self.componentContent.constraint(attribute: .leading,
                                         relatedBy: .equal,
                                         toItem: self.view,
                                         attribute: .leading,
                                         constant: 10)
        self.componentContent.constraint(attribute: .trailing,
                                         relatedBy: .equal,
                                         toItem: self.view,
                                         attribute: .trailing,
                                         constant: -10)
        self.componentContent.constraint(attribute: .bottom,
                                         relatedBy: .equal,
                                         toItem: self.view,
                                         attribute: .bottomMargin,
                                         constant: 10)
    }

    private func manageCurrentStateUI() {

        // -- Await for UI State changes
        self.currentState.bind { state in

            self.removeSubViewsFromContent()
            switch state {

            case .LOADING:

                self.KYCView_Loading()

            case .REQUIRED:

                self.KYCView_Required()

            case .DONE:

                print("")
                // self.KYCView_Verified()

            case .ERROR:

                print("")
                // self.KYCView_Error()
            }
        }
    }

    private func removeSubViewsFromContent() {

        for view in self.componentContent.subviews {
            view.removeFromSuperview()
        }
    }

    private func KYCView_Loading() {

        let title = UILabel()
        title.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.sizeToFit()
        title.font = UIValues.componentTitleFont
        title.textColor = UIValues.componentTitleColor
        title.textAlignment = .center
        title.text = "Checking Bank Accounts"
        // title.setLocalizedText(key: UIStrings.loadingText, localizer: localizer)

        self.componentContent.addSubview(title)
        title.constraint(attribute: .centerY,
                         relatedBy: .equal,
                         toItem: self.componentContent,
                         attribute: .centerY)
        title.constraint(attribute: .leading,
                         relatedBy: .equal,
                         toItem: self.componentContent,
                         attribute: .leading,
                         constant: UIValues.componentTitleMargin.left)
        title.constraint(attribute: .trailing,
                         relatedBy: .equal,
                         toItem: self.componentContent,
                         attribute: .trailing,
                         constant: -UIValues.componentTitleMargin.right)
        title.constraint(attribute: .height,
                         relatedBy: .equal,
                         toItem: nil,
                         attribute: .notAnAttribute,
                         constant: UIValues.componentTitleHeight)

        // -- Spinner
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.addBelow(toItem: title, height: UIValues.loadingSpinnerHeight, margins: UIValues.loadingSpinnerMargin)
        spinner.color = UIColor.black
        spinner.startAnimating()
    }

    private func KYCView_Required() {

        // -- Title
        self.createStateTitle(
            stringKey: UIStrings.requiredText,
            image: UIImage(named: "kyc_required", in: Bundle(for: Self.self), with: nil)!
        )

        // -- Buttons
        let done = CYBButton(title: localizer.localize(with: UIStrings.addAccountButtonText)) {
            self.openPlaid()
        }

        self.componentContent.addSubview(done)
        done.constraint(attribute: .leading,
                           relatedBy: .equal,
                           toItem: self.componentContent,
                           attribute: .leading,
                           constant: UIValues.componentRequiredButtonsMargin.left)
        done.constraint(attribute: .trailing,
                           relatedBy: .equal,
                           toItem: self.componentContent,
                           attribute: .trailing,
                           constant: UIValues.componentRequiredButtonsMargin.right)
        done.constraint(attribute: .bottom,
                           relatedBy: .equal,
                           toItem: self.componentContent,
                           attribute: .bottomMargin,
                           constant: UIValues.componentRequiredButtonsMargin.bottom)
        done.constraint(attribute: .height,
                           relatedBy: .equal,
                           toItem: nil,
                           attribute: .notAnAttribute,
                           constant: UIValues.componentRequiredButtonsHeight)
    }

    private func createStateTitle(stringKey: String, image: UIImage) {

        let title = UILabel()
        title.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.sizeToFit()
        title.font = UIValues.componentTitleFont
        title.textColor = UIValues.componentTitleColor
        title.textAlignment = .center
        title.text = "No banks accounts connected."
        // title.setLocalizedText(key: stringKey, localizer: localizer)

        self.componentContent.addSubview(title)
        title.constraint(attribute: .centerX,
                       relatedBy: .equal,
                       toItem: self.componentContent,
                       attribute: .centerX)
        title.constraint(attribute: .centerY,
                       relatedBy: .equal,
                       toItem: self.componentContent,
                       attribute: .centerY)
        title.constraint(attribute: .height,
                         relatedBy: .equal,
                         toItem: nil,
                         attribute: .notAnAttribute,
                         constant: 25)

        let icon = UIImageView(image: image)
        self.componentContent.addSubview(icon)
        icon.constraint(attribute: .centerY,
                       relatedBy: .equal,
                       toItem: self.componentContent,
                       attribute: .centerY)
        icon.constraint(attribute: .trailing,
                        relatedBy: .equal,
                        toItem: title,
                        attribute: .leading,
                        constant: -15)
        icon.constraint(attribute: .width,
                        relatedBy: .equal,
                        toItem: nil,
                        attribute: .notAnAttribute,
                        constant: 25)
        icon.constraint(attribute: .height,
                        relatedBy: .equal,
                        toItem: nil,
                        attribute: .notAnAttribute,
                        constant: 25)
        icon.isHidden = true
    }

    private func openPlaid() {

        var linkConfiguration = LinkTokenConfiguration(token: "link-sandbox-09703628-aa09-462f-bdca-2014b9aa3d29") { success in
            print("public-token: \(success.publicToken) metadata: \(success.metadata)")
        }
        let result = Plaid.create(linkConfiguration)
        switch result {
        case .failure(let error):
            print("Unable to create Plaid handler due to: \(error)")
        case .success(let handler):
            handler.open(presentUsing: .viewController(self))
            // linkHandler = handler
        }
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

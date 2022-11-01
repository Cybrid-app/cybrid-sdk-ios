//
//  IdentityVerificationViewController.swift
//  CybridSDK
//
//  Created by Erick Sanchez Perez on 31/10/22.
//

import Foundation
import UIKit

public final class IdentityVerificationViewController: UIViewController {

    public enum KYCViewState { case LOADING, REQUIRED, VERIFIED, ERROR, REVIEWING }

    private var identityVerificationViewModel: IdentityVerificationViewModel!
    private var theme: Theme!
    private var localizer: Localizer!

    private var componentContent = UIView()
    private var currentState: Observable<KYCViewState> = .init(.LOADING)

    public init() {

        super.init(nibName: nil, bundle: nil)
        self.identityVerificationViewModel = IdentityVerificationViewModel(
            dataProvider: CybridSession.current,
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
        initComponentContent()
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

        // -- Component Container
        self.view.addSubview(self.componentContent)
        self.componentContent.constraint(attribute: .top,
                                         relatedBy: .equal,
                                         toItem: logo,
                                         attribute: .bottom,
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

        self.manageCurrentStateUI()
    }

    private func manageCurrentStateUI() {

        // -- Await for UI State changes
        self.currentState.bind { state in

            switch state {

            case .LOADING:

                self.removeSubViewsFromContent()
                self.KYCView_Loading()

            case .REQUIRED:
                break

            case .VERIFIED:
                break

            case .ERROR:
                break

            case .REVIEWING:
                break

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
        title.font = UIFont.make(ofSize: UIValues.componentTitleSize)
        title.textColor = UIValues.componentTitleColor
        title.textAlignment = .center
        title.text = "Checking Identity..."

        self.view.addSubview(title)
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
}

extension IdentityVerificationViewController {

    enum UIValues {

        // -- Sizes
        static let componentTitleSize: CGFloat = 17
        static let componentTitleHeight: CGFloat = 20
        static let componentTitleMargin = UIEdgeInsets(top: 40, left: 10, bottom: 0, right: 10)

        static let loadingSpinnerHeight: CGFloat = 30
        static let loadingSpinnerMargin = UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)

        // -- Colors
        static let componentTitleColor = UIColor.black
    }

    enum UIStrings {

        static let accountComponentTitle = "cybrid.accounts.accountComponentTitle"
    }
}

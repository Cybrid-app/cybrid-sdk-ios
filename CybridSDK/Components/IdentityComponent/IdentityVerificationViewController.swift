//
//  IdentityVerificationViewController.swift
//  CybridSDK
//
//  Created by Erick Sanchez Perez on 31/10/22.
//

import Foundation
import UIKit
import Persona2

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
            uiState: self.currentState,
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
        self.initComponentContent()
        self.manageCurrentStateUI()

        self.identityVerificationViewModel.getCustomerStatus()
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

            case .VERIFIED:

                self.KYCView_Verified()

            case .ERROR:
                self.KYCView_Error()

            case .REVIEWING:
                self.KYCView_Reviewing()
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
        title.setLocalizedText(key: UIStrings.loadingText, localizer: localizer)

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
        let cancel = createButtonForDismiss(title: localizer.localize(with: UIStrings.requiredCancelText))
        let begin = CYBButton(title: localizer.localize(with: UIStrings.requiredBeginText)) {
            self.openPersona()
        }

        let buttons = UIStackView(arrangedSubviews: [cancel, begin])
        buttons.translatesAutoresizingMaskIntoConstraints = false
        buttons.axis = .horizontal
        buttons.spacing = UIConstants.spacingLg
        buttons.distribution = .fillEqually
        buttons.alignment = .fill

        self.componentContent.addSubview(buttons)
        buttons.constraint(attribute: .leading,
                           relatedBy: .equal,
                           toItem: self.componentContent,
                           attribute: .leading,
                           constant: UIValues.componentRequiredButtonsMargin.left)
        buttons.constraint(attribute: .trailing,
                           relatedBy: .equal,
                           toItem: self.componentContent,
                           attribute: .trailing,
                           constant: UIValues.componentRequiredButtonsMargin.right)
        buttons.constraint(attribute: .bottom,
                           relatedBy: .equal,
                           toItem: self.componentContent,
                           attribute: .bottomMargin,
                           constant: UIValues.componentRequiredButtonsMargin.bottom)
        buttons.constraint(attribute: .height,
                           relatedBy: .equal,
                           toItem: nil,
                           attribute: .notAnAttribute,
                           constant: UIValues.componentRequiredButtonsHeight)
    }

    private func KYCView_Verified() {

        // -- Title
        self.createStateTitle(
            stringKey: UIStrings.verifiedText,
            image: UIImage(named: "kyc_verified", in: Bundle(for: Self.self), with: nil)!
        )

        // -- Buttons
        let done = createButtonForDismiss(title: localizer.localize(with: UIStrings.verifiedDone))

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

    private func KYCView_Error() {

        // -- Title
        self.createStateTitle(
            stringKey: UIStrings.errorText,
            image: UIImage(named: "kyc_error", in: Bundle(for: Self.self), with: nil)!
        )

        // -- Buttons
        let done = createButtonForDismiss(title: localizer.localize(with: UIStrings.errorDone))

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

    private func KYCView_Reviewing() {

        // -- Title
        self.createStateTitle(
            stringKey: UIStrings.reviewingText,
            image: UIImage(named: "kyc_reviewing", in: Bundle(for: Self.self), with: nil)!
        )

        // -- Buttons
        let done = createButtonForDismiss(title: localizer.localize(with: UIStrings.reviewingDone))

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
        title.setLocalizedText(key: stringKey, localizer: localizer)

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
    }

    private func createButtonForDismiss(title: String) -> UIButton {

        let button = UIButton(frame: .zero)
        button.layer.cornerRadius = UIConstants.radiusLg
        button.setContentHuggingPriority(.required, for: .horizontal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.constraint(attribute: .height,
                   relatedBy: .greaterThanOrEqual,
                   toItem: nil,
                   attribute: .notAnAttribute,
                   constant: UIConstants.minimumTargetSize)
        button.backgroundColor = theme.colorTheme.accentColor
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitle(title, for: .normal)
        button.addTarget(self, action: #selector(dimissController), for: .touchUpInside)
        return button
    }

    private func openPersona() {

        if let record = self.identityVerificationViewModel.latestIdentityVerification?.identityVerificationDetails {
            if let id = record.personaInquiryId {
                let config = InquiryConfiguration(inquiryId: id)
                Inquiry(config: config, delegate: self).start(from: self)
            }
        }
    }

    @objc func dimissController() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension IdentityVerificationViewController: InquiryDelegate {

    public func inquiryComplete(inquiryId: String, status: String, fields: [String: Persona2.InquiryField]) {

        self.currentState.value = .LOADING
        self.identityVerificationViewModel.getIdentityVerificationStatus(identityWrapper: self.identityVerificationViewModel.latestIdentityVerification)
    }

    public func inquiryCanceled(inquiryId: String?, sessionToken: String?) {}

    public func inquiryError(_ error: Error) {
        self.currentState.value = .ERROR
    }
}

extension IdentityVerificationViewController {

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

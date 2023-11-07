//
//  IdentityView+Extensions.swift
//  CybridSDK
//
//  Created by Erick Sanchez on 07/11/23.
//

import Persona2
import UIKit

extension IdentityView {

    internal func createStateTitle(stringKey: String, image: UIImage) {

        let title = UILabel()
        title.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.sizeToFit()
        title.font = UIValues.componentTitleFont
        title.textColor = UIValues.componentTitleColor
        title.textAlignment = .center
        title.setLocalizedText(key: stringKey, localizer: localizer)

        self.addSubview(title)
        title.constraint(attribute: .centerX,
                         relatedBy: .equal,
                         toItem: self,
                         attribute: .centerX)
        title.constraint(attribute: .centerY,
                         relatedBy: .equal,
                         toItem: self,
                         attribute: .centerY)
        title.constraint(attribute: .height,
                         relatedBy: .equal,
                         toItem: nil,
                         attribute: .notAnAttribute,
                         constant: 25)

        let icon = UIImageView(image: image)
        self.addSubview(icon)
        icon.constraint(attribute: .centerY,
                        relatedBy: .equal,
                        toItem: self,
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

    internal func createButtonForDismiss(title: String) -> UIButton {

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

    internal func openPersona() {

        if let record = self.identityVerificationViewModel.latestIdentityVerification?.identityVerificationDetails {
            if let id = record.personaInquiryId {
                if let parentController = self.parentController {
                    let config = InquiryConfiguration(inquiryId: id)
                    Inquiry(config: config, delegate: self).start(from: parentController)
                }
            }
        }
    }

    @objc func dimissController() {
        self.parentController?.navigationController?.popViewController(animated: true)
    }
}

extension IdentityView: InquiryDelegate {

    public func inquiryComplete(inquiryId: String, status: String, fields: [String: Persona2.InquiryField]) {

        self.identityVerificationViewModel.uiState.value = .LOADING
        self.identityVerificationViewModel.getIdentityVerificationStatus(identityWrapper: self.identityVerificationViewModel.latestIdentityVerification)
    }
    
    public func inquiryCanceled(inquiryId: String?, sessionToken: String?) {}
    
    public func inquiryError(_ error: Error) {
        self.identityVerificationViewModel.uiState.value = .ERROR
    }
}

extension IdentityView {

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

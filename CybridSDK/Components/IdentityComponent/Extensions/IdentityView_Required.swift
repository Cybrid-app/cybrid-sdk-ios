//
//  IdentityView_Required.swift
//  CybridSDK
//
//  Created by Erick Sanchez on 07/11/23.
//

import UIKit

extension IdentityView {

    internal func KYCView_Required() {

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

        self.addSubview(buttons)
        buttons.constraint(attribute: .leading,
                           relatedBy: .equal,
                           toItem: self,
                           attribute: .leading,
                           constant: UIValues.componentRequiredButtonsMargin.left)
        buttons.constraint(attribute: .trailing,
                           relatedBy: .equal,
                           toItem: self,
                           attribute: .trailing,
                           constant: UIValues.componentRequiredButtonsMargin.right)
        buttons.constraint(attribute: .bottom,
                           relatedBy: .equal,
                           toItem: self,
                           attribute: .bottomMargin,
                           constant: UIValues.componentRequiredButtonsMargin.bottom)
        buttons.constraint(attribute: .height,
                           relatedBy: .equal,
                           toItem: nil,
                           attribute: .notAnAttribute,
                           constant: UIValues.componentRequiredButtonsHeight)
    }
}

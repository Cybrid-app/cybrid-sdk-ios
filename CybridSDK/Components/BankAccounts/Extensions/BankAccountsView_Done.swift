//
//  BankAccountsView_Done.swift
//  CybridSDK
//
//  Created by Erick Sanchez on 07/11/23.
//

import UIKit

extension BankAccountsView {

    internal func bankAccountsView_Done() {

        // -- Title
        self.createStateTitle(
            stringKey: UIStrings.doneText,
            image: UIImage(named: "kyc_verified", in: Bundle(for: Self.self), with: nil)!
        )

        // -- Buttons
        let done = CYBButton(title: localizer.localize(with: UIStrings.doneButtonText)) {
            self.parentController?.dismiss(animated: true)
        }

        self.addSubview(done)
        done.constraint(attribute: .leading,
                        relatedBy: .equal,
                        toItem: self,
                        attribute: .leading,
                        constant: UIValues.componentRequiredButtonsMargin.left)
        done.constraint(attribute: .trailing,
                        relatedBy: .equal,
                        toItem: self,
                        attribute: .trailing,
                        constant: UIValues.componentRequiredButtonsMargin.right)
        done.constraint(attribute: .bottom,
                        relatedBy: .equal,
                        toItem: self,
                        attribute: .bottomMargin,
                        constant: UIValues.componentRequiredButtonsMargin.bottom)
        done.constraint(attribute: .height,
                        relatedBy: .equal,
                        toItem: nil,
                        attribute: .notAnAttribute,
                        constant: UIValues.componentRequiredButtonsHeight)
    }
}

//
//  IdentityView_Verified.swift
//  CybridSDK
//
//  Created by Erick Sanchez on 07/11/23.
//

import UIKit

extension IdentityView {

    internal func KYCView_Verified() {

        // -- Title
        self.createStateTitle(
            stringKey: UIStrings.verifiedText,
            image: UIImage(named: "kyc_verified", in: Bundle(for: Self.self), with: nil)!
        )

        // -- Buttons
        let done = createButtonForDismiss(title: localizer.localize(with: UIStrings.verifiedDone))

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

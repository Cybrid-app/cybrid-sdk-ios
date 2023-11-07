//
//  TransferView_Error.swift
//  CybridSDK
//
//  Created by Erick Sanchez on 06/11/23.
//

import UIKit

extension TransferView {

    internal func transferView_Error() {

        // -- Title
        self.createStateTitle(
            stringKey: UIStrings.errorText,
            image: UIImage(named: "kyc_error", in: Bundle(for: Self.self), with: nil)!
        )

        // -- Buttons
        let done = CYBButton(title: localizer.localize(with: UIStrings.errorButton)) {
            if self.parentController?.navigationController != nil {
                self.parentController?.navigationController?.popViewController(animated: true)
            } else {
                self.parentController?.dismiss(animated: true)
            }
        }

        self.componentContent.addSubview(done)
        done.constraint(attribute: .leading,
                        relatedBy: .equal,
                        toItem: self.componentContent,
                        attribute: .leading,
                        constant: UIValues.actionButtonMargin.left)
        done.constraint(attribute: .trailing,
                        relatedBy: .equal,
                        toItem: self.componentContent,
                        attribute: .trailing,
                        constant: UIValues.actionButtonMargin.right)
        done.constraint(attribute: .bottom,
                        relatedBy: .equal,
                        toItem: self.componentContent,
                        attribute: .bottomMargin,
                        constant: UIValues.actionButtonMargin.bottom)
        done.constraint(attribute: .height,
                        relatedBy: .equal,
                        toItem: nil,
                        attribute: .notAnAttribute,
                        constant: UIValues.actionButtonHeight)
    }
}

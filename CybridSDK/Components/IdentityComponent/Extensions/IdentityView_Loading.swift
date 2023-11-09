//
//  IdentityView_Loading.swift
//  CybridSDK
//
//  Created by Erick Sanchez on 07/11/23.
//

import UIKit

extension IdentityView {

    internal func KYCView_Loading() {
        let loadingString = self.localizer.localize(with: UIStrings.loadingText)
        self.createLoaderScreen(text: loadingString)
    }
}

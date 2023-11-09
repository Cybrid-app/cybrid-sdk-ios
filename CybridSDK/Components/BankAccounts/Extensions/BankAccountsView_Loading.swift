//
//  BankAccountsView_Loading.swift
//  CybridSDK
//
//  Created by Erick Sanchez on 07/11/23.
//

import UIKit

extension BankAccountsView {

    internal func bankAccountsView_Loading() {
        let loadingString = self.localizer.localize(with: UIStrings.loadingText)
        self.createLoaderScreen(text: loadingString)
    }
}

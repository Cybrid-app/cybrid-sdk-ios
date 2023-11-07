//
//  AccountsView_Loading.swift
//  CybridSDK
//
//  Created by Erick Sanchez on 06/11/23.
//

import UIKit

extension AccountsView {

    internal func accountsView_Loading() {
        let loadingString = self.localizer.localize(with: UIStrings.accountsLoadingTitle)
        self.createLoaderScreen(text: loadingString)
    }
}

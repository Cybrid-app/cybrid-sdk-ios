//
//  TransferView_Loading.swift
//  CybridSDK
//
//  Created by Erick Sanchez on 06/11/23.
//

import Foundation

extension TransferView {

    internal func transferView_Loading() {
        let loadingString = self.localizer.localize(with: UIStrings.loadingText)
        self.createLoaderScreen(text: loadingString)
    }
}

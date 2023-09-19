//
//  CryptoTransferView+Extensions.swift
//  CybridSDK
//
//  Created by Erick Sanchez on 18/09/23.
//

import UIKit

extension CryptoTransferView {
    
    internal func cryptoTransferView_Loading() {
        
        // let loadingString = localizer.localize(with: UIStrings.loadingText)
        let loadingString = "Loading accounts and wallets"
        self.createLoaderScreen(text: loadingString)
    }
}

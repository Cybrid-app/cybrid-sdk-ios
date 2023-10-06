//
//  CryptoTransferView+Extensions.swift
//  CybridSDK
//
//  Created by Erick Sanchez on 18/09/23.
//

import UIKit

extension CryptoTransferView {

    internal func cryptoTransferView_Loading() {
        let loadingString = self.localizer.localize(with: Strings.loadingTitle)
        self.createLoaderScreen(text: loadingString)
    }
}

extension CryptoTransferView {

    enum UIValues {

        // -- Size
        static let contentSwitchButtonSize = CGSize(width: 14, height: 18)
    }

    enum Strings {

        static let loadingTitle = "cybrid.crypto.transfer.loading.title"
        static let contentTitle = "cybrid.crypto.transfer.content.title"
    }
}

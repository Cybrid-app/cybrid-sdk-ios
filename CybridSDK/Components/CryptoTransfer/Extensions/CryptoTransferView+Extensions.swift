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

    internal func cryptoTransferView_Error(message: String = "") {

        // -- Error container
        let messageString = message.isEmpty ? localizer.localize(with: "cybrid.server.error.generic") : message
        let errorSection = self.createError(message: messageString, font: UIFont.make(ofSize: 17))
        self.addSubview(errorSection)
        errorSection.centerVertical(parent: self)
        errorSection.constraintLeft(self, margin: 10)
        errorSection.constraintRight(self, margin: 10)

        // -- Add button
        let returnButtonString = localizer.localize(with: Strings.errorButton)
        let returnButton = CYBButton(title: returnButtonString) {
            self.back()
        }
        self.addSubview(returnButton)
        returnButton.constraintLeft(self, margin: 10)
        returnButton.constraintRight(self, margin: 10)
        returnButton.constraintBottom(self, margin: 0)
        returnButton.constraintHeight(48)
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
        static let contentFrom = "cybrid.crypto.transfer.content.from"
        static let contentTo = "cybrid.crypto.transfer.content.to"
        static let contentAmount = "cybrid.crypto.transfer.content.amount"
        static let contentButtonMax = "cybrid.crypto.transfer.content.button.max"
        static let contentErrorInsufficient = "cybrid.crypto.transfer.content.error.insufficient"
        static let contentButtonContinue = "cybrid.crypto.transfer.content.button.continue"
        static let errorButton = "cybrid.crypto.transfer.error.button"
    }
}

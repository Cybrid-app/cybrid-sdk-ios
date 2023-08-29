//
//  _Error.swift
//  CybridSDK
//
//  Created by Erick Sanchez on 24/08/23.
//

import UIKit
import CybridApiBankSwift

extension ExternalWalletsView {

    internal func externalWalletsView_Error(message: String = "") {

        // -- Error container
        let messageString = message.isEmpty ? localizer.localize(with: "cybrid.server.error.generic") : message
        let errorSection = self.createError(message: messageString, font: UIFont.make(ofSize: 17))
        self.addSubview(errorSection)
        errorSection.centerVertical(parent: self)
        errorSection.constraintLeft(self, margin: 10)
        errorSection.constraintRight(self, margin: 10)

        // -- Add button
        let returnButtonString = localizer.localize(with: UIStrings.errorButton)
        let returnButton = CYBButton(title: returnButtonString) {
            self.externalWalletViewModel?.uiState.value = self.externalWalletViewModel!.lastUiState
        }
        self.addSubview(returnButton)
        returnButton.constraintLeft(self, margin: 10)
        returnButton.constraintRight(self, margin: 10)
        returnButton.constraintBottom(self, margin: 0)
        returnButton.constraintHeight(48)
    }
}

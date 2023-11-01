//
//  Done.swift
//  CybridSDK
//
//  Created by Erick Sanchez on 27/10/23.
//

import UIKit

extension CryptoTransferModal {

    internal func cryptoTransferModal_Done() {

        self.createDoneScreen(
            content: self.componentContent,
            message: "Transfer done"
        ) {

            self.cryptoTransferViewModel.fetchAccounts()
            self.cancel()
        }
    }
}

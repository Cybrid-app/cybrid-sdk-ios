//
//  _Quote.swift
//  CybridSDK
//
//  Created by Erick Sanchez on 26/09/23.
//

import UIKit

extension CryptoTransferModal {

    internal func cryptoTransferModal_Quote() {

        // -- Title
        let title = self.label(
            font: UIFont.make(ofSize: 22),
            color: UIColor.black,
            text: "Confirm withdraw",
            lineHeight: 1.05,
            aligment: .left)
        self.componentContent.addSubview(title)
        title.constraintLeft(self.componentContent, margin: 10)
        title.constraintTop(self.componentContent, margin: 10)
        title.constraintRight(self.componentContent, margin: 10)
    }
}

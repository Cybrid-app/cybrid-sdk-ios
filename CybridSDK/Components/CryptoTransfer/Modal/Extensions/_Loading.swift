//
//  _Loading.swift
//  CybridSDK
//
//  Created by Erick Sanchez on 26/09/23.
//

import UIKit

extension CryptoTransferModal {

    internal func cryptoTransferModal_Loading() {

        // -- Loading Label Container
        let loadingLabelContainer = UIView()
        self.componentContent.addSubview(loadingLabelContainer)
        loadingLabelContainer.centerVertical(parent: self.componentContent)
        loadingLabelContainer.constraintLeft(self.componentContent, margin: 10)
        loadingLabelContainer.constraintRight(self.componentContent, margin: 10)
        loadingLabelContainer.constraintHeight(100)

        // -- Loading label
        let text = "Loading"
        let loadingLabel = UILabel()
        loadingLabel.font = UIFont.make(ofSize: 22)
        loadingLabel.textColor = UIColor.init(hex: "#3A3A3C")
        let paragraphStyle = getParagraphStyle(1.05)
        paragraphStyle.alignment = .center
        loadingLabel.setParagraphText(text, paragraphStyle)
        loadingLabelContainer.addSubview(loadingLabel)
        loadingLabel.constraintTop(loadingLabelContainer, margin: 0)
        loadingLabel.constraintLeft(loadingLabelContainer, margin: 0)
        loadingLabel.constraintRight(loadingLabelContainer, margin: 0)

        // -- Spinner
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.color = UIColor.init(hex: "#007AFF")
        spinner.startAnimating()
        loadingLabelContainer.addSubview(spinner)
        spinner.below(loadingLabel, top: 25)
        spinner.centerHorizontal(parent: loadingLabelContainer)
        spinner.setConstraintsSize(size: CGSize(width: 43, height: 43))
        spinner.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
    }
}

//
//  ExternalWalletsView+Extensions.swift
//  CybridSDK
//
//  Created by Erick Sanchez on 18/08/23.
//

import UIKit

extension ExternalWalletsView {

    internal func externalWalletsView_Loading() {
        self.createLoaderScreen()
    }
}

extension ExternalWalletsView {

    enum UIValues {

        // -- Size
        static let loadingLoadingLabelContainer = CGSize(width: 0, height: 80)
        static let loadingLabelSize = CGSize(width: 0, height: 28)
        static let loadingSpinnerSize = CGSize(width: 43, height: 43)
        static let errorContainerHeight: CGFloat = 100
        static let errorContainerIconSize = CGSize(width: 40, height: 40)

        // -- Margin
        static let loadingAssetContainerTopMargin: CGFloat = 30
        static let loadingAssetNameTopMargin: CGFloat = 12
        static let loadingSpinnerTopMargin: CGFloat = 15
        static let errorContainerHorizontalMargin: CGFloat = 20
        static let errorContainerIconTopMargin: CGFloat = 15
        static let errorContainerTitleMargins = UIEdgeInsets(top: 5, left: 10, bottom: 0, right: 10)
        static let errorContainerButtonMargins = UIEdgeInsets(top: 15, left: 15, bottom: 0, right: 15)

        // -- Font
        static let loadingAssetNameFont = UIFont.make(ofSize: 24)
        static let contentDepositAddressSubTitleFont = UIFont.make(ofSize: 13)

        // -- Color
        static let loadingAssetNameColor = UIColor.init(hex: "#3A3A3C")
        static let contentDepositAddressWarningColor = UIColor.init(hex: "#636366")
    }

    enum UIStrings {
        
        static let loadingLabelVerifying = "cybrid.deposit.address.loading.label.verifying"
        static let loadingLabelGetting = "cybrid.deposit.address.loading.label.getting"
        static let loadingLabelCreating = "cybrid.deposit.address.loading.label.creating"
        static let contentDepositAddressTitle = "cybrid.deposit.address.content.deposit.address.title"
        static let contentDepositAddressQRWarningOne = "cybrid.deposit.address.content.qr.warning.1"
        static let contentDepositAddressQRWarningTwo = "cybrid.deposit.address.content.qr.warning.2"
        static let contentDepositAddressNetworkTitle = "cybrid.deposit.address.content.deposit.network.title"
        static let contentDepositAddressAddressTitle = "cybrid.deposit.address.content.deposit.address.address.title"
        static let contentDepositAddressTagTitle = "cybrid.deposit.address.content.deposit.tag.title"
        static let contentDepositAddressAmountTitle = "cybrid.deposit.address.content.deposit.amount.title"
        static let contentDepositAddressMessageTitle = "cybrid.deposit.address.content.deposit.message.title"
        static let contentWarning = "cybrid.deposit.address.content.warning"
        static let contentDepositAddressButton = "cybrid.deposit.address.content.button"
        static let error = "cybrid.deposit.address.error"
        static let errorButton = "cybrid.deposit.address.error.button"
    }
}

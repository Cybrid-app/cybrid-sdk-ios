//
//  ExternalWalletsView+Extensions.swift
//  CybridSDK
//
//  Created by Erick Sanchez on 18/08/23.
//

import UIKit

extension ExternalWalletsView {

    internal func externalWalletsView_Loading() {

        let loadingString = localizer.localize(with: UIStrings.loadingText)
        self.createLoaderScreen(text: loadingString)
    }
}

extension ExternalWalletsView: UITableViewDelegate, UITableViewDataSource {

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if tableView.accessibilityIdentifier == "walletsTable" {
            return self.externalWalletViewModel?.externalWalletsActive.count ?? 0
        } else {
            return 0
        }
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let wallet = (self.externalWalletViewModel?.externalWalletsActive[indexPath.row])!
        guard
            let cell = tableView.dequeueReusableCell(
                withIdentifier: ExternalWalletCell.reuseIdentifier,
                for: indexPath) as? ExternalWalletCell
        else {
            return UITableViewCell()
        }
        cell.setData(wallet: wallet)
        return cell
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let wallet = self.externalWalletViewModel?.externalWalletsActive[indexPath.row]
        self.externalWalletViewModel?.goToWalletDetail(wallet!)
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52
    }
}

extension ExternalWalletsView {

    enum UIValues {

        // -- Size
        static let errorContainerHeight: CGFloat = 100
        static let errorContainerIconSize = CGSize(width: 40, height: 40)

        // -- Margin
        static let errorContainerHorizontalMargin: CGFloat = 20
        static let errorContainerIconTopMargin: CGFloat = 15
        static let errorContainerTitleMargins = UIEdgeInsets(top: 5, left: 10, bottom: 0, right: 10)
        static let errorContainerButtonMargins = UIEdgeInsets(top: 15, left: 15, bottom: 0, right: 15)

        // -- Font
        static let contentDepositAddressSubTitleFont = UIFont.make(ofSize: 13)

        // -- Color
        static let contentDepositAddressWarningColor = UIColor.init(hex: "#636366")
    }

    enum UIStrings {

        static let loadingText = "cybrid.external.wallets.loading.title"
        static let walletsAddButton = "cybrid.external.wallets.wallets.add.button"
        static let walletsEmptyTitle = "cybrid.external.wallets.wallets.empty.title"
        static let walletsTitle = "cybrid.external.wallets.wallets.title"
        static let walletTitle = "cybrid.external.wallets.wallet.title"
        static let walletAssetTitle = "cybrid.external.wallets.wallet.asset.title"
        static let walletNameTitle = "cybrid.external.wallets.wallet.name.title"
        static let walletAddressTitle = "cybrid.external.wallets.wallet.address.title"
        static let walletTagTitle = "cybrid.external.wallets.wallet.tag.title"
        static let walletRecentTransfersTitle = "cybrid.external.wallets.wallet.recentTransfers.title"
        static let walletDeleteButton = "cybrid.external.wallets.wallet.delete.button"
        static let walletStatePending = "cybrid.external.wallets.wallet.state.pending"
        static let walletStateFailed = "cybrid.external.wallets.wallet.state.failed"
        static let walletStateApproved = "cybrid.external.wallets.wallet.state.approved"
        static let walletTransfersEmptyTitle = "cybrid.external.wallets.wallet.transfers.empty.title"
        static let createWalletTitle = "cybrid.external.wallets.createWallet.title"
        static let createWalletAssetTitle = "cybrid.external.wallets.createWallet.asset.title"
        static let createWalletNameTitle = "cybrid.external.wallets.createWallet.name.title"
        static let createWalletNamePlaceholder = "cybrid.external.wallets.createWallet.name.placeholder"
        static let createWalletAddressTitle = "cybrid.external.wallets.createWallet.address.title"
        static let createWalletAddressPlaceholder = "cybrid.external.wallets.createWallet.address.placeholder"
        static let createWalletTagTitle = "cybrid.external.wallets.createWallet.tag.title"
        static let createWalletTagPlaceholder = "cybrid.external.wallets.createWallet.tag.placeholder"
        static let createWalletWarningTitle = "cybrid.deposit.address.content.warning"
        static let createWalletSaveButton = "cybrid.external.wallets.createWallet.save.button"
        static let createWalletAssetError = "cybrid.external.wallets.createWallet.asset.error"
        static let createWalletNameError = "cybrid.external.wallets.createWallet.name.error"
        static let createWalletAddressError = "cybrid.external.wallets.createWallet.address.error"
        static let errorButton = "cybrid.external.wallets.error.button"
    }
}

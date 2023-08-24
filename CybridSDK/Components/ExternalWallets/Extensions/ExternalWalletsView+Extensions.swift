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

        static let contentWarning = "cybrid.deposit.address.content.warning"
    }
}

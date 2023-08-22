//
//  ExternalWalletView.swift
//  CybridSDK
//
//  Created by Erick Sanchez on 14/08/23.
//

import UIKit

public final class ExternalWalletsView: Component {

    public enum State { case LOADING, WALLETS, ERROR }

    internal var localizer: Localizer!
    internal var externalWalletsViewModel: ExternalWalletsViewModel?

    public func initComponent(externalWalletsViewModel: ExternalWalletsViewModel) {

        self.externalWalletsViewModel = externalWalletsViewModel
        self.localizer = CybridLocalizer()
        self.setupView()
        // self.depositAddressViewModel?.fetchDepositAddresses()
    }

    override func setupView() {

        self.backgroundColor = UIColor.clear
        self.manageCurrentStateUI()
    }

    private func manageCurrentStateUI() {

        // -- Await for UI State changes
        self.externalWalletsViewModel?.uiState.bind { state in

            self.removeSubViewsFromContent()
            switch state {

            case .LOADING:
                self.externalWalletsView_Loading()

            case .WALLETS:
                self.externalWalletsView_Loading()

            case .ERROR:
                self.externalWalletsView_Loading()
            }
        }
    }
}

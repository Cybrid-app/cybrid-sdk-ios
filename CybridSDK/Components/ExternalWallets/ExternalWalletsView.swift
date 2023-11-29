//
//  ExternalWalletView.swift
//  CybridSDK
//
//  Created by Erick Sanchez on 14/08/23.
//

import UIKit

public final class ExternalWalletsView: Component {

    public enum State { case LOADING, WALLETS, WALLET, CREATE, ERROR }
    public enum TransfersState { case LOADING, TRANSFERS, EMPTY }

    internal var localizer: Localizer!
    internal var externalWalletViewModel: ExternalWalletViewModel?

    internal var errorLabel = UILabel()

    public func initComponent(externalWalletsViewModel: ExternalWalletViewModel) {

        self.externalWalletViewModel = externalWalletsViewModel
        self.localizer = CybridLocalizer()
        self.setupView()
        self.externalWalletViewModel?.fetchExternalWallets()
    }

    override func setupView() {

        self.backgroundColor = UIColor.white
        self.overrideUserInterfaceStyle = .light
        if self.canRenderComponent() { self.manageCurrentStateUI() }
    }

    private func manageCurrentStateUI() {

        // -- Await for UI State changes
        self.externalWalletViewModel?.uiState.bind { state in

            self.removeSubViewsFromContent()
            switch state {

            case .LOADING:
                self.externalWalletsView_Loading()

            case .WALLETS:
                self.externalWalletsView_Wallets()

            case .WALLET:
                self.externalWalletsView_Wallet()

            case .CREATE:
                self.externalWalletsView_CreateWallet()

            case .ERROR:
                self.externalWalletsView_Error(message: self.externalWalletViewModel?.serverError ?? "")
            }
        }
    }
}

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
    // internal var depositAddressViewModel: DepositAddressViewModel?

    public func initComponent() {

        // self.depositAddressViewModel = depositAddressViewModel
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
        /*self.depositAddressViewModel?.uiState.bind { state in
            
            self.removeSubViewsFromContent()
            switch state {
                
            case .LOADING:
                self.depositAddressViewLoading()
                
            case .CONTENT:
                self.depositAddressViewContent()
                
            case .ERROR:
                self.depositAddressView_Error()
            }
        }*/
    }
}

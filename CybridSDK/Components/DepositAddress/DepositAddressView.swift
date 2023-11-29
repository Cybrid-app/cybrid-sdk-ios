//
//  DepositAddressView.swift
//  CybridSDK
//
//  Created by Erick Sanchez on 10/07/23.
//

import UIKit

public final class DepositAddresView: Component {

    public enum State { case LOADING, CONTENT, ERROR }
    public enum LoadingLabelState { case VERIFYING, GETTING, CREATING }

    internal var localizer: Localizer!
    internal var depositAddressViewModel: DepositAddressViewModel?

    public func initComponent(depositAddressViewModel: DepositAddressViewModel) {

        self.depositAddressViewModel = depositAddressViewModel
        self.localizer = CybridLocalizer()
        self.setupView()
        self.depositAddressViewModel?.fetchDepositAddresses()
    }

    override func setupView() {

        self.backgroundColor = UIColor.clear
        self.overrideUserInterfaceStyle = .light
        if self.canRenderComponent() { self.manageCurrentStateUI() }
    }

    private func manageCurrentStateUI() {

        // -- Await for UI State changes
        self.depositAddressViewModel?.uiState.bind { state in

            self.removeSubViewsFromContent()
            switch state {

            case .LOADING:
                self.depositAddressViewLoading()

            case .CONTENT:
                self.depositAddressViewContent()

            case .ERROR:
                self.depositAddressView_Error()
            }
        }
    }
}

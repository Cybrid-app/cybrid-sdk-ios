//
//  IdentityView.swift
//  CybridSDK
//
//  Created by Erick Sanchez on 07/11/23.
//

import UIKit

public final class IdentityView: Component {

    public enum State { case LOADING, REQUIRED, VERIFIED, ERROR, REVIEWING, FROZEN }

    internal var identityVerificationViewModel: IdentityVerificationViewModel!
    internal var theme: Theme!
    internal var localizer: Localizer!

    public func initComponent(identityVerificationViewModel: IdentityVerificationViewModel) {

        self.identityVerificationViewModel = identityVerificationViewModel
        self.theme = Cybrid.theme
        self.localizer = CybridLocalizer()
        self.setupView()
        self.identityVerificationViewModel.getCustomerStatus()
    }

    override func setupView() {

        self.backgroundColor = UIColor.white
        self.overrideUserInterfaceStyle = .light
        self.manageCurrentStateUI()
    }

    private func manageCurrentStateUI() {

        // -- Await for UI State changes
        self.identityVerificationViewModel?.uiState.bind { state in

            self.removeSubViewsFromContent()
            switch state {
            case .LOADING:
                self.KYCView_Loading()

            case .REQUIRED:
                self.KYCView_Required()

            case .VERIFIED:
                self.KYCView_Verified()

            case .ERROR:
                self.KYCView_Error()

            case .REVIEWING:
                self.KYCView_Reviewing()

            case .FROZEN:
                self.frozenCustomerUI()
            }
        }
    }
}

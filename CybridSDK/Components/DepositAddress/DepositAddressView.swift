//
//  DepositAddressView.swift
//  CybridSDK
//
//  Created by Erick Sanchez on 08/07/23.
//

import UIKit

public final class DepositAddresView: Component {

    public enum State { case LOADING, CONTENT }
    public enum LoadingLabelState { case VERIFYING, CREATING }

    // internal var componentContent = UIView()
    internal var currentState: Observable<State> = .init(.LOADING)
    internal var currentLoadingLabelState: Observable<LoadingLabelState> = .init(.VERIFYING)
    internal var accountBalance: BalanceUIModel?

    public func initComponent(accountBalance: BalanceUIModel) {

        self.accountBalance = accountBalance
        self.setupView()
    }

    override func setupView() {

        self.backgroundColor = UIColor.clear
        self.manageCurrentStateUI()
    }

    private func manageCurrentStateUI() {

        // -- Await for UI State changes
        self.currentState.bind { state in

            self.removeSubViewsFromContent()
            switch state {

            case .LOADING:
                self.depositAddressViewLoading()

            case .CONTENT:
                print("")
                // self.transferView_Accounts()
            }
        }
    }

    internal func removeSubViewsFromContent() {

        for view in self.subviews {
            view.removeFromSuperview()
        }
    }
}

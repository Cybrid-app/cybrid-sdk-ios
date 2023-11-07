//
//  TransferView.swift
//  CybridSDK
//
//  Created by Erick Sanchez on 06/11/23.
//

import UIKit

public final class TransferView: Component {

    public enum State { case LOADING, CONTENT, ERROR, WARNING }
    public enum ModalState { case LOADING, CONFIRM, DETAILS, ERROR }
    public enum BalanceViewState { case LOADING, CONTENT }

    internal var transferViewModel: TransferViewModel!
    internal var theme: Theme!
    internal var localizer: Localizer!

    // MARK: Views
    internal var errorMessageView = UILabel()
    internal var componentContent = UIView()
    internal var currentState: Observable<State> = .init(.LOADING)
    internal var accountsPickerView = UIPickerView()
    internal var amountField: CYBTextField!

    public func initComponent(transferViewModel: TransferViewModel) {

        self.transferViewModel = transferViewModel
        self.theme = Cybrid.theme
        self.localizer = CybridLocalizer()
        self.setupView()
        self.transferViewModel.fetchAccounts()
    }

    override func setupView() {

        self.backgroundColor = UIColor.white
        self.overrideUserInterfaceStyle = .light
        self.manageCurrentStateUI()
    }

    private func manageCurrentStateUI() {

        // -- Await for UI State changes
        self.transferViewModel.uiState.bind { state in

            self.removeSubViewsFromContent()
            switch state {

            case .LOADING:
                self.transferView_Loading()

            case .CONTENT:
                self.transferView_Content()

            case .ERROR:
                self.transferView_Error()

            case .WARNING:
                self.transferView_Warning()
            }
        }
    }
}

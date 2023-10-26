//
//  CryptoTransferView.swift
//  CybridSDK
//
//  Created by Erick Sanchez on 18/09/23.
//

import UIKit

public final class CryptoTransferView: Component {

    public enum State { case LOADING, CONTENT, ERROR }
    public enum ModalState { case LOADING, QUOTE, DONE, ERROR }

    internal var localizer: Localizer!
    internal var cryptoTransferViewModel: CryptoTransferViewModel?

    public func initComponent(cryptoTransferViewModel: CryptoTransferViewModel) {

        self.cryptoTransferViewModel = cryptoTransferViewModel
        self.localizer = CybridLocalizer()
        self.setupView()
        self.cryptoTransferViewModel?.initComponent()
    }

    override func setupView() {

        self.backgroundColor = UIColor.white
        self.overrideUserInterfaceStyle = .light
        self.manageCurrentStateUI()
    }

    private func manageCurrentStateUI() {

        // -- Await for UI State changes
        self.cryptoTransferViewModel?.uiState.bind { state in

            self.removeSubViewsFromContent()
            switch state {

            case .LOADING:
                self.cryptoTransferView_Loading()

            case .CONTENT:
                self.cryptoTransferView_Content()

            case .ERROR:
                self.cryptoTransferView_Error(message: self.cryptoTransferViewModel?.serverError ?? "")
            }
        }
    }
}

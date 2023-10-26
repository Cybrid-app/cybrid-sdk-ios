//
//  CryptoTransferModal.swift
//  CybridSDK
//
//  Created by Erick Sanchez on 11/10/23.
//

import UIKit

class CryptoTransferModal: UIModal {

    internal var localizer: Localizer!
    internal var cryptoTransferViewModel: CryptoTransferViewModel

    internal var componentContent = UIView()

    init(cryptoTransferViewModel: CryptoTransferViewModel) {

        self.cryptoTransferViewModel = cryptoTransferViewModel
        super.init(height: UIValues.modalLoadingSize)
        self.localizer = CybridLocalizer()
        self.setupViews()
    }

    @available(iOS, deprecated: 10, message: "You should never use this init method.")
    required init?(coder: NSCoder) {

        assertionFailure("init(coder:) should never be used")
        return nil
    }

    private func setupViews() {

        self.initComponentContent()
        self.manageCurrentStateUI()
    }
}

extension CryptoTransferModal {

    private func initComponentContent() {

        // -- Component Container
        self.containerView.addSubview(self.componentContent)
        self.componentContent.constraint(attribute: .top,
                                         relatedBy: .equal,
                                         toItem: self.containerView,
                                         attribute: .topMargin,
                                         constant: 10)
        self.componentContent.constraint(attribute: .leading,
                                         relatedBy: .equal,
                                         toItem: self.containerView,
                                         attribute: .leading,
                                         constant: 10)
        self.componentContent.constraint(attribute: .trailing,
                                         relatedBy: .equal,
                                         toItem: self.containerView,
                                         attribute: .trailing,
                                         constant: -10)
        self.componentContent.constraint(attribute: .bottom,
                                         relatedBy: .equal,
                                         toItem: self.containerView,
                                         attribute: .bottomMargin,
                                         constant: 10)
    }

    private func manageCurrentStateUI() {

        // -- Await for UI State changes
        self.cryptoTransferViewModel.modalUiState.bind { state in

            self.removeSubViewsFromContent()
            switch state {

            case .LOADING:
                self.modifyHeight(height: UIValues.modalLoadingSize)
                self.createLoadingScreen(
                    content: self.componentContent,
                    text: "Loading")

            case .QUOTE:
                self.modifyHeight(height: UIValues.modalQuoteSize)
                self.cryptoTransferModal_Quote()

            case .DONE:
                self.modifyHeight(height: UIValues.modalCofirmSize)
                self.createDoneScreen(
                    content: self.componentContent,
                    message: "Transfer done")

            case .ERROR:
                self.modifyHeight(height: UIValues.modalLoadingSize)
                self.createErrorScreen(
                    content: self.componentContent,
                    message: self.cryptoTransferViewModel.serverError)
            }
        }
    }

    internal func removeSubViewsFromContent() {

        for view in self.componentContent.subviews {
            view.removeFromSuperview()
        }
    }
}

extension CryptoTransferModal {

    enum UIValues {

        // -- Sizes
        static let modalLoadingSize: CGFloat = 300
        static let modalQuoteSize: CGFloat = 610
        static let modalCofirmSize: CGFloat = 300
    }

    enum Strings {

        static let titleString = "cybird.crypto.transfer.modal.quote.title"
        static let subTitleString = "cybird.crypto.transfer.modal.quote.subTitle"
        static let from = "cybird.crypto.transfer.modal.quote.from"
        static let toTitle = "cybird.crypto.transfer.modal.quote.to"
        static let amount = "cybird.crypto.transfer.modal.quote.amount"
        static let transactionFee = "cybird.crypto.transfer.modal.quote.transactionFee"
        static let networkFee = "cybird.crypto.transfer.modal.quote.networkFee"
        static let confirmButton = "cybird.crypto.transfer.modal.quote.confirm.button"
    }
}

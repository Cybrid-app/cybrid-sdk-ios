//
//  CryptoTransferModal.swift
//  CybridSDK
//
//  Created by Erick Sanchez on 25/09/23.
//

import UIKit

class CryptoTransferModal: UIModal {

    internal var localizer: Localizer!
    internal var cryptoTransferViewModel: CryptoTransferViewModel

    internal var componentContent = UIView()

    init(cryptoTransferViewModel: CryptoTransferViewModel) {

        self.cryptoTransferViewModel = cryptoTransferViewModel
        super.init(height: UIValues.modalSize)
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
                self.cryptoTransferModal_Loading()

            case .QUOTE:
                self.cryptoTransferModal_Quote()

            default:
                print("")
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
        static let modalSize: CGFloat = 411
        static let modalCofirmSize: CGFloat = 300
    }

    enum Strings {

        static let titleString = "cybrid.bank.accounts.detail.title.text"
    }
}

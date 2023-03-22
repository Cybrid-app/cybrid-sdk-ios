//
//  TransferModal.swift
//  CybridSDK
//
//  Created by Erick Sanchez Perez on 20/03/23.
//

import UIKit

class TransferModal: UIModal {
    
    internal var localizer: Localizer!
    internal var transferViewModel: TransferViewModel!
    
    internal var componentContent = UIView()
    
    init(transferViewModel: TransferViewModel) {
        
        self.transferViewModel = transferViewModel
        super.init(height: UIValues.modalHeightSize)

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

extension TransferModal {

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
        self.transferViewModel.modalUIState.bind { state in

            self.removeSubViewsFromContent()
            switch state {
                
            case .LOADING:
                self.transferViewModal_Loading()

            case .CONTENT:
                self.bankAccountDetail_Content()

            case .CONFIRM:
                self.bankAccountsDetail_Confirm()
            }
        }
    }

    internal func removeSubViewsFromContent() {

        for view in self.componentContent.subviews {
            view.removeFromSuperview()
        }
    }
}

extension TransferModal {
    
    internal func transferViewModal_Loading() {

        let title = UILabel()
        title.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.sizeToFit()
        title.font = UIValues.loadingTitleFont
        title.textColor = UIValues.loadingTitleColor
        title.textAlignment = .center
        title.setLocalizedText(key: UIStrings.loadingTitleString, localizer: localizer)

        self.componentContent.addSubview(title)
        title.constraint(attribute: .centerY,
                         relatedBy: .equal,
                         toItem: self.componentContent,
                         attribute: .centerY)
        title.constraint(attribute: .leading,
                         relatedBy: .equal,
                         toItem: self.componentContent,
                         attribute: .leading,
                         constant: UIValues.loadingTitleMargin.left)
        title.constraint(attribute: .trailing,
                         relatedBy: .equal,
                         toItem: self.componentContent,
                         attribute: .trailing,
                         constant: -UIValues.loadingTitleMargin.right)
        title.constraint(attribute: .height,
                         relatedBy: .equal,
                         toItem: nil,
                         attribute: .notAnAttribute,
                         constant: UIValues.loadingTitleHeight)

        // -- Spinner
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.addBelow(toItem: title, height: UIValues.loadingSpinnerHeight, margins: UIValues.loadingSpinnerMargin)
        spinner.color = UIColor.black
        spinner.startAnimating()
    }
}

extension TransferModal {

    enum UIValues {

        // -- Sizes
        static let modalHeightSize: CGFloat = 411
        static let loadingTitleHeight: CGFloat = 20
        static let loadingSpinnerHeight: CGFloat = 30

        // -- Fonts
        static let loadingTitleFont = UIFont.make(ofSize: 17, weight: .bold)
        static let titleFont = UIFont.make(ofSize: 22)

        // -- Colors
        static let loadingTitleColor = UIColor.black
        static let titleColor = UIColor.black

        // -- Margins
        static let loadingTitleMargin = UIEdgeInsets(top: 40, left: 10, bottom: 0, right: 10)
        static let loadingSpinnerMargin = UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
        static let titleMargins = UIEdgeInsets(top: 28, left: 24, bottom: 0, right: 24)
    }

    enum UIStrings {

        static let loadingTitleString = "cybrid.transfer.modal.loading.text"
        static let titleString = "cybrid.bank.accounts.detail.title.text"
    }
}

//
//  DepositAddressView.swift
//  CybridSDK
//
//  Created by Erick Sanchez on 08/07/23.
//

import Foundation
import UIKit

public final class DepositAddresView: UIView {

    public enum State { case LOADING, CONTENT }

    internal var componentContent = UIView()
    internal var currentState: Observable<State> = .init(.LOADING)

   /* public init() {
        
        super.init(frame: .zero)
        self.setupView()
    }*/

    override init(frame: CGRect) {

        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {

        super.init(coder: aDecoder)
        setupView()
    }

    internal func setupView() {

        self.backgroundColor = UIColor.clear
        self.initComponentContent()
        self.manageCurrentStateUI()
    }

    private func initComponentContent() {

        // -- Component Container
        self.addSubview(self.componentContent)
        self.componentContent.constraint(attribute: .top,
                                         relatedBy: .equal,
                                         toItem: self,
                                         attribute: .bottom,
                                         constant: 0)
        self.componentContent.constraint(attribute: .leading,
                                         relatedBy: .equal,
                                         toItem: self,
                                         attribute: .leading,
                                         constant: 10)
        self.componentContent.constraint(attribute: .trailing,
                                         relatedBy: .equal,
                                         toItem: self,
                                         attribute: .trailing,
                                         constant: -10)
        self.componentContent.constraint(attribute: .bottom,
                                         relatedBy: .equal,
                                         toItem: self,
                                         attribute: .bottomMargin,
                                         constant: 10)
    }

    private func manageCurrentStateUI() {

        // -- Await for UI State changes
        self.currentState.bind { state in

            self.removeSubViewsFromContent()
            switch state {

            case .LOADING:
                print("")
                // self.transferView_Loading()

            case .CONTENT:
                print("")
                // self.transferView_Accounts()
            }
        }
    }

    internal func removeSubViewsFromContent() {
        
        for view in self.componentContent.subviews {
            view.removeFromSuperview()
        }
    }
}

extension DepositAddresView {

    internal func depositAddressViewLoading() {

        let title = UILabel()
        title.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.sizeToFit()
        title.font = UIValues.componentTitleFont
        title.textColor = UIValues.componentTitleColor
        title.textAlignment = .center
        //title.setLocalizedText(key: UIStrings.loadingText, localizer: localizer)

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

extension DepositAddresView {

    enum UIValues {

        // -- Sizes
        static let loadingTitleSize: CGFloat = 17
        static let loadingTitleHeight: CGFloat = 20
        static let loadingSpinnerHeight: CGFloat = 30
        static let loadingSpinnerMargin = UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
        static let actionButtonHeight: CGFloat = 50
        static let accountsTitleHeight: CGFloat = 16
        static let accountsBalanceHeight: CGFloat = 32
        static let accountsSegmentHeight: CGFloat = 32
        static let accountsFromToHeight: CGFloat = 16
        static let accountsFromToFieldHeight: CGFloat = 47
        static let accountsAmountFieldHeight: CGFloat = 44

        // -- Colors
        static let componentTitleColor = UIColor.black
        static let componentSubTitleColor = UIColor.init(hex: "#757575")
        static let accountsTitleColor = UIColor.init(hex: "#636366")

        // -- Fonts
        static let compontntContentTitleFont = UIFont.make(ofSize: 25)
        static let compontntSubTitleFont = UIFont.make(ofSize: 13)
        static let componentTitleFont = UIFont.make(ofSize: 17, weight: .bold)
        static let accountsTitleFont = UIFont.make(ofSize: 13)
        static let accountsBalanceFont = UIFont.make(ofSize: 23)

        // -- Margins
        static let loadingTitleMargin = UIEdgeInsets(top: 40, left: 10, bottom: 0, right: 10)
        static let actionButtonMargin = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: -10)
        static let accountsTitleMargin = UIEdgeInsets(top: 10, left: 16, bottom: 0, right: 16)
        static let accountsBalanceMargin = UIEdgeInsets(top: 3, left: 16, bottom: 0, right: 16)
        static let accountsSegmentMargin = UIEdgeInsets(top: 25, left: 16, bottom: 0, right: 16)
        static let accountsFromToMargin = UIEdgeInsets(top: 45, left: 16, bottom: 0, right: 16)
        static let accountsFromToFieldMargin = UIEdgeInsets(top: 18, left: 16, bottom: 0, right: 16)
        static let accountsAmountMargin = UIEdgeInsets(top: 30, left: 16, bottom: 0, right: 16)
        static let accountsAmountFieldMargin = UIEdgeInsets(top: 16, left: 16, bottom: 0, right: 16)
        static let accountsActionButtonMargin = UIEdgeInsets(top: 40, left: 16, bottom: 0, right: 16)
    }

    enum UIStrings {

        static let loadingText = "cybrid.transfer.loading.text"
        static let errorText = "cybrid.transfer.error.text"
        static let warningText = "cybrid.transfer.warning.text"
        static let errorButton = "cybrid.transfer.error.button"
        static let accountsTitleText = "cybrid.transfer.account.title.text"
        static let accountsDepositText = "cybrid.transfer.account.deposit.text"
        static let accountsWithdrawText = "cybrid.transfer.account.withdraw.text"
        static let accountsFromText = "cybrid.transfer.account.from.text"
        static let accountsToText = "cybrid.transfer.account.to.text"
        static let accountsAmountText = "cybrid.transfer.account.amount.text"
        static let accountsActionButtonText = "cybrid.transfer.action.button.text"
    }
}

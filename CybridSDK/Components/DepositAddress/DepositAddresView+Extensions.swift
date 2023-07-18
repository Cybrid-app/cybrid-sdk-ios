//
//  DepositAddresView+Extensions.swift
//  CybridSDK
//
//  Created by Erick Sanchez on 14/07/23.
//

import UIKit

extension DepositAddresView {

    internal func depositAddressViewLoading() {

        let assetContainer = UIView()
        self.addSubview(assetContainer)
        assetContainer.centerHorizontal(parent: self)
        assetContainer.constraint(attribute: .top,
                                  relatedBy: .equal,
                                  toItem: self,
                                  attribute: .topMargin,
                                  constant: UIValues.loadingAssetContainerTopMargin)
        assetContainer.setConstraintsSize(size: UIValues.loadingAssetContainerSize)

        // -- Icon
        let assetIcon = URLImageView(url: nil)
        assetIcon.setURL(self.accountBalance?.accountAssetURL ?? "")
        assetContainer.addSubview(assetIcon)
        assetIcon.centerHorizontal(parent: assetContainer)
        assetIcon.constraint(attribute: .top,
                             relatedBy: .equal,
                             toItem: assetContainer,
                             attribute: .top,
                             constant: 0)
        assetIcon.setConstraintsSize(size: UIValues.loadingAssetIconSize)

        // -- Name
        let assetName = UILabel()
        assetName.font = UIValues.loadingAssetNameFont
        assetName.textColor = UIValues.loadingAssetNameColor
        assetName.textAlignment = .center
        assetName.text = self.accountBalance?.asset?.name ?? ""
        assetContainer.addSubview(assetName)
        assetName.constraint(attribute: .top,
                             relatedBy: .equal,
                             toItem: assetIcon,
                             attribute: .bottom,
                             constant: UIValues.loadingAssetNameTopMargin)
        assetName.constraint(attribute: .leading,
                             relatedBy: .equal,
                             toItem: assetContainer,
                             attribute: .leading,
                             constant: 0)
        assetName.constraint(attribute: .trailing,
                             relatedBy: .equal,
                             toItem: assetContainer,
                             attribute: .trailing,
                             constant: 0)
        assetName.constraint(attribute: .height,
                             relatedBy: .equal,
                             toItem: nil,
                             attribute: .notAnAttribute,
                             constant: UIValues.loadingAssetNameSize.height)

        // -- Loading Label Container
        let loadingLabelContainer = UIView()
        self.addSubview(loadingLabelContainer)
        loadingLabelContainer.centerVertical(parent: self)
        loadingLabelContainer.constraint(attribute: .leading,
                             relatedBy: .equal,
                             toItem: assetContainer,
                             attribute: .leading,
                             constant: 0)
        loadingLabelContainer.constraint(attribute: .trailing,
                             relatedBy: .equal,
                             toItem: assetContainer,
                             attribute: .trailing,
                             constant: 0)
        loadingLabelContainer.constraint(attribute: .height,
                             relatedBy: .equal,
                             toItem: nil,
                             attribute: .notAnAttribute,
                             constant: UIValues.loadingLoadingLabelContainer.height)

        // -- Label
        let loadingLabel = UILabel()
        loadingLabel.font = UIValues.loadingAssetNameFont
        loadingLabel.textColor = UIValues.loadingAssetNameColor
        loadingLabel.textAlignment = .center
        loadingLabel.text = "Hello world"//self.accountBalance?.asset?.name ?? ""
        loadingLabelContainer.addSubview(loadingLabel)
        loadingLabel.constraint(attribute: .top,
                                relatedBy: .equal,
                                toItem: loadingLabelContainer,
                                attribute: .top,
                                constant: 0)
        loadingLabel.constraint(attribute: .leading,
                                relatedBy: .equal,
                                toItem: loadingLabelContainer,
                                attribute: .leading,
                                constant: 0)
        loadingLabel.constraint(attribute: .trailing,
                                relatedBy: .equal,
                                toItem: loadingLabelContainer,
                                attribute: .trailing,
                                constant: 0)
        loadingLabel.constraint(attribute: .height,
                                relatedBy: .equal,
                                toItem: nil,
                                attribute: .notAnAttribute,
                                constant: UIValues.loadingLabelSize.height)

        // -- Spinner
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.color = UIColor.init(hex: "#007AFF")
        spinner.startAnimating()
        loadingLabelContainer.addSubview(spinner)
        spinner.constraint(attribute: .top,
                           relatedBy: .equal,
                           toItem: loadingLabel,
                           attribute: .bottom,
                           constant: UIValues.loadingSpinnerTopMargin)
        spinner.centerHorizontal(parent: loadingLabelContainer)
        spinner.setConstraintsSize(size: UIValues.loadingSpinnerSize)
        spinner.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
    }
}

extension DepositAddresView {

    enum UIValues {

        // -- Size
        static let loadingAssetContainerSize = CGSize(width: 350, height: 110)
        static let loadingAssetIconSize = CGSize(width: 64, height: 64)
        static let loadingAssetNameSize = CGSize(width: 0, height: 23)
        static let loadingLoadingLabelContainer = CGSize(width: 0, height: 80)
        static let loadingLabelSize = CGSize(width: 0, height: 28)
        static let loadingSpinnerSize = CGSize(width: 43, height: 43)

        // -- Margin
        static let loadingAssetContainerTopMargin: CGFloat = 45
        static let loadingAssetNameTopMargin: CGFloat = 12
        static let loadingSpinnerTopMargin: CGFloat = 15

        // -- Font
        static let loadingAssetNameFont = UIFont.make(ofSize: 24)

        // -- Color
        static let loadingAssetNameColor = UIColor.init(hex: "#3A3A3C")
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

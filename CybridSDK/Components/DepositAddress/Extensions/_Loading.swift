//
//  _Loading.swift
//  CybridSDK
//
//  Created by Erick Sanchez on 27/09/23.
//

import UIKit

extension DepositAddresView {

    internal func depositAddressViewLoading() {

        // -- Loading Label Container
        let loadingLabelContainer = UIView()
        self.addSubview(loadingLabelContainer)
        loadingLabelContainer.centerVertical(parent: self)
        loadingLabelContainer.centerHorizontal(parent: self)
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

        self.depositAddressViewModel?.loadingLabelUiState.bind { [self] state in
            switch state {
            case .VERIFYING:
                loadingLabel.setLocalizedText(key: UIStrings.loadingLabelVerifying, localizer: localizer)
            case .GETTING:
                loadingLabel.setLocalizedText(key: UIStrings.loadingLabelGetting, localizer: localizer)
            case .CREATING:
                loadingLabel.setLocalizedText(key: UIStrings.loadingLabelCreating, localizer: localizer)
            }
        }

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

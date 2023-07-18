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
        let assetIconURL = self.depositAddressViewModel?.accountBalance.accountAssetURL ?? ""
        let assetIcon = URLImageView(url: nil)
        assetIcon.setURL(assetIconURL)
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
        assetName.text = self.depositAddressViewModel?.accountBalance.asset?.name ?? ""
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

    internal func depositAddressViewContent() {

        // -- Icon
        let assetIconURL = self.depositAddressViewModel?.accountBalance.accountAssetURL ?? ""
        let assetIcon = URLImageView(url: nil)
        assetIcon.setURL(assetIconURL)
        self.addSubview(assetIcon)
        assetIcon.centerHorizontal(parent: self)
        assetIcon.constraint(attribute: .top,
                             relatedBy: .equal,
                             toItem: self,
                             attribute: .topMargin,
                             constant: UIValues.loadingAssetContainerTopMargin)
        assetIcon.setConstraintsSize(size: UIValues.loadingAssetIconSize)

        // -- Name
        let assetName = UILabel()
        assetName.font = UIValues.loadingAssetNameFont
        assetName.textColor = UIValues.loadingAssetNameColor
        assetName.textAlignment = .center
        assetName.text = self.depositAddressViewModel?.accountBalance.asset?.name ?? ""
        self.addSubview(assetName)
        assetName.constraint(attribute: .top,
                             relatedBy: .equal,
                             toItem: assetIcon,
                             attribute: .bottom,
                             constant: UIValues.loadingAssetNameTopMargin)
        assetName.constraint(attribute: .leading,
                             relatedBy: .equal,
                             toItem: self,
                             attribute: .leading,
                             constant: 0)
        assetName.constraint(attribute: .trailing,
                             relatedBy: .equal,
                             toItem: self,
                             attribute: .trailing,
                             constant: 0)
        assetName.constraint(attribute: .height,
                             relatedBy: .equal,
                             toItem: nil,
                             attribute: .notAnAttribute,
                             constant: UIValues.loadingAssetNameSize.height)

        // -- QR Code
        let qrCodeImageView = UIImageView()
        let qrCodeImage = generateQRCode(from: self.depositAddressViewModel?.currentDepositAddress?.address ?? "")
        self.addSubview(qrCodeImageView)
        qrCodeImageView.below(to: assetName, top: UIValues.contentQRCodeImageTopMargin)
        qrCodeImageView.centerHorizontal(parent: self)
        qrCodeImageView.setConstraintsSize(size: UIValues.contentQRCodeImageSize)
        if let qrCodeImage {
            qrCodeImageView.image = qrCodeImage
        }

        // -- Deposit Address Title Container
        let depositAddressTitleContainer = UIView()
        self.addSubview(depositAddressTitleContainer)
        depositAddressTitleContainer.below(to: qrCodeImageView, top: UIValues.contentDepositAddressContainerTopMargin)
        depositAddressTitleContainer.centerHorizontal(parent: self)
        depositAddressTitleContainer.setConstraintsSize(size: UIValues.contentDepositAddressContainerSize)

        // -- Title
        let depositAddressTitle = self.depositAddressViewContentTitle(key: UIStrings.contentDepositAddressTitle)
        depositAddressTitleContainer.addSubview(depositAddressTitle)
        depositAddressTitle.constraint(attribute: .leading,
                                       relatedBy: .equal,
                                       toItem: depositAddressTitleContainer,
                                       attribute: .leading,
                                       constant: 0)
        depositAddressTitle.constraint(attribute: .top,
                                       relatedBy: .equal,
                                       toItem: depositAddressTitleContainer,
                                       attribute: .top,
                                       constant: 0)
        depositAddressTitle.constraint(attribute: .bottom,
                                       relatedBy: .equal,
                                       toItem: depositAddressTitleContainer,
                                       attribute: .bottom,
                                       constant: 0)
        depositAddressTitle.constraint(attribute: .width,
                                       relatedBy: .equal,
                                       toItem: nil,
                                       attribute: .notAnAttribute,
                                       constant: UIValues.contentDepositAddressTitleWidth)

        // -- Title Icon
        let depositAddressTitleIcon = UIImageView(image: UIImage(
            named: "ic_copy", in: Bundle(for: Self.self), with: nil))
        depositAddressTitleContainer.addSubview(depositAddressTitleIcon)
        depositAddressTitleIcon.centerVertical(parent: depositAddressTitleContainer)
        depositAddressTitleIcon.constraint(attribute: .trailing,
                                           relatedBy: .equal,
                                           toItem: depositAddressTitleContainer,
                                           attribute: .trailing,
                                           constant: 0)
        depositAddressTitleIcon.setConstraintsSize(size: UIValues.contentDepositAddressIconSize)
        depositAddressTitleIcon.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(copyDepositAddressToClipboard(_:)))
        depositAddressTitleIcon.addGestureRecognizer(gesture)

        // -- Address Label/Value
        let depositAddressValue = self.depositAddressViewContentSubTitle(text: self.depositAddressViewModel?.currentDepositAddress?.address ?? "")
        depositAddressValue.addBelow(toItem: depositAddressTitleContainer,
                                     height: UIValues.contentDepositAddressValueHeight,
                                     margins: UIValues.contentDepositAddressValueMargins)

        // -- Tag Title
        let tagTitle = self.depositAddressViewContentTitle(key: UIStrings.contentDepositAddressTagTitle)
        tagTitle.addBelow(toItem: depositAddressValue,
                          height: UIValues.contentDepositAddressTagTitleHeight,
                          margins: UIValues.contentDepositAddressTagTitleMargins)

        // -- Tag Value
        var tagValueString = self.depositAddressViewModel?.currentDepositAddress?.tag ?? "--"
        if tagValueString.isEmpty { tagValueString = "--" }
        let tagValue = self.depositAddressViewContentSubTitle(text: tagValueString)
        tagValue.addBelow(toItem: tagTitle,
                          height: UIValues.contentDepositAddressTagValueHeight,
                          margins: UIValues.contentDepositAddressTagValueMargins)

        // -- Warning
        let warning = self.depositAddressViewWarningLabel()
        warning.addBelowToBottom(topItem: tagValue, bottomItem: self, margins: UIValues.contentDepositAddressWarningMargins)
    }

    internal func depositAddressViewContentTitle(key: String) -> UILabel {

        let title = UILabel()
        title.font = UIValues.contentDepositAddressTitleFont
        title.textColor = UIValues.contentDepositAddressColor
        title.textAlignment = .center
        title.setLocalizedText(key: key, localizer: localizer)
        return title
    }

    internal func depositAddressViewContentSubTitle(text: String) -> UILabel {

        let title = UILabel()
        title.font = UIValues.contentDepositAddressSubTitleFont
        title.textColor = UIColor.black
        title.textAlignment = .center
        title.text = text
        return title
    }

    internal func depositAddressViewWarningLabel() -> UILabel {

        let title = UILabel()
        title.font = UIValues.contentDepositAddressWarningFont
        title.textColor = UIValues.contentDepositAddressWarningColor
        title.textAlignment = .center
        title.numberOfLines = 0
        title.setLocalizedText(key: UIStrings.contentWarning, localizer: localizer)
        return title
    }

    internal func depositAddressView_Error() {

        // -- Error Container
        let errorContainer = UIView()
        self.addSubview(errorContainer)
        errorContainer.centerVertical(parent: self)
        errorContainer.constraint(attribute: .leading,
                                  relatedBy: .equal,
                                  toItem: self,
                                  attribute: .leading,
                                  constant: UIValues.errorContainerHorizontalMargin)
        errorContainer.constraint(attribute: .trailing,
                                  relatedBy: .equal,
                                  toItem: self,
                                  attribute: .trailing,
                                  constant: -UIValues.errorContainerHorizontalMargin)
        errorContainer.constraint(attribute: .height,
                                  relatedBy: .equal,
                                  toItem: nil,
                                  attribute: .notAnAttribute,
                                  constant: UIValues.errorContainerHeight)

        // -- Icon
        let icon = UIImageView(image: UIImage(
            named: "kyc_error",
            in: Bundle(for: Self.self),
            with: nil))
        errorContainer.addSubview(icon)
        icon.centerHorizontal(parent: errorContainer)
        icon.constraint(attribute: .top,
                        relatedBy: .equal,
                        toItem: errorContainer,
                        attribute: .top,
                        constant: UIValues.errorContainerIconTopMargin)
        icon.setConstraintsSize(size: UIValues.errorContainerIconSize)

        // -- Title
        let title = UILabel()
        title.font = UIValues.contentDepositAddressSubTitleFont
        title.textColor = UIColor.black
        title.textAlignment = .center
        title.setLocalizedText(key: UIStrings.error, localizer: localizer)
        errorContainer.addSubview(title)
        title.constraint(attribute: .top,
                         relatedBy: .equal,
                         toItem: icon,
                         attribute: .bottom,
                         constant: UIValues.errorContainerTitleMargins.top)
        title.constraint(attribute: .leading,
                         relatedBy: .equal,
                         toItem: errorContainer,
                         attribute: .leading,
                         constant: UIValues.errorContainerTitleMargins.left)
        title.constraint(attribute: .trailing,
                         relatedBy: .equal,
                         toItem: errorContainer,
                         attribute: .trailing,
                         constant: -UIValues.errorContainerTitleMargins.right)
        title.constraint(attribute: .height,
                         relatedBy: .equal,
                         toItem: nil,
                         attribute: .notAnAttribute,
                         constant: 50)

        // -- Button
        let done = CYBButton(title: localizer.localize(with: UIStrings.errorButton), action: {

            if let parentViewController = self.superview?.next as? UIViewController {
                if parentViewController.navigationController != nil {
                    parentViewController.navigationController?.popViewController(animated: true)
                } else {
                    parentViewController.dismiss(animated: true)
                }
            }
        })
        self.addSubview(done)
        done.constraint(attribute: .leading,
                        relatedBy: .equal,
                        toItem: self,
                        attribute: .leading,
                        constant: UIValues.errorContainerButtonMargins.left)
        done.constraint(attribute: .trailing,
                        relatedBy: .equal,
                        toItem: self,
                        attribute: .trailing,
                        constant: -UIValues.errorContainerButtonMargins.right)
        done.constraint(attribute: .bottom,
                        relatedBy: .equal,
                        toItem: self,
                        attribute: .bottom,
                        constant: -UIValues.errorContainerButtonMargins.bottom)
        done.constraint(attribute: .height,
                        relatedBy: .equal,
                        toItem: nil,
                        attribute: .notAnAttribute,
                        constant: 48)
        done.isHidden = true
    }

    @objc func copyDepositAddressToClipboard(_ sender: UITapGestureRecognizer) {
        copyToClipboard(self.depositAddressViewModel?.currentDepositAddress?.address ?? "")
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
        static let contentQRCodeImageSize = CGSize(width: 250, height: 250)
        static let contentDepositAddressContainerSize = CGSize(width: 135, height: 18)
        static let contentDepositAddressTitleWidth: CGFloat = 113
        static let contentDepositAddressIconSize = CGSize(width: 16, height: 16)
        static let contentDepositAddressValueHeight: CGFloat = 17
        static let contentDepositAddressTagTitleHeight: CGFloat = 17
        static let contentDepositAddressTagValueHeight: CGFloat = 17
        static let errorContainerHeight: CGFloat = 100
        static let errorContainerIconSize = CGSize(width: 40, height: 40)

        // -- Margin
        static let loadingAssetContainerTopMargin: CGFloat = 30
        static let loadingAssetNameTopMargin: CGFloat = 12
        static let loadingSpinnerTopMargin: CGFloat = 15
        static let contentQRCodeImageTopMargin: CGFloat = 20
        static let contentDepositAddressContainerTopMargin: CGFloat = 10
        static let contentDepositAddressValueMargins = UIEdgeInsets(top: 18, left: 20, bottom: 0, right: 20)
        static let contentDepositAddressTagTitleMargins = UIEdgeInsets(top: 18, left: 20, bottom: 0, right: 20)
        static let contentDepositAddressTagValueMargins = UIEdgeInsets(top: 18, left: 20, bottom: 0, right: 20)
        static let contentDepositAddressWarningMargins = UIEdgeInsets(top: 18, left: 10, bottom: 0, right: 10)
        static let errorContainerHorizontalMargin: CGFloat = 20
        static let errorContainerIconTopMargin: CGFloat = 15
        static let errorContainerTitleMargins = UIEdgeInsets(top: 5, left: 10, bottom: 0, right: 10)
        static let errorContainerButtonMargins = UIEdgeInsets(top: 15, left: 15, bottom: 0, right: 15)

        // -- Font
        static let loadingAssetNameFont = UIFont.make(ofSize: 24)
        static let contentDepositAddressTitleFont = UIFont.make(ofSize: 14)
        static let contentDepositAddressSubTitleFont = UIFont.make(ofSize: 13)
        static let contentDepositAddressWarningFont = UIFont.make(ofSize: 16)

        // -- Color
        static let loadingAssetNameColor = UIColor.init(hex: "#3A3A3C")
        static let contentDepositAddressColor = UIColor.init(hex: "#818181")
        static let contentDepositAddressWarningColor = UIColor.init(hex: "#636366")
    }

    enum UIStrings {

        static let loadingLabelVerifying = "cybrid.deposit.address.loading.label.verifying"
        static let loadingLabelGetting = "cybrid.deposit.address.loading.label.getting"
        static let loadingLabelCreating = "cybrid.deposit.address.loading.label.creating"
        static let contentDepositAddressTitle = "cybrid.deposit.address.content.deposit.address.title"
        static let contentDepositAddressTagTitle = "cybrid.deposit.address.content.deposit.tag.title"
        static let contentWarning = "cybrid.deposit.address.content.warning"
        static let error = "cybrid.deposit.address.error"
        static let errorButton = "cybrid.deposit.address.error.button"
    }
}

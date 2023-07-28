//
//  DepositAddresView+Extensions.swift
//  CybridSDK
//
//  Created by Erick Sanchez on 14/07/23.
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

    internal func depositAddressViewContent() {

        // -- Setup screen and scroll
        let contentView = self.setupScrollView()

        // -- Title
        let assetCode = depositAddressViewModel?.accountBalance.asset?.code ?? ""
        let depositTitle = UILabel()
        depositTitle.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        depositTitle.textAlignment = .left
        depositTitle.textColor = UIColor.black
        depositTitle.text = "Deposit \(assetCode)"
        contentView.addSubview(depositTitle)
        depositTitle.constraintSafeTop(contentView, margin: 0)
        depositTitle.constraintLeft(contentView, margin: 10)
        depositTitle.constraintRight(contentView, margin: 10)
        depositTitle.constraintHeight(25)

        // -- QR Code
        let accountAddress = depositAddressViewModel?.currentDepositAddress?.address ?? ""
        let qrCodeImageView = UIImageView()
        let qrCodeImage = depositAddressViewModel?.generateQRCode(
            assetCode: assetCode,
            address: accountAddress,
            amount: depositAddressViewModel?.currentAmountForDeposit ?? "",
            message: depositAddressViewModel?.currentMessageForDeposit ?? "")
        contentView.addSubview(qrCodeImageView)
        qrCodeImageView.below(depositTitle, top: 35)
        qrCodeImageView.centerHorizontal(parent: contentView)
        qrCodeImageView.constraintHeight(180)
        qrCodeImageView.constraintWidth(180)
        if let qrCodeImage {
            qrCodeImageView.image = qrCodeImage
        }

        // -- QR Code Warning
        let qrCodeWarning = UILabel()
        qrCodeWarning.font = UIFont.systemFont(ofSize: 12, weight: .light)
        qrCodeWarning.textAlignment = .center
        qrCodeWarning.textColor = UIColor(hex: "#818181")
        qrCodeWarning.text = "Send only \(assetCode) to this deposit address."
        contentView.addSubview(qrCodeWarning)
        qrCodeWarning.below(qrCodeImageView, top: 5)
        qrCodeWarning.centerHorizontal(parent: contentView)
        qrCodeWarning.constraintHeight(14)

        // -- Network Title
        let networkTitle = UILabel()
        networkTitle.font = UIFont.systemFont(ofSize: 13, weight: .light)
        networkTitle.textAlignment = .left
        networkTitle.textColor = UIColor(hex: "#818181")
        networkTitle.text = "Network"
        contentView.addSubview(networkTitle)
        networkTitle.below(qrCodeWarning, top: 35)
        networkTitle.constraintLeft(contentView, margin: 10)
        networkTitle.constraintRight(contentView, margin: 10)
        networkTitle.constraintHeight(14)

        // -- Network value
        let assetName = depositAddressViewModel?.accountBalance.asset?.name ?? ""
        let networkValue = UILabel()
        networkValue.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        networkValue.textAlignment = .left
        networkValue.textColor = UIColor.black
        networkValue.text = assetName.capitalized
        contentView.addSubview(networkValue)
        networkValue.below(networkTitle, top: 5)
        networkValue.constraintLeft(contentView, margin: 10)
        networkValue.constraintRight(contentView, margin: 10)
        networkValue.constraintHeight(16)

        // -- Deposit Address - Copy Icon
        let depositAddressCopyIcon = UIImageView(image: UIImage(
            named: "ic_copy", in: Bundle(for: Self.self), with: nil))
        contentView.addSubview(depositAddressCopyIcon)
        depositAddressCopyIcon.constraintTop(networkValue, margin: 62)
        depositAddressCopyIcon.constraintRight(contentView, margin: 12)
        depositAddressCopyIcon.constraintWidth(20)
        depositAddressCopyIcon.constraintHeight(20)
        depositAddressCopyIcon.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(copyDepositAddressToClipboard(_:)))
        depositAddressCopyIcon.addGestureRecognizer(gesture)

        // -- Address Title
        let addressTitle = UILabel()
        addressTitle.font = UIFont.systemFont(ofSize: 13, weight: .light)
        addressTitle.textAlignment = .left
        addressTitle.textColor = UIColor(hex: "#818181")
        addressTitle.text = "\(assetCode) Deposit Address"
        contentView.addSubview(addressTitle)
        addressTitle.below(networkValue, top: 30)
        addressTitle.constraintLeft(contentView, margin: 10)
        addressTitle.constraint(attribute: .trailing,
                                relatedBy: .equal,
                                toItem: depositAddressCopyIcon,
                                attribute: .leading,
                                constant: -10)
        addressTitle.constraintHeight(14)

        // -- Network value
        let addressValue = UILabel()
        addressValue.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        addressValue.textAlignment = .left
        addressValue.textColor = UIColor.black
        addressValue.numberOfLines = 0
        addressValue.isUserInteractionEnabled = true
        addressValue.text = accountAddress
        contentView.addSubview(addressValue)
        addressValue.below(networkValue, top: 50)
        addressValue.constraintLeft(contentView, margin: 10)
        addressValue.constraint(attribute: .trailing,
                                relatedBy: .equal,
                                toItem: depositAddressCopyIcon,
                                attribute: .leading,
                                constant: -10)
        addressValue.constraintHeight(38)

        // -- Tag Title
        let accountTag = depositAddressViewModel?.currentDepositAddress?.tag ?? ""
        let tagTitle = UILabel()
        tagTitle.font = UIFont.systemFont(ofSize: 13, weight: .light)
        tagTitle.textAlignment = .left
        tagTitle.textColor = UIColor(hex: "#818181")
        tagTitle.text = "Tag"
        contentView.addSubview(tagTitle)
        tagTitle.below(addressValue, top: 30)
        tagTitle.constraintLeft(contentView, margin: 10)
        tagTitle.constraintRight(contentView, margin: 10)
        tagTitle.constraintHeight(14)

        // -- Tag Value
        let tagValue = UILabel()
        tagValue.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        tagValue.textAlignment = .left
        tagValue.textColor = UIColor.black
        tagValue.numberOfLines = 0
        tagValue.text = accountTag
        contentView.addSubview(tagValue)
        tagValue.below(tagTitle, top: 5)
        tagValue.constraintLeft(contentView, margin: 10)
        tagValue.constraintRight(contentView, margin: 10)
        tagValue.constraintHeight(38)

        if accountTag.isEmpty {
            self.hideView(tagTitle)
            self.hideView(tagValue)
            tagTitle.below(addressValue, top: 0)
            tagValue.below(tagTitle, top: 5)
        }

        // -- Amount Title
        let amountTitle = UILabel()
        amountTitle.font = UIFont.systemFont(ofSize: 13, weight: .light)
        amountTitle.textAlignment = .left
        amountTitle.textColor = UIColor(hex: "#818181")
        amountTitle.text = "Amount"
        contentView.addSubview(amountTitle)
        amountTitle.below(tagValue, top: 30)
        amountTitle.constraintLeft(contentView, margin: 10)
        amountTitle.constraintRight(contentView, margin: 10)
        amountTitle.constraintHeight(14)

        // -- Amount Value
        let amountString = depositAddressViewModel?.currentAmountForDeposit ?? ""
        let amountValue = UILabel()
        amountValue.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        amountValue.textAlignment = .left
        amountValue.textColor = UIColor.black
        amountValue.numberOfLines = 0
        amountValue.text = "\(amountString) \(assetCode)"
        contentView.addSubview(amountValue)
        amountValue.below(amountTitle, top: 5)
        amountValue.constraintLeft(contentView, margin: 10)
        amountValue.constraintRight(contentView, margin: 10)
        amountValue.constraintHeight(38)

        if amountString.isEmpty {
            self.hideView(amountTitle)
            self.hideView(amountValue)
            amountTitle.below(tagValue, top: 0)
            amountValue.below(amountTitle, top: 0)
        }

        // -- Message Title
        let messageTitle = UILabel()
        messageTitle.font = UIFont.systemFont(ofSize: 13, weight: .light)
        messageTitle.textAlignment = .left
        messageTitle.textColor = UIColor(hex: "#818181")
        messageTitle.text = "Message"
        contentView.addSubview(messageTitle)
        messageTitle.below(amountValue, top: 30)
        messageTitle.constraintLeft(contentView, margin: 10)
        messageTitle.constraintRight(contentView, margin: 10)
        messageTitle.constraintHeight(14)

        // -- Amount Value
        let messageString = depositAddressViewModel?.currentMessageForDeposit ?? ""
        let messageValue = UILabel()
        messageValue.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        messageValue.textAlignment = .left
        messageValue.textColor = UIColor.black
        messageValue.numberOfLines = 0
        messageValue.text = messageString
        contentView.addSubview(messageValue)
        messageValue.below(messageTitle, top: 5)
        messageValue.constraintLeft(contentView, margin: 10)
        messageValue.constraintRight(contentView, margin: 10)
        messageValue.constraintHeight(38)

        if messageString.isEmpty {
            self.hideView(messageTitle)
            self.hideView(messageValue)
            messageTitle.below(amountValue, top: 0)
            messageValue.below(messageTitle, top: 0)
        }

        // -- Warning
        let warningContainer = UIView()
        warningContainer.backgroundColor = UIColor(hex: "#efb90b").withAlphaComponent(0.20)
        warningContainer.layer.cornerRadius = 6
        contentView.addSubview(warningContainer)
        warningContainer.below(messageValue, top: 15)
        warningContainer.constraintLeft(contentView, margin: 10)
        warningContainer.constraintRight(contentView, margin: 10)
        warningContainer.constraintHeight(80)

        // -- Warning Icon
        let warningIcon = UIImageView(image: UIImage(
            named: "ic_warning", in: Bundle(for: Self.self), with: nil))
        warningContainer.addSubview(warningIcon)
        warningIcon.constraintTop(warningContainer, margin: 10)
        warningIcon.constraintLeft(warningContainer, margin: 8)
        warningIcon.constraintWidth(14)
        warningIcon.constraintHeight(14)

        // -- Warning Label
        let warningLabel = UILabel()
        warningLabel.font = UIFont.systemFont(ofSize: 14)
        warningLabel.textAlignment = .justified
        warningLabel.textColor = UIColor(hex: "#f1b90a")
        warningLabel.numberOfLines = 0
        warningLabel.text = localizer.localize(with: UIStrings.contentWarning)
        warningContainer.addSubview(warningLabel)
        warningLabel.constraintTop(warningContainer, margin: 7)
        warningLabel.constraint(attribute: .leading,
                                relatedBy: .equal,
                                toItem: warningIcon,
                                attribute: .trailing,
                                constant: 5)
        warningLabel.constraintRight(warningContainer, margin: 15)
        warningLabel.constraintHeight(68)

        // -- Payment Button
        if depositAddressViewModel!.currentAmountForDeposit.isEmpty {
            let createPaymentButton = CYBButton(
                title: "Generate payment code",
                action: { [self] in
                    let paymentDetailsModal = PaymentModal(accountBalance: (self.depositAddressViewModel?.accountBalance)!) { amount, messsage in
                        self.depositAddressViewModel?.setValuesForDeposit(amount: amount, message: messsage)
                    }
                    paymentDetailsModal.present()
                }
            )
            contentView.addSubview(createPaymentButton)
            createPaymentButton.constraintLeft(contentView, margin: 10)
            createPaymentButton.constraintRight(contentView, margin: 10)
            createPaymentButton.constraintBottom(contentView, margin: 10)
            createPaymentButton.constraintHeight(45)
        }
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

    // -- MARK: Helpers
    internal func setupScrollView() -> UIView {

        let contentView = UIView()
        let scrollView = UIScrollView()
        self.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])

        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        let heightConstraint = contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        heightConstraint.priority = UILayoutPriority(250)
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            heightConstraint
        ])
        return contentView
    }

    internal func hideView(_ view: UIView) {

        view.removeConstraint(attribute: .height)
        view.constraintHeight(0)
        view.removeConstraint(attribute: .top)
    }

    @objc func copyDepositAddressToClipboard(_ sender: UITapGestureRecognizer) {
        
        let address = self.depositAddressViewModel?.currentDepositAddress?.address ?? ""
        UIPasteboard.general.string = address
    }
}

extension DepositAddresView {

    enum UIValues {

        // -- Size
        static let loadingLoadingLabelContainer = CGSize(width: 0, height: 80)
        static let loadingLabelSize = CGSize(width: 0, height: 28)
        static let loadingSpinnerSize = CGSize(width: 43, height: 43)
        static let errorContainerHeight: CGFloat = 100
        static let errorContainerIconSize = CGSize(width: 40, height: 40)

        // -- Margin
        static let loadingAssetContainerTopMargin: CGFloat = 30
        static let loadingAssetNameTopMargin: CGFloat = 12
        static let loadingSpinnerTopMargin: CGFloat = 15
        static let errorContainerHorizontalMargin: CGFloat = 20
        static let errorContainerIconTopMargin: CGFloat = 15
        static let errorContainerTitleMargins = UIEdgeInsets(top: 5, left: 10, bottom: 0, right: 10)
        static let errorContainerButtonMargins = UIEdgeInsets(top: 15, left: 15, bottom: 0, right: 15)

        // -- Font
        static let loadingAssetNameFont = UIFont.make(ofSize: 24)
        static let contentDepositAddressSubTitleFont = UIFont.make(ofSize: 13)

        // -- Color
        static let loadingAssetNameColor = UIColor.init(hex: "#3A3A3C")
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

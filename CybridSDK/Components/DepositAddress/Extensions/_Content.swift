//
//  _Content.swift
//  CybridSDK
//
//  Created by Erick Sanchez on 27/09/23.
//

import UIKit

extension DepositAddresView {

    internal func depositAddressViewContent() {

        // -- Setup screen and scroll
        let contentView = self.setupScrollView()

        // -- Title
        let depositTitleString = localizer.localize(with: UIStrings.contentDepositAddressTitle)
        let assetCode = depositAddressViewModel?.accountBalance.asset?.code ?? ""
        let depositTitle = UILabel()
        depositTitle.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        depositTitle.textAlignment = .left
        depositTitle.textColor = UIColor.black
        depositTitle.text = depositTitleString + assetCode
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
        let qrWarningLocalized1 = localizer.localize(with: UIStrings.contentDepositAddressQRWarningOne)
        let qrWarningLocalized2 = localizer.localize(with: UIStrings.contentDepositAddressQRWarningTwo)
        let qrWarningString = "\(qrWarningLocalized1)\(assetCode)\(qrWarningLocalized2)"
        let qrCodeWarning = UILabel()
        qrCodeWarning.font = UIFont.systemFont(ofSize: 12, weight: .light)
        qrCodeWarning.textAlignment = .center
        qrCodeWarning.textColor = UIColor(hex: "#818181")
        qrCodeWarning.text = qrWarningString
        contentView.addSubview(qrCodeWarning)
        qrCodeWarning.below(qrCodeImageView, top: 5)
        qrCodeWarning.centerHorizontal(parent: contentView)
        qrCodeWarning.constraintHeight(14)

        // -- Network Title
        let networkTitle = UILabel()
        networkTitle.font = UIFont.systemFont(ofSize: 13, weight: .light)
        networkTitle.textAlignment = .left
        networkTitle.textColor = UIColor(hex: "#818181")
        networkTitle.text = localizer.localize(with: UIStrings.contentDepositAddressNetworkTitle)
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
        let addressString = localizer.localize(with: UIStrings.contentDepositAddressAddressTitle)
        let addressTitle = UILabel()
        addressTitle.font = UIFont.systemFont(ofSize: 13, weight: .light)
        addressTitle.textAlignment = .left
        addressTitle.textColor = UIColor(hex: "#818181")
        addressTitle.text = "\(assetCode) \(addressString)"
        contentView.addSubview(addressTitle)
        addressTitle.below(networkValue, top: 30)
        addressTitle.constraintLeft(contentView, margin: 10)
        addressTitle.constraint(attribute: .trailing,
                                relatedBy: .equal,
                                toItem: depositAddressCopyIcon,
                                attribute: .leading,
                                constant: -10)
        addressTitle.constraintHeight(14)

        // -- Address value
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
        tagTitle.text = localizer.localize(with: UIStrings.contentDepositAddressTagTitle)
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
            tagValue.below(tagTitle, top: 0)
        }

        // -- Amount Title
        let amountTitle = UILabel()
        amountTitle.font = UIFont.systemFont(ofSize: 13, weight: .light)
        amountTitle.textAlignment = .left
        amountTitle.textColor = UIColor(hex: "#818181")
        amountTitle.text = localizer.localize(with: UIStrings.contentDepositAddressAmountTitle)
        contentView.addSubview(amountTitle)
        amountTitle.below(tagValue, top: 25)
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
        amountValue.below(amountTitle, top: 3.5)
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
        messageTitle.text = localizer.localize(with: UIStrings.contentDepositAddressMessageTitle)
        contentView.addSubview(messageTitle)
        messageTitle.below(amountValue, top: 20)
        messageTitle.constraintLeft(contentView, margin: 10)
        messageTitle.constraintRight(contentView, margin: 10)
        messageTitle.constraintHeight(14)

        // -- Message Value
        let messageString = depositAddressViewModel?.currentMessageForDeposit ?? ""
        let messageValue = UILabel()
        messageValue.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        messageValue.textAlignment = .left
        messageValue.textColor = UIColor.black
        messageValue.numberOfLines = 0
        messageValue.text = messageString
        contentView.addSubview(messageValue)
        messageValue.below(messageTitle, top: 3.5)
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
        warningContainer.isHidden = true

        // -- Payment Button
        if depositAddressViewModel!.currentAmountForDeposit.isEmpty {
            let createPaymentButton = CYBButton(
                title: localizer.localize(with: UIStrings.contentDepositAddressButton),
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
}

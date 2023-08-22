//
//  ExternalWalletsView+Extensions.swift
//  CybridSDK
//
//  Created by Erick Sanchez on 18/08/23.
//

import UIKit
import CybridApiBankSwift

extension ExternalWalletsView {

    internal func externalWalletsView_Loading() {
        self.createLoaderScreen()
    }

    internal func externalWalletsView_Wallets() {

        // -- Add button
        let addButton = CYBButton(title: "Add wallet") {
            self.externalWalletsViewModel?.uiState.value = .CREATE
        }
        self.addSubview(addButton)
        addButton.constraintLeft(self, margin: 10)
        addButton.constraintRight(self, margin: 10)
        addButton.constraintBottom(self, margin: 0)
        addButton.constraintHeight(48)

        // -- Check for empty state with empty externalWallets
        if self.externalWalletsViewModel!.externalWallets.isEmpty {
            self.createEmptySection()
        } else {

            // -- Title
            let title = self.label(
                font: UIFont.make(ofSize: 23, weight: .bold),
                color: UIColor.init(hex: "#3A3A3C"),
                text: "My wallets",
                lineHeight: 1.15,
                aligment: .left)
            self.addSubview(title)
            title.constraintTop(self, margin: 10)
            title.constraintLeft(self, margin: 10)
            title.constraintRight(self, margin: 10)

            // -- Wallets table
            let walletTable = UITableView()
            walletTable.delegate = self
            walletTable.dataSource = self
            walletTable.register(ExternalWalletCell.self, forCellReuseIdentifier: ExternalWalletCell.reuseIdentifier)
            self.addSubview(walletTable)
            walletTable.below(title, top: 30)
            walletTable.constraintLeft(self, margin: 0)
            walletTable.constraintRight(self, margin: 0)
            walletTable.above(addButton, bottom: 15)
        }
    }

    internal func externalWalletsView_Wallet() {

        // --
        let wallet = self.externalWalletsViewModel?.currentWallet
        let asset = try? Cybrid.findAsset(code: (self.externalWalletsViewModel?.currentWallet?.asset)!)
        let assetName = asset?.name ?? ""
        let assetCode = asset?.code ?? ""

        // -- Status chip
        let statusChip = UILabel()
        statusChip.layer.masksToBounds = true
        statusChip.layer.cornerRadius = CGFloat(10)
        statusChip.setContentHuggingPriority(.required, for: .horizontal)
        statusChip.translatesAutoresizingMaskIntoConstraints = false
        statusChip.font = UIFont.make(ofSize: 12)
        statusChip.textAlignment = .center
        self.addSubview(statusChip)
        statusChip.constraintTop(self, margin: 15)
        statusChip.constraintRight(self, margin: 10)
        statusChip.setConstraintsSize(size: CGSize(width: 80, height: 24))
        switch wallet?.state ?? .storing {
        case .storing, .pending:

            statusChip.isHidden = false
            statusChip.textColor = UIColor.black
            statusChip.backgroundColor = UIColor(hex: "#FCDA66")
            statusChip.text = "Pending"
            // self.statusChip.setLocalizedText(key: UIString.transferPending, localizer: localizer)

        case .failed:

            statusChip.isHidden = false
            statusChip.textColor = UIColor.white
            statusChip.backgroundColor = UIColor(hex: "#D45736")
            statusChip.text = "Failed"
            // self.statusChip.setLocalizedText(key: UIString.transferFailed, localizer: localizer)

        case .completed:
            statusChip.isHidden = false
            statusChip.textColor = UIColor.white
            statusChip.backgroundColor = UIColor(hex: "#4dae51")
            statusChip.text = "Approved"

        default:
            statusChip.isHidden = true
        }

        // -- Title
        let title = self.label(
            font: UIFont.make(ofSize: 23, weight: .bold),
            color: UIColor.init(hex: "#3A3A3C"),
            text: "My \(assetCode) wallet",
            lineHeight: 1.15,
            aligment: .left)
        self.addSubview(title)
        title.constraintTop(self, margin: 10)
        title.constraintLeft(self, margin: 10)
        title.constraintRight(self, margin: 10)

        // -- Asset
        let assetTitle = self.label(
            font: UIFont.make(ofSize: 14, weight: .light),
            color: UIColor(hex: "#818181"),
            text: "Asset",
            lineHeight: 1.05,
            aligment: .left)
        self.addSubview(assetTitle)
        assetTitle.below(title, top: 35)
        assetTitle.constraintLeft(self, margin: 10)
        assetTitle.constraintRight(self, margin: 10)

        // -- Asset Container
        let assetContainer = UIView()
        assetContainer.backgroundColor = UIColor(hex: "#F5F5F5")
        assetContainer.layer.cornerRadius = 8
        self.addSubview(assetContainer)
        assetContainer.below(assetTitle, top: 10)
        assetContainer.constraintLeft(self, margin: 0)
        assetContainer.constraintRight(self, margin: 0)
        assetContainer.constraintHeight(52)

        // -- Asset Icon
        let iconUrl = Cybrid.getAssetURL(with: assetCode)
        let icon = URLImageView(urlString: iconUrl)
        assetContainer.addSubview(icon!)
        icon?.constraintLeft(assetContainer, margin: 10)
        icon?.centerVertical(parent: assetContainer)
        icon?.setConstraintsSize(size: CGSize(width: 28, height: 28))

        // -- Asset Name
        let paragraphStyle = getParagraphStyle(1.15)
        paragraphStyle.alignment = .left
        let assetNameLabel = UILabel()
        assetNameLabel.font = UIFont.make(ofSize: 17)
        assetNameLabel.textColor = UIColor.black
        assetNameLabel.setParagraphText(assetName.capitalized, paragraphStyle)
        assetContainer.addSubview(assetNameLabel)
        assetNameLabel.leftAside(icon!, margin: 15)
        assetNameLabel.constraintRight(assetContainer, margin: 10)
        assetNameLabel.centerVertical(parent: assetContainer)

        // -- Name title
        let nameTitle = self.label(
            font: UIFont.make(ofSize: 14, weight: .regular),
            color: UIColor(hex: "#818181"),
            text: "Name",
            lineHeight: 1.05,
            aligment: .left)
        self.addSubview(nameTitle)
        nameTitle.below(assetContainer, top: 25)
        nameTitle.constraintLeft(self, margin: 10)
        nameTitle.rightAside(statusChip, margin: 10)

        // -- Name value
        let walletName = self.label(
            font: UIFont.make(ofSize: 17),
            color: UIColor.black,
            text: wallet?.name ?? "",
            lineHeight: 1.15,
            aligment: .left)
        self.addSubview(walletName)
        walletName.below(nameTitle, top: 10)
        walletName.constraintLeft(self, margin: 10)
        walletName.constraintRight(self, margin: 10)

        // -- Address title
        let addressTitle = self.label(
            font: UIFont.make(ofSize: 14, weight: .regular),
            color: UIColor(hex: "#818181"),
            text: "Address",
            lineHeight: 1.05,
            aligment: .left)
        self.addSubview(addressTitle)
        addressTitle.below(walletName, top: 25)
        addressTitle.constraintLeft(self, margin: 10)
        addressTitle.constraintRight(self, margin: 10)

        // -- Address value
        let addressValue = self.label(
            font: UIFont.make(ofSize: 17),
            color: UIColor.black,
            text: wallet?.address ?? "",
            lineHeight: 1.15,
            aligment: .left)
        addressValue.numberOfLines = 0
        self.addSubview(addressValue)
        addressValue.below(addressTitle, top: 10)
        addressValue.constraintLeft(self, margin: 10)
        addressValue.constraintRight(self, margin: 10)

        // -- Tag title
        let tagTitle = self.label(
            font: UIFont.make(ofSize: 14, weight: .regular),
            color: UIColor(hex: "#818181"),
            text: "Tag",
            lineHeight: 1.05,
            aligment: .left)
        self.addSubview(tagTitle)
        tagTitle.below(addressValue, top: 25)
        tagTitle.constraintLeft(self, margin: 10)
        tagTitle.constraintRight(self, margin: 10)

        // -- Tag value
        let tagValue = self.label(
            font: UIFont.make(ofSize: 17),
            color: UIColor.black,
            text: wallet?.tag ?? "",
            lineHeight: 1.15,
            aligment: .left)
        self.addSubview(tagValue)
        tagValue.below(tagTitle, top: 10)
        tagValue.constraintLeft(self, margin: 10)
        tagValue.constraintRight(self, margin: 10)

        // -- Delete button
        let deleteButton = CYBButton(title: "Delete") {
            self.externalWalletsViewModel?.deleteExternalWallet()
        }
        deleteButton.backgroundColor = UIColor.red
        self.addSubview(deleteButton)
        deleteButton.below(tagValue, top: 30)
        deleteButton.constraintLeft(self, margin: 10)
        deleteButton.constraintRight(self, margin: 10)
        deleteButton.constraintHeight(48)
    }

    internal func externalWalletsView_CreateWallet() {

        // -- Title
        let title = self.label(
            font: UIFont.make(ofSize: 23, weight: .bold),
            color: UIColor.init(hex: "#3A3A3C"),
            text: "Add new wallet",
            lineHeight: 1.15,
            aligment: .left)
        self.addSubview(title)
        title.constraintTop(self, margin: 10)
        title.constraintLeft(self, margin: 10)
        title.constraintRight(self, margin: 10)

        // -- Asset title
        let assetTitle = self.label(
            font: UIFont.make(ofSize: 14, weight: .regular),
            color: UIColor(hex: "#818181"),
            text: "Asset",
            lineHeight: 1.05,
            aligment: .left)
        self.addSubview(assetTitle)
        assetTitle.below(title, top: 35)
        assetTitle.constraintLeft(self, margin: 10)
        assetTitle.constraintRight(self, margin: 10)

        // -- Asset picker
        let assetPicker = AssetPicker(assets: Cybrid.assets)
        self.addSubview(assetPicker)
        assetPicker.below(assetTitle, top: 10)
        assetPicker.constraintLeft(self, margin: 10)
        assetPicker.constraintRight(self, margin: 10)

        // -- Name title
        let nameTitle = self.label(
            font: UIFont.make(ofSize: 14, weight: .regular),
            color: UIColor(hex: "#818181"),
            text: "Name",
            lineHeight: 1.05,
            aligment: .left)
        self.addSubview(nameTitle)
        nameTitle.below(assetPicker, top: 25)
        nameTitle.constraintLeft(self, margin: 10)
        nameTitle.constraintRight(self, margin: 10)

        // -- Name input
        let nameInput = TextField()
        nameInput.backgroundColor = UIColor(hex: "#F5F5F5")
        nameInput.layer.cornerRadius = 8
        nameInput.placeholder = "Enter wallet name"
        self.addSubview(nameInput)
        nameInput.below(nameTitle, top: 10)
        nameInput.constraintLeft(self, margin: 10)
        nameInput.constraintRight(self, margin: 10)
        nameInput.constraintHeight(52)

        // -- Address title
        let addressTitle = self.label(
            font: UIFont.make(ofSize: 14, weight: .regular),
            color: UIColor(hex: "#818181"),
            text: "Address",
            lineHeight: 1.05,
            aligment: .left)
        self.addSubview(addressTitle)
        addressTitle.below(nameInput, top: 25)
        addressTitle.constraintLeft(self, margin: 10)
        addressTitle.constraintRight(self, margin: 10)

        // -- Address icon
        let addressIconContainer = UIView()
        addressIconContainer.setConstraintsSize(size: CGSize(width: 40, height: 50))
        let addressIcon = UIImageView(image: getImage("ic_scan", aClass: Self.self))
        addressIconContainer.addSubview(addressIcon)
        addressIcon.centerVertical(parent: addressIconContainer)
        addressIcon.centerHorizontal(parent: addressIconContainer)
        addressIcon.setConstraintsSize(size: CGSize(width: 20, height: 20))

        // -- Address input
        let addressInput = TextFieldRightIcon()
        addressInput.backgroundColor = UIColor(hex: "#F5F5F5")
        addressInput.layer.cornerRadius = 8
        addressInput.placeholder = "Enter wallet address"
        addressInput.rightViewMode = .always
        addressInput.rightView = addressIconContainer
        self.addSubview(addressInput)
        addressInput.below(addressTitle, top: 10)
        addressInput.constraintLeft(self, margin: 10)
        addressInput.constraintRight(self, margin: 10)
        addressInput.constraintHeight(52)

        // -- Tag title
        let tagTitle = self.label(
            font: UIFont.make(ofSize: 14, weight: .regular),
            color: UIColor(hex: "#818181"),
            text: "Tag",
            lineHeight: 1.05,
            aligment: .left)
        self.addSubview(tagTitle)
        tagTitle.below(addressInput, top: 25)
        tagTitle.constraintLeft(self, margin: 10)
        tagTitle.constraintRight(self, margin: 10)

        // -- Name input
        let tagInput = TextField()
        tagInput.backgroundColor = UIColor(hex: "#F5F5F5")
        tagInput.layer.cornerRadius = 8
        tagInput.placeholder = "Enter tag"
        self.addSubview(tagInput)
        tagInput.below(tagTitle, top: 10)
        tagInput.constraintLeft(self, margin: 10)
        tagInput.constraintRight(self, margin: 10)
        tagInput.constraintHeight(52)

        // -- Warning
        let warningContainer = UIView()
        warningContainer.backgroundColor = UIColor(hex: "#efb90b").withAlphaComponent(0.20)
        warningContainer.layer.cornerRadius = 8
        self.addSubview(warningContainer)
        warningContainer.below(tagInput, top: 25)
        warningContainer.constraintLeft(self, margin: 10)
        warningContainer.constraintRight(self, margin: 10)
        warningContainer.constraintHeight(35)

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
        // warningLabel.textAlignment = .justified
        warningLabel.textColor = UIColor(hex: "#f1b90a")
        warningLabel.numberOfLines = 0
        warningLabel.text = localizer.localize(with: UIStrings.contentWarning)
        warningContainer.addSubview(warningLabel)
        warningLabel.constraintTop(warningContainer, margin: 10)
        warningLabel.constraint(attribute: .leading,
                                relatedBy: .equal,
                                toItem: warningIcon,
                                attribute: .trailing,
                                constant: 5)
        warningLabel.constraintRight(warningContainer, margin: 15)
        // warningLabel.constraintHeight(68)

        // -- Save button
        let saveButton = CYBButton(title: "Save") {

            // -- Sanity check
            let asset = assetPicker.assetSelected?.code ?? ""
            let name = nameInput.text ?? ""
            let address = addressInput.text ?? ""
            let tag = tagInput.text ?? ""
            guard
                let postExternalWalletBankModel = self.getPostExternalWallet(
                    asset: asset,
                    name: name,
                    address: address,
                    tag: tag)
            else {
                return
            }

            // -- Creating the wallet
            self.externalWalletsViewModel?.createExternlaWallet(postExternalWalletBankModel: postExternalWalletBankModel)
        }
        self.addSubview(saveButton)
        saveButton.below(warningContainer, top: 25)
        saveButton.constraintLeft(self, margin: 10)
        saveButton.constraintRight(self, margin: 10)

        // -- Error
        self.errorLabel = self.label(
            font: UIFont.make(ofSize: 14),
            color: UIColor.red,
            text: "",
            lineHeight: 1.05)
        self.addSubview(errorLabel)
        errorLabel.below(saveButton, top: 5)
        errorLabel.constraintLeft(self, margin: 10)
        errorLabel.constraintRight(self, margin: 10)
        errorLabel.isHidden = true
    }

    internal func getPostExternalWallet(asset: String, name: String, address: String, tag: String) -> PostExternalWalletBankModel? {

        if asset.isEmpty {

            errorLabel.text = "Select an asset for the wallet"
            errorLabel.isHidden = false
            return nil
        }

        if name.isEmpty {

            errorLabel.text = "Enter a wallet name"
            errorLabel.isHidden = false
            return nil
        }

        if address.isEmpty {

            errorLabel.text = "Enter a wallet address"
            errorLabel.isHidden = false
            return nil
        }

        // --
        let postExternalWalletBankModel = PostExternalWalletBankModel(
            name: name,
            asset: asset,
            address: address,
            tag: tag
        )
        return postExternalWalletBankModel
    }
}

extension ExternalWalletsView: UITableViewDelegate, UITableViewDataSource {

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.externalWalletsViewModel?.externalWallets.count ?? 0
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let wallet = (self.externalWalletsViewModel?.externalWallets[indexPath.row])!
        guard
            let cell = tableView.dequeueReusableCell(
                withIdentifier: ExternalWalletCell.reuseIdentifier,
                for: indexPath) as? ExternalWalletCell
        else {
            return UITableViewCell()
        }
        cell.setData(wallet: wallet)
        return cell
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let wallet = self.externalWalletsViewModel?.externalWallets[indexPath.row]
        self.externalWalletsViewModel?.currentWallet = wallet
        self.externalWalletsViewModel?.uiState.value = .WALLET
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52
    }
}

extension ExternalWalletsView {

    enum UIValues {

        // -- Size
        static let errorContainerHeight: CGFloat = 100
        static let errorContainerIconSize = CGSize(width: 40, height: 40)

        // -- Margin
        static let errorContainerHorizontalMargin: CGFloat = 20
        static let errorContainerIconTopMargin: CGFloat = 15
        static let errorContainerTitleMargins = UIEdgeInsets(top: 5, left: 10, bottom: 0, right: 10)
        static let errorContainerButtonMargins = UIEdgeInsets(top: 15, left: 15, bottom: 0, right: 15)

        // -- Font
        static let contentDepositAddressSubTitleFont = UIFont.make(ofSize: 13)

        // -- Color
        static let contentDepositAddressWarningColor = UIColor.init(hex: "#636366")
    }

    enum UIStrings {

        static let contentWarning = "cybrid.deposit.address.content.warning"
    }
}

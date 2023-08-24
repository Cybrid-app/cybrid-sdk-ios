//
//  externalWalletsView_CreateWallet.swift
//  CybridSDK
//
//  Created by Erick Sanchez on 22/08/23.
//

import UIKit
import CybridApiBankSwift

extension ExternalWalletsView {

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
            self.externalWalletViewModel?.createExternalWallet(postExternalWalletBankModel: postExternalWalletBankModel)
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

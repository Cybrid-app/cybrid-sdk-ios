//
//  _Wallet.swift
//  CybridSDK
//
//  Created by Erick Sanchez on 22/08/23.
//

import UIKit

extension ExternalWalletsView {

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
}

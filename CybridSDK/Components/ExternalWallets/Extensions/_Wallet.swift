//
//  _Wallet.swift
//  CybridSDK
//
//  Created by Erick Sanchez on 22/08/23.
//

import UIKit
import CybridApiBankSwift

extension ExternalWalletsView {

    internal func externalWalletsView_Wallet() {

        // --
        let wallet = self.externalWalletViewModel?.currentWallet
        let walletState = wallet?.state ?? .storing

        let asset = try? Cybrid.findAsset(code: (self.externalWalletViewModel?.currentWallet?.asset)!)
        let assetName = asset?.name ?? ""
        let assetCode = asset?.code ?? ""

        // -- Fetch transfers
        self.externalWalletViewModel?.fetchTransfers()

        // -- Status chip
        let statusChip = UILabel()
        statusChip.layer.masksToBounds = true
        statusChip.layer.cornerRadius = CGFloat(10)
        statusChip.setContentHuggingPriority(.required, for: .horizontal)
        statusChip.translatesAutoresizingMaskIntoConstraints = false
        statusChip.font = UIFont.make(ofSize: 14)
        statusChip.textAlignment = .center
        self.addSubview(statusChip)
        statusChip.constraintTop(self, margin: 15)
        statusChip.constraintRight(self, margin: 10)
        statusChip.setConstraintsSize(size: CGSize(width: 90, height: 26))
        self.externalWalletsView_Wallet_statusChip(statusChip, wallet: wallet)

        // -- Title
        let titleString = localizer.localize(with: UIStrings.walletTitle)
        let title = self.label(
            font: UIFont.make(ofSize: 23, weight: .bold),
            color: UIColor.init(hex: "#3A3A3C"),
            text: titleString,
            lineHeight: 1.15,
            aligment: .left)
        self.addSubview(title)
        title.constraintTop(self, margin: 10)
        title.constraintLeft(self, margin: 10)
        title.constraintRight(self, margin: 10)

        // -- Asset
        let assetTitleString = localizer.localize(with: UIStrings.walletAssetTitle)
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
        assetContainer.constraintLeft(self, margin: 10)
        assetContainer.constraintRight(self, margin: 10)
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
        let nameTitleString = localizer.localize(with: UIStrings.walletNameTitle)
        let nameTitle = self.label(
            font: UIFont.make(ofSize: 14, weight: .regular),
            color: UIColor(hex: "#818181"),
            text: nameTitleString,
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
        let addressTitleString = localizer.localize(with: UIStrings.walletAddressTitle)
        let addressTitle = self.label(
            font: UIFont.make(ofSize: 14, weight: .regular),
            color: UIColor(hex: "#818181"),
            text: addressTitleString,
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
        let tagTitleString = localizer.localize(with: UIStrings.walletTagTitle)
        let tagTitle = self.label(
            font: UIFont.make(ofSize: 14, weight: .regular),
            color: UIColor(hex: "#818181"),
            text: tagTitleString,
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

        // -- Recent transfers title
        let recentTransfersTitleString = localizer.localize(with: UIStrings.walletRecentTransfersTitle)
        let recentTransfersTitle = self.label(
            font: UIFont.make(ofSize: 14, weight: .regular),
            color: UIColor(hex: "#818181"),
            text: recentTransfersTitleString,
            lineHeight: 1.05,
            aligment: .left)
        self.addSubview(recentTransfersTitle)
        recentTransfersTitle.below(tagValue, top: 25)
        recentTransfersTitle.constraintLeft(self, margin: 10)
        recentTransfersTitle.constraintRight(self, margin: 10)

        // -- Transfers views
        let container = UIView()
        self.addSubview(container)
        let containerHeight = container.constraintHeight(50)
        container.below(recentTransfersTitle, top: 20)
        container.constraintLeft(self, margin: 10)
        container.constraintRight(self, margin: 10)
        self.externalWalletsView_Wallet_transfers(container: container, height: containerHeight)

        // -- Delete button
        let deleteButtonString = localizer.localize(with: UIStrings.walletDeleteButton)
        let deleteButton = CYBButton(title: deleteButtonString) {
            self.externalWalletViewModel?.deleteExternalWallet()
        }
        deleteButton.backgroundColor = UIColor.red
        self.addSubview(deleteButton)
        deleteButton.below(container, top: 30)
        deleteButton.constraintLeft(self, margin: 10)
        deleteButton.constraintRight(self, margin: 10)
        deleteButton.constraintHeight(48)
        deleteButton.isHidden = true

        // -- Check status for show delete button
        if walletState == .completed || walletState == .failed {
            deleteButton.isHidden = false
        }
    }

    internal func externalWalletsView_Wallet_statusChip(_ statusChip: UILabel, wallet: ExternalWalletBankModel?) {

        switch wallet?.state ?? .storing {
        case .storing, .pending:

            statusChip.isHidden = false
            statusChip.textColor = UIColor.black
            statusChip.backgroundColor = UIColor(hex: "#FCDA66")
            statusChip.setLocalizedText(key: UIStrings.walletStatePending, localizer: localizer)

        case .failed:

            statusChip.isHidden = false
            statusChip.textColor = UIColor.white
            statusChip.backgroundColor = UIColor(hex: "#D45736")
            statusChip.setLocalizedText(key: UIStrings.walletStateFailed, localizer: localizer)

        case .completed:
            statusChip.isHidden = false
            statusChip.textColor = UIColor.white
            statusChip.backgroundColor = UIColor(hex: "#4dae51")
            statusChip.setLocalizedText(key: UIStrings.walletStateApproved, localizer: localizer)

        default:
            statusChip.isHidden = true
        }
    }

    internal func externalWalletsView_Wallet_transfers(container: UIView, height: NSLayoutConstraint) {

        self.externalWalletViewModel?.transfersUiState.bind { [self] state in

            // -- Remove prev views from container
            container.removeChilds()

            // -- Bind transfers state
            switch state {
            case .LOADING:

                // -- Contianer
                height.constant = 50

                // -- Spinner
                let spinner = UIActivityIndicatorView(style: .medium)
                spinner.color = UIColor.init(hex: "#007AFF")
                spinner.startAnimating()
                container.addSubview(spinner)
                spinner.centerVertical(parent: container)
                spinner.centerHorizontal(parent: container)
                spinner.setConstraintsSize(size: CGSize(width: 43, height: 43))
                spinner.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)

            case .TRANSFERS:

                // -- Contianer
                height.constant = 110

                // -- Transfers table
                let transfersTable = UITableView()
                transfersTable.delegate = self
                transfersTable.dataSource = self
                transfersTable.accessibilityIdentifier = "wallets_transfersTable"
                container.addSubview(transfersTable)
                height.constant = transfersTable.contentSize.height
                transfersTable.constraintTop(container, margin: 0)
                transfersTable.constraintLeft(container, margin: 10)
                transfersTable.constraintRight(container, margin: 10)
                transfersTable.constraintHeight(transfersTable.contentSize.height)

            case .EMPTY:

                // -- Container
                height.constant = 130

                // -- Empty view
                let emptyViewString = self.localizer.localize(with: UIStrings.walletTransfersEmptyTitle)
                let emptyView = self.createEmptySection(text: emptyViewString, font: UIFont.make(ofSize: 16))
                container.addSubview(emptyView)
                emptyView.centerVertical(parent: container)
                emptyView.constraintLeft(container, margin: 0)
                emptyView.constraintRight(container, margin: 0)
            }
        }
    }
}

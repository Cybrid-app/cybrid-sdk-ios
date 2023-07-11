//
//  AccountTransfersViewController.swift
//  CybridSDK
//
//  Created by Erick Sanchez Perez on 03/04/23.
//

import Foundation
import UIKit
import CybridApiBankSwift

public final class AccountTransfersViewController: UIViewController {

    private var transfersViewModel: AccountTransfersViewModel!

    private var theme: Theme!
    private var localizer: Localizer!
    private var balance: BalanceUIModel!

    // -- Views
    var balanceAssetIcon: URLImageView!
    var balanceAssetName: UILabel!
    var assetTitleContainer: UIStackView!
    var balanceValueView: UILabel!
    var subtitle: UILabel!
    var pendingTitle: UILabel!
    let transfersTable = UITableView()

    internal init(balance: BalanceUIModel) {

        super.init(nibName: nil, bundle: nil)
        self.balance = balance

        self.transfersViewModel = AccountTransfersViewModel(
            cellProvider: self,
            dataProvider: CybridSession.current,
            logger: Cybrid.logger)

        self.theme = Cybrid.theme
        self.localizer = CybridLocalizer()

        self.transfersViewModel.getTransfers(accountGuid: balance.account.guid!)
        self.setupView()
    }

    @available(iOS, deprecated: 10, message: "You should never use this init method.")
    required init?(coder: NSCoder) {

        assertionFailure("init(coder:) should never be used")
        return nil
    }

    func setupView() {

        view.backgroundColor = .white
        self.createAssetTitle()
        self.createBalanceTitles()
        self.createTransfersTable()
    }
}

extension AccountTransfersViewController {

    private func createAssetTitle() {

        // -- Icon
        balanceAssetIcon = URLImageView(urlString: balance.accountAssetURL)
        balanceAssetIcon?.setConstraintsSize(size: UIValues.balanceAssetIconSize)

        // -- Name
        balanceAssetName = UILabel()
        balanceAssetName.font = UIValues.balanceAssetNameFont
        balanceAssetName.textColor = UIValues.balanceAssetNameColor
        balanceAssetName.text = balance.asset?.name ?? ""

        // -- AssetTitle Container
        assetTitleContainer = UIStackView(arrangedSubviews: [balanceAssetIcon, balanceAssetName])
        assetTitleContainer.axis = .horizontal
        assetTitleContainer.distribution = .fill
        assetTitleContainer.alignment = .fill
        assetTitleContainer.spacing = UIValues.assetTitleStackSpacing

        self.view.addSubview(assetTitleContainer)
        self.centerHorizontalView(container: assetTitleContainer)
    }

    private func createBalanceTitles() {

        // -- Balance Value
        balanceValueView = UILabel()
        balanceValueView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        balanceValueView.translatesAutoresizingMaskIntoConstraints = false
        balanceValueView.sizeToFit()
        balanceValueView.font = UIValues.balanceValueViewFont
        balanceValueView.textColor = UIValues.balanceValueViewColor
        balanceValueView.textAlignment = .center
        balanceValueView.setAttributedText(mainText: balance.accountBalanceInFiatFormatted,
                                           mainTextFont: UIValues.balanceValueViewFont,
                                           mainTextColor: UIValues.balanceValueViewColor,
                                           attributedText: balance.asset?.code ?? "",
                                           attributedTextFont: UIValues.balanceValueCodeViewFont,
                                           attributedTextColor: UIValues.balanceValueCodeViewColor)
        balanceValueView.addBelow(
            toItem: assetTitleContainer,
            height: UIValues.balanceValueViewSize,
            margins: UIValues.balanceValueViewMargin)

        // -- Balance Fiat Value
        subtitle = UILabel()
        subtitle.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        subtitle.translatesAutoresizingMaskIntoConstraints = false
        subtitle.sizeToFit()
        subtitle.font = UIValues.balanceFiatValueFont
        subtitle.textColor = UIValues.balanceFiatValueColor
        subtitle.textAlignment = .center
        subtitle.setLocalizedText(key: UIStrings.transferAvailableSub, localizer: localizer)
        subtitle.addBelow(
            toItem: balanceValueView,
            height: UIValues.balanceFiatValueViewSize,
            margins: UIValues.balanceFiatValueViewMargins)

        // -- Pending Fiat Value
        let pendingString = CybridLocalizer().localize(with: UIStrings.pendingString)
        let pendingValue = "\(balance.accountPendingBalanceFormatted)\(pendingString)"
        pendingTitle = UILabel()
        pendingTitle.font = UIValues.balancePendingFont
        pendingTitle.textColor = UIValues.balancePendingColor
        pendingTitle.textAlignment = .center
        pendingTitle.text = pendingValue
        pendingTitle.addBelow(
            toItem: subtitle,
            height: UIValues.balanceFiatPendingViewSize,
            margins: UIValues.balanceFiatPendingMargins)
    }

    private func createTransfersTable() {

        self.transfersTable.delegate = self.transfersViewModel
        self.transfersTable.dataSource = self.transfersViewModel
        self.transfersTable.register(AccountTransfersCell.self, forCellReuseIdentifier: AccountTransfersCell.reuseIdentifier)
        self.transfersTable.rowHeight = UIValues.tradesTableCellHeight
        self.transfersTable.estimatedRowHeight = UIValues.tradesTableCellHeight
        self.transfersTable.translatesAutoresizingMaskIntoConstraints = false
        self.transfersTable.addBelowToBottom(
            topItem: self.pendingTitle,
            bottomItem: self.view,
            margins: UIValues.tradesTableMargins)

        // -- Live Data
        transfersViewModel.tranfers.bind { _ in
            self.transfersTable.reloadData()
        }
    }

    private func centerHorizontalView(container: UIStackView) {

        container.translatesAutoresizingMaskIntoConstraints = false
        container.constraint(attribute: .top,
                             relatedBy: .equal,
                             toItem: self.view,
                             attribute: .topMargin,
                             constant: UIValues.assetTitleViewMargin.top)
        container.constraint(attribute: .centerX,
                             relatedBy: .equal,
                             toItem: self.view,
                             attribute: .centerX)
        container.constraint(attribute: .height,
                             relatedBy: .equal,
                             toItem: nil,
                             attribute: .notAnAttribute,
                             constant: UIValues.assetTitleViewHeight)
    }
}

extension AccountTransfersViewController: AccountTransfersViewProvider {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, withData model: TransferBankModel) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: AccountTransfersCell.reuseIdentifier, for: indexPath) as? AccountTransfersCell else {
            return UITableViewCell()
        }
        cell.setData(transfer: model)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath, with transfer: TransferBankModel) {

        let modal = AccountTransferModal(
            transfer: transfer,
            fiatAsset: Cybrid.fiat,
            assetURL: balance.accountAssetURL,
            onConfirm: nil)
        modal.present()
    }
}

extension AccountTransfersViewController {

    enum UIValues {

        // -- Sizes
        static let assetTitleViewMargin = UIEdgeInsets(top: 36, left: 0, bottom: 0, right: 0)
        static let assetTitleViewHeight: CGFloat = 25
        static let assetTitleStackSpacing: CGFloat = 10
        static let balanceAssetIconSize = CGSize(width: assetTitleViewHeight, height: assetTitleViewHeight)
        static let balanceAssetNameMargin = UIEdgeInsets(top: 4, left: 10, bottom: 0, right: 0)
        static let balanceValueViewMargin = UIEdgeInsets(top: 19, left: 10, bottom: 0, right: 10)
        static let balanceValueViewSize: CGFloat = 35
        static let balanceFiatValueViewMargins = UIEdgeInsets(top: 2, left: 10, bottom: 0, right: 10)
        static let balanceFiatValueViewSize: CGFloat = 23
        static let balanceFiatPendingViewSize: CGFloat = 19
        static let balanceFiatPendingMargins = UIEdgeInsets(top: 5, left: 15, bottom: 0, right: 15)
        static let tradesTableCellHeight: CGFloat = 62
        static let tradesTableMargins = UIEdgeInsets(top: 15, left: 15, bottom: 0, right: 15)

        // -- Fonts
        static let balanceAssetNameFont = UIFont.make(ofSize: 16.5, weight: .medium)
        static let balanceValueViewFont = UIFont.make(ofSize: 28)
        static let balanceValueCodeViewFont = UIFont.make(ofSize: 18)
        static let balanceFiatValueFont = UIFont.make(ofSize: 17)
        static let balanceFiatValueCodeFont = UIFont.make(ofSize: 17)
        static let balancePendingFont = UIFont.make(ofSize: 15)

        // -- Colors
        static let balanceAssetNameColor = UIColor(hex: "#3A3A3C")
        static let balanceValueViewColor = UIColor.black
        static let balanceValueCodeViewColor = UIColor(hex: "#8E8E93")
        static let balanceFiatValueColor = UIColor(hex: "#636366")
        static let balanceFiatValueCodeColor = UIColor(hex: "#757575")
        static let balancePendingColor = UIColor(hex: "#007AFF")
    }

    enum UIStrings {

        static let transferAvailableSub = "cybrid.accounts.transfers.subtitle.available"
        static let pendingString = "cybrid.accounts.item.fiat.pending"
    }
}

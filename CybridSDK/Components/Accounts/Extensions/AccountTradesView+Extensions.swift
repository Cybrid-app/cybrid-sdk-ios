//
//  AccountTradesView+Extensions.swift
//  CybridSDK
//
//  Created by Erick Sanchez on 06/11/23.
//

import UIKit

extension AccountTradesView {

    internal func createAssetTitle() {

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

        // -- Adds
        self.addSubview(assetTitleContainer)
        self.centerHorizontalView(container: assetTitleContainer)
    }

    internal func createBalanceTitles() {

        // -- Balancr Value
        balanceValueView = UILabel()
        balanceValueView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        balanceValueView.translatesAutoresizingMaskIntoConstraints = false
        balanceValueView.sizeToFit()
        balanceValueView.font = UIValues.balanceValueViewFont
        balanceValueView.textColor = UIValues.balanceValueViewColor
        balanceValueView.textAlignment = .center
        balanceValueView.setAttributedText(mainText: balance.accountBalanceFormatted,
                                           mainTextFont: UIValues.balanceValueViewFont,
                                           mainTextColor: UIValues.balanceValueViewColor,
                                           attributedText: balance.asset?.code ?? "",
                                           attributedTextFont: UIValues.balanceValueCodeViewFont,
                                           attributedTextColor: UIValues.balanceValueCodeViewColor)
        balanceValueView.addBelow(
            toItem: assetTitleContainer,
            height: UIValues.balanceValueViewSize,
            margins: UIValues.balanceValueViewMargin)
        balanceValueView.accessibilityIdentifier = "AccountsComponent_Trades_Balance_Title"

        // -- Balance Fiat Value
        balanceFiatValueView = UILabel()
        balanceFiatValueView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        balanceFiatValueView.translatesAutoresizingMaskIntoConstraints = false
        balanceFiatValueView.sizeToFit()
        balanceFiatValueView.font = UIValues.balanceFiatValueFont
        balanceFiatValueView.textColor = UIValues.balanceFiatValueColor
        balanceFiatValueView.textAlignment = .center
        balanceFiatValueView.setAttributedText(mainText: balance.accountBalanceInFiatFormatted,
                                               mainTextFont: UIValues.balanceFiatValueFont,
                                               mainTextColor: UIValues.balanceFiatValueColor,
                                               attributedText: balance.counterAsset?.code ?? "",
                                               attributedTextFont: UIValues.balanceFiatValueCodeFont,
                                               attributedTextColor: UIValues.balanceFiatValueCodeColor)
        balanceFiatValueView.addBelow(
            toItem: balanceValueView,
            height: UIValues.balanceFiatValueViewSize,
            margins: UIValues.balanceFiatValueViewMargins)
    }

    internal func createDepositAddressButton() {

        let canCreate = Cybrid.canCreateDepositAddressFor(self.balance.account.asset ?? "")
        let buttonHeight: CGFloat = !canCreate ? 0 : 50
        self.depositAddressButton = CYBButton(title: localizer.localize(with: UIStrings.getDepositAddress)) {

            let depositAddressViewController = DepositAddresViewController(accountBalance: self.balance)
            if self.parentController?.navigationController != nil {
                self.parentController?.navigationController?.pushViewController(depositAddressViewController, animated: true)
            } else {
                self.parentController?.present(depositAddressViewController, animated: true)
            }
        }
        self.addSubview(self.depositAddressButton)
        self.depositAddressButton.constraintLeft(self, margin: 20)
        self.depositAddressButton.constraintRight(self, margin: 20)
        self.depositAddressButton.constraintBottom(self, margin: 25)
        self.depositAddressButton.constraintHeight(buttonHeight)
    }

    internal func createTradesTable() {

        self.tradesTable.delegate = self
        self.tradesTable.dataSource = self
        self.tradesTable.register(AccountTradesCell.self, forCellReuseIdentifier: AccountTradesCell.reuseIdentifier)
        self.tradesTable.rowHeight = UIValues.tradesTableCellHeight
        self.tradesTable.estimatedRowHeight = UIValues.tradesTableCellHeight
        self.tradesTable.translatesAutoresizingMaskIntoConstraints = false

        self.tradesTable.addInTheMiddle(
            topItem: self.balanceFiatValueView,
            bottomItem: self.depositAddressButton,
            margins: UIValues.tradesTableMargins)

        // -- Live Data
        self.accountTradesViewModel.trades.bind { _ in
            self.tradesTable.reloadData()
        }
    }

    private func centerHorizontalView(container: UIStackView) {

        container.translatesAutoresizingMaskIntoConstraints = false
        container.constraint(attribute: .top,
                             relatedBy: .equal,
                             toItem: self,
                             attribute: .topMargin,
                             constant: UIValues.assetTitleViewMargin.top)
        container.constraint(attribute: .centerX,
                             relatedBy: .equal,
                             toItem: self,
                             attribute: .centerX)
        container.constraint(attribute: .height,
                             relatedBy: .equal,
                             toItem: nil,
                             attribute: .notAnAttribute,
                             constant: UIValues.assetTitleViewHeight)
    }
}

extension AccountTradesView: UITableViewDelegate, UITableViewDataSource {

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.accountTradesViewModel.trades.value.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let model = self.accountTradesViewModel.trades.value[indexPath.row]
        guard
            let cell = tableView.dequeueReusableCell(
                withIdentifier: AccountTradesCell.reuseIdentifier,
                for: indexPath) as? AccountTradesCell
        else {
            return UITableViewCell()
        }
        cell.setData(trade: model)
        return cell
    }

    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return AccountTradesHeaderCell()
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let trade = self.accountTradesViewModel.trades.value[indexPath.row]
        let modal = AccountTradeDetailModal(
            trade: trade,
            assetURL: balance.accountAssetURL,
            theme: theme,
            localizer: localizer,
            onConfirm: nil)
        modal.present()
    }
}

extension AccountTradesView {

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
        static let tradesTableCellHeight: CGFloat = 62
        static let tradesTableMargins = UIEdgeInsets(top: 5, left: 15, bottom: 10, right: 15)

        // -- Fonts
        static let balanceAssetNameFont = UIFont.make(ofSize: 16.5, weight: .medium)
        static let balanceValueViewFont = UIFont.make(ofSize: 28)
        static let balanceValueCodeViewFont = UIFont.make(ofSize: 18)
        static let balanceFiatValueFont = UIFont.make(ofSize: 17)
        static let balanceFiatValueCodeFont = UIFont.make(ofSize: 17)

        // -- Colors
        static let balanceAssetNameColor = UIColor(hex: "#3A3A3C")
        static let balanceValueViewColor = UIColor.black
        static let balanceValueCodeViewColor = UIColor(hex: "#8E8E93")
        static let balanceFiatValueColor = UIColor(hex: "#636366")
        static let balanceFiatValueCodeColor = UIColor(hex: "#757575")
    }
    
    enum UIStrings {

        static let getDepositAddress = "cybrid.deposit.address.in.accounts.trades.create.button"
    }
}

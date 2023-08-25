//
//  AccountTradesViewcontroller.swift
//  CybridSDK
//
//  Created by Erick Sanchez Perez on 25/08/22.
//

import Foundation
import UIKit

public final class AccountTradesViewController: UIViewController {

    private var balance: BalanceUIModel!
    private var accountsViewModel: AccountsViewModel!
    private var tradesViewModel: AccountTradesViewModel!

    private var theme: Theme!
    private var localizer: Localizer!

    // -- Views
    var balanceAssetIcon: URLImageView!
    var balanceAssetName: UILabel!
    var assetTitleContainer: UIStackView!
    var balanceValueView: UILabel!
    var balanceFiatValueView: UILabel!
    let tradesTable = UITableView()
    var depositAddressButton: CYBButton!

    internal init(balance: BalanceUIModel, accountsViewModel: AccountsViewModel) {

        super.init(nibName: nil, bundle: nil)
        self.balance = balance
        self.accountsViewModel = accountsViewModel

        self.tradesViewModel = AccountTradesViewModel(
            cellProvider: self,
            dataProvider: CybridSession.current,
            assets: accountsViewModel.assets,
            logger: Cybrid.logger)

        self.theme = Cybrid.theme
        self.localizer = CybridLocalizer()

        self.tradesViewModel.getTrades(accountGuid: balance.account.guid ?? "")
        self.setupView()
    }

    @available(iOS, deprecated: 10, message: "You should never use this init method.")
    required init?(coder: NSCoder) {
      assertionFailure("init(coder:) should never be used")
      return nil
    }

    func setupView() {

        view.backgroundColor = .white
        self.view.overrideUserInterfaceStyle = .light
        self.createAssetTitle()
        self.createBalanceTitles()
        self.createDepositAddressButton()
        self.createTradesTable()
    }
}

extension AccountTradesViewController {

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

        // -- Adds
        self.view.addSubview(assetTitleContainer)
        self.centerHorizontalView(container: assetTitleContainer)
    }

    private func createBalanceTitles() {

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

    private func createDepositAddressButton() {

        self.depositAddressButton = CYBButton(title: localizer.localize(with: UIStrings.getDepositAddress)) {

            let depositAddressViewController = DepositAddresViewController(accountBalance: self.balance)
            if self.navigationController != nil {
                self.navigationController?.pushViewController(depositAddressViewController, animated: true)
            } else {
                self.present(depositAddressViewController, animated: true)
            }
        }
        self.depositAddressButton.asLast(parent: self.view,
                                         height: 50,
                                         margins: UIEdgeInsets(top: 0, left: 20, bottom: 25, right: 20))
    }

    private func createTradesTable() {

        self.tradesTable.delegate = self.tradesViewModel
        self.tradesTable.dataSource = self.tradesViewModel
        self.tradesTable.register(AccountTradesCell.self, forCellReuseIdentifier: AccountTradesCell.reuseIdentifier)
        self.tradesTable.rowHeight = UIValues.tradesTableCellHeight
        self.tradesTable.estimatedRowHeight = UIValues.tradesTableCellHeight
        self.tradesTable.translatesAutoresizingMaskIntoConstraints = false

        self.tradesTable.addInTheMiddle(
            topItem: self.balanceFiatValueView,
            bottomItem: self.depositAddressButton,
            margins: UIValues.tradesTableMargins)

        // -- Live Data
        tradesViewModel.trades.bind { _ in
            self.tradesTable.reloadData()
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

extension AccountTradesViewController: AccountTradesViewProvider {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, withData model: TradeUIModel) -> UITableViewCell {

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

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath, with trade: TradeUIModel) {

        let modal = AccountTradeDetailModal(
                trade: trade,
                assetURL: balance.accountAssetURL,
                theme: theme,
                localizer: localizer,
                onConfirm: nil)
        modal.present()
    }
}

extension AccountTradesViewController {

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

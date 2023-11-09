//
//  AccountTransfersView.swift
//  CybridSDK
//
//  Created by Erick Sanchez on 07/11/23.
//

import UIKit

public final class AccountTransfersView: Component {

    internal var accountTransfersViewModel: AccountTransfersViewModel!

    internal var theme: Theme!
    internal var localizer: Localizer!
    internal var balance: BalanceUIModel!

    // -- Views
    var balanceAssetIcon: URLImageView!
    var balanceAssetName: UILabel!
    var assetTitleContainer: UIStackView!
    var balanceValueView: UILabel!
    var subtitle: UILabel!
    var pendingTitle: UILabel!
    let transfersTable = UITableView()

    public func initComponent(balance: BalanceUIModel, accountTransfersViewModel: AccountTransfersViewModel) {

        self.balance = balance
        self.accountTransfersViewModel = accountTransfersViewModel
        self.theme = Cybrid.theme
        self.localizer = CybridLocalizer()
        self.accountTransfersViewModel.getTransfers(accountGuid: balance.account.guid ?? "")
        self.setupView()
    }

    override func setupView() {

        self.backgroundColor = .white
        self.overrideUserInterfaceStyle = .light
        self.createAssetTitle()
        self.createBalanceTitles()
        self.createTransfersTable()
    }
}

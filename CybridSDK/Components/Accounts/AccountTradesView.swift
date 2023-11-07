//
//  AccountTradesView.swift
//  CybridSDK
//
//  Created by Erick Sanchez on 06/11/23.
//

import UIKit

public final class AccountTradesView: Component {
    
    internal var balance: BalanceUIModel!
    internal var accountTradesViewModel: AccountTradesViewModel!
    
    internal var theme: Theme!
    internal var localizer: Localizer!
    
    // -- Views
    var balanceAssetIcon: URLImageView!
    var balanceAssetName: UILabel!
    var assetTitleContainer: UIStackView!
    var balanceValueView: UILabel!
    var balanceFiatValueView: UILabel!
    let tradesTable = UITableView()
    var depositAddressButton: CYBButton!

    public func initComponent(balance: BalanceUIModel, accountTradesViewModel: AccountTradesViewModel) {

        self.balance = balance
        self.accountTradesViewModel = accountTradesViewModel
        self.theme = Cybrid.theme
        self.localizer = CybridLocalizer()
        self.accountTradesViewModel.getTrades(accountGuid: balance.account.guid ?? "")
        self.setupView()
    }

    override func setupView() {

        self.backgroundColor = .white
        self.overrideUserInterfaceStyle = .light
        self.createAssetTitle()
        self.createBalanceTitles()
        self.createDepositAddressButton()
        self.createTradesTable()
    }
}

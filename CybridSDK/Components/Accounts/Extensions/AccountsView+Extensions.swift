//
//  AccountsView+Extensions.swift
//  CybridSDK
//
//

import UIKit

extension AccountsView: UITableViewDelegate, UITableViewDataSource {

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.accountsViewModel.balances.value.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let dataModel = self.accountsViewModel.balances.value[indexPath.row]
        if dataModel.account.type == .trading {
            let cell = (tableView.dequeueReusableCell(
                withIdentifier: AccountsCell.reuseIdentifier,
                for: indexPath) as? AccountsCell)!
            cell.setData(balance: dataModel)
            return cell
        } else {
            let cell = (tableView.dequeueReusableCell(
                withIdentifier: AccountsFiatCell.reuseIdentifier,
                for: indexPath) as? AccountsFiatCell)!
            cell.setData(balance: dataModel)
            return cell
        }
    }

    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return AccountsHeaderCell(currency: Cybrid.fiat.code)
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let balance = self.accountsViewModel.balances.value[indexPath.row]
        var controller = UIViewController()
        if balance.asset?.type == .crypto {
            controller = AccountTradesViewController(balance: balance, accountsViewModel: accountsViewModel)
        } else {
            controller = AccountTransfersViewController(balance: balance)
        }

        if self.parentController?.navigationController != nil {
            self.parentController?.navigationController?.pushViewController(controller, animated: true)
        } else {
            self.parentController?.modalPresentationStyle = .fullScreen
            self.parentController?.present(controller, animated: true)
        }
    }
}

extension AccountsView {

    enum UIValues {

        // -- Sizes
        static let accountComponentTitleSize: CGFloat = 12
        static let accountComponentTitleHeight: CGFloat = 20
        static let accountComponentTitleMargin = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        static let accountValueTitleSize: CGFloat = 23
        static let accountValueTitleHeight: CGFloat = 40
        static let accountValueTitleMargin = UIEdgeInsets(top: 3, left: 10, bottom: 0, right: 10)
        static let accountsTableRowHeight: CGFloat = 64

        // -- Colors
        static let accountComponentTitleColor = UIColor(hex: "#636366")
        static let accountValueTitleColor = UIColor.black

        // -- Sizes
        static let componentTitleSize: CGFloat = 17
        static let componentTitleHeight: CGFloat = 20
        static let componentTitleMargin = UIEdgeInsets(top: 40, left: 10, bottom: 0, right: 10)
        static let componentRequiredButtonsMargin = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: -10)

        static let loadingSpinnerHeight: CGFloat = 30
        static let loadingSpinnerMargin = UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
        static let componentRequiredButtonsHeight: CGFloat = 50
        static let bankAccountsRowHeight: CGFloat = 47
        static let accountsContentTransferButtonHeight: CGFloat = 48

        // -- Colors
        static let componentTitleColor = UIColor.black
        static let contentNoAccountsTitleColor = UIColor.init(hex: "#636366")

        // -- Fonts
        static let compontntContentTitleFont = UIFont.make(ofSize: 25)
        static let componentTitleFont = UIFont.make(ofSize: 17, weight: .bold)
        static let contentNoAccountsTitleFont = UIFont.make(ofSize: 18)

        // -- Margins
        static let accountsTableMargin = UIEdgeInsets(top: 10, left: 10, bottom: 20, right: 10)
        static let accountsContentTransferButtonMargins = UIEdgeInsets(top: 0, left: 20, bottom: 10, right: 20)
    }

    enum UIStrings {

        static let accountsLoadingTitle = "cybrid.accounts.loading.title"
        static let accountsContentTitle = "cybrid.accounts.content.title"
        static let accountsContentTransferButton = "cybrid.accounts.content.transfer.button"
    }
}

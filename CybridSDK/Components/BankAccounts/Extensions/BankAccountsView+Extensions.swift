//
//  BankAccountsView+Extensions.swift
//  CybridSDK
//
//  Created by Erick Sanchez on 07/11/23.
//

import LinkKit
import UIKit

extension BankAccountsView {

    internal func createStateTitle(stringKey: String, image: UIImage) {

        let title = UILabel()
        title.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.sizeToFit()
        title.font = UIValues.componentTitleFont
        title.textColor = UIValues.componentTitleColor
        title.textAlignment = .center
        title.setLocalizedText(key: stringKey, localizer: localizer)

        self.addSubview(title)
        title.constraint(attribute: .centerX,
                         relatedBy: .equal,
                         toItem: self,
                         attribute: .centerX)
        title.constraint(attribute: .centerY,
                         relatedBy: .equal,
                         toItem: self,
                         attribute: .centerY)
        title.constraint(attribute: .height,
                         relatedBy: .equal,
                         toItem: nil,
                         attribute: .notAnAttribute,
                         constant: 25)
        
        let icon = UIImageView(image: image)
        self.addSubview(icon)
        icon.constraint(attribute: .centerY,
                        relatedBy: .equal,
                        toItem: self,
                        attribute: .centerY)
        icon.constraint(attribute: .trailing,
                        relatedBy: .equal,
                        toItem: title,
                        attribute: .leading,
                        constant: -15)
        icon.constraint(attribute: .width,
                        relatedBy: .equal,
                        toItem: nil,
                        attribute: .notAnAttribute,
                        constant: 25)
        icon.constraint(attribute: .height,
                        relatedBy: .equal,
                        toItem: nil,
                        attribute: .notAnAttribute,
                        constant: 25)
    }
}

extension BankAccountsView: UITableViewDelegate, UITableViewDataSource {

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.bankAccountsViewModel.accounts.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let dataModel = self.bankAccountsViewModel.accounts[indexPath.row]
        guard
            let cell = tableView.dequeueReusableCell(
                withIdentifier: BankAccountCell.reuseIdentifier,
                for: indexPath) as? BankAccountCell
        else {
            return UITableViewCell()
        }
        cell.setData(account: dataModel)
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let balance = self.bankAccountsViewModel.accounts[indexPath.row]
        let detail = BankAccountDetailModal(bankAccountsViewModel: self.bankAccountsViewModel, account: balance)
        detail.present()
    }
}

extension BankAccountsView {

    private func createLinkConfiguration(token: String, _ completion: @escaping () -> Void) {
        self.linkConfiguration = LinkTokenConfiguration(token: token, onSuccess: { _ in
            completion()
        })
    }

    internal func openPlaid() {

        self.createLinkConfiguration(token: self.bankAccountsViewModel.latestWorkflow?.plaidLinkToken ?? "") { [self] in

            let result = Plaid.create(self.linkConfiguration)
            switch result {
            case .failure(let error):
                print("Unable to create Plaid handler due to: \(error)")
            case .success(let handler):
                if let parentController = self.parentController {
                    handler.open(presentUsing: .viewController(parentController))
                }
            }
        }
    }
}

extension BankAccountsView {

    enum UIValues {

        // -- Sizes
        static let componentTitleSize: CGFloat = 17
        static let componentTitleHeight: CGFloat = 20
        static let componentTitleMargin = UIEdgeInsets(top: 40, left: 10, bottom: 0, right: 10)
        static let componentRequiredButtonsMargin = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: -10)

        static let loadingSpinnerHeight: CGFloat = 30
        static let loadingSpinnerMargin = UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
        static let componentRequiredButtonsHeight: CGFloat = 50
        static let bankAccountsRowHeight: CGFloat = 47

        // -- Colors
        static let componentTitleColor = UIColor.black
        static let contentNoAccountsTitleColor = UIColor.init(hex: "#636366")

        // -- Fonts
        static let compontntContentTitleFont = UIFont.make(ofSize: 25)
        static let componentTitleFont = UIFont.make(ofSize: 17, weight: .bold)
        static let contentNoAccountsTitleFont = UIFont.make(ofSize: 18)

        // -- Margins
        static let bankAccountsTableMargins = UIEdgeInsets(top: 35, left: 15, bottom: 30, right: 15)
    }

    enum UIStrings {

        static let componentContentTitleText = "cybrid.bank.content.title.text"
        static let componentContentNoAccountText = "cybrid.bank.content.noAccounts.text"

        static let loadingText = "cybrid.bank.accounts.loading.text"
        static let requiredText = "cybrid.bank.accounts.required.text"
        static let requiredButtonText = "cybrid.bank.accounts.required.button.text"
        static let doneText = "cybrid.bank.accounts.done.text"
        static let doneButtonText = "cybrid.bank.accounts.done.button.text"
        static let errorText = "cybrid.bank.accounts.error.text"
        static let errorButtonText = "cybrid.bank.accounts.error.button.text"

        static let authMessageTitle = "cybrid.bank.accounts.auth.title"
        static let authWarningMessage = "cybrid.bank.accounts.auth.warning"
        static let authMessageString = "cybrid.bank.accounts.auth.message"
        static let authButton = "cybrid.bank.accounts.auth.button"
    }
}

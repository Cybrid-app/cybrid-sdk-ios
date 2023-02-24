//
//  BankAccountsViewController+Extensions.swift
//  CybridSDK
//
//  Created by Erick Sanchez Perez on 15/12/22.
//

import CybridApiBankSwift
import Foundation
import UIKit

extension BankAccountsViewController {

    internal func bankAccountsView_Loading() {

        let title = UILabel()
        title.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.sizeToFit()
        title.font = UIValues.componentTitleFont
        title.textColor = UIValues.componentTitleColor
        title.textAlignment = .center
        title.setLocalizedText(key: UIStrings.loadingText, localizer: localizer)

        self.componentContent.addSubview(title)
        title.constraint(attribute: .centerY,
                         relatedBy: .equal,
                         toItem: self.componentContent,
                         attribute: .centerY)
        title.constraint(attribute: .leading,
                         relatedBy: .equal,
                         toItem: self.componentContent,
                         attribute: .leading,
                         constant: UIValues.componentTitleMargin.left)
        title.constraint(attribute: .trailing,
                         relatedBy: .equal,
                         toItem: self.componentContent,
                         attribute: .trailing,
                         constant: -UIValues.componentTitleMargin.right)
        title.constraint(attribute: .height,
                         relatedBy: .equal,
                         toItem: nil,
                         attribute: .notAnAttribute,
                         constant: UIValues.componentTitleHeight)

        // -- Spinner
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.addBelow(toItem: title, height: UIValues.loadingSpinnerHeight, margins: UIValues.loadingSpinnerMargin)
        spinner.color = UIColor.black
        spinner.startAnimating()
    }

    internal func bankAccountsView_Content() {

        // -- Title
        let title = UILabel()
        title.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.sizeToFit()
        title.font = UIValues.compontntContentTitleFont
        title.textColor = UIValues.componentTitleColor
        title.textAlignment = .center
        title.setLocalizedText(key: UIStrings.componentContentTitleText, localizer: localizer)

        self.componentContent.addSubview(title)
        title.constraint(attribute: .centerX,
                         relatedBy: .equal,
                         toItem: self.componentContent,
                         attribute: .centerX)
        title.constraint(attribute: .top,
                         relatedBy: .equal,
                         toItem: self.componentContent,
                         attribute: .topMargin,
                         constant: 15)
        title.constraint(attribute: .height,
                         relatedBy: .equal,
                         toItem: nil,
                         attribute: .notAnAttribute,
                         constant: 32)

        // -- No accounts
        let noAccountsTitle = UILabel()
        noAccountsTitle.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        noAccountsTitle.translatesAutoresizingMaskIntoConstraints = false
        noAccountsTitle.sizeToFit()
        noAccountsTitle.font = UIValues.contentNoAccountsTitleFont
        noAccountsTitle.textColor = UIValues.contentNoAccountsTitleColor
        noAccountsTitle.textAlignment = .center
        noAccountsTitle.setLocalizedText(key: UIStrings.componentContentNoAccountText, localizer: localizer)
        noAccountsTitle.isHidden = !self.bankAccountsViewModel.accounts.isEmpty

        self.componentContent.addSubview(noAccountsTitle)
        noAccountsTitle.constraint(attribute: .centerX,
                         relatedBy: .equal,
                         toItem: self.componentContent,
                         attribute: .centerX)
        noAccountsTitle.constraint(attribute: .centerY,
                         relatedBy: .equal,
                         toItem: self.componentContent,
                         attribute: .centerY)
        noAccountsTitle.constraint(attribute: .height,
                         relatedBy: .equal,
                         toItem: nil,
                         attribute: .notAnAttribute,
                         constant: 20)

        // -- Accounts Table
        self.accountsTable.delegate = self.bankAccountsViewModel
        self.accountsTable.dataSource = self.bankAccountsViewModel
        self.accountsTable.register(BankAccountCell.self, forCellReuseIdentifier: BankAccountCell.reuseIdentifier)
        self.accountsTable.rowHeight = UIValues.bankAccountsRowHeight
        self.accountsTable.estimatedRowHeight = UIValues.bankAccountsRowHeight
        self.accountsTable.translatesAutoresizingMaskIntoConstraints = false

        // -- Constraints
        self.view.addSubview(self.accountsTable)
        self.accountsTable.translatesAutoresizingMaskIntoConstraints = false
        accountsTable.constraint(attribute: .top,
                                 relatedBy: .equal,
                                 toItem: title,
                                 attribute: .bottom,
                                 constant: UIValues.bankAccountsTableMargins.top)
        accountsTable.constraint(attribute: .bottom,
                                 relatedBy: .equal,
                                 toItem: self.view,
                                 attribute: .bottomMargin,
                                 constant: UIValues.bankAccountsTableMargins.bottom)
        accountsTable.constraint(attribute: .leading,
                                 relatedBy: .equal,
                                 toItem: self.view,
                                 attribute: .leading,
                                 constant: UIValues.bankAccountsTableMargins.left)
        accountsTable.constraint(attribute: .trailing,
                                 relatedBy: .equal,
                                 toItem: self.view,
                                 attribute: .trailing,
                                 constant: -UIValues.bankAccountsTableMargins.right)
        self.accountsTable.reloadData()
    }

    internal func bankAccountsView_Required() {

        // -- Title
        self.createStateTitle(
            stringKey: UIStrings.requiredText,
            image: UIImage(named: "kyc_required", in: Bundle(for: Self.self), with: nil)!
        )

        // -- Buttons
        let done = CYBButton(title: localizer.localize(with: UIStrings.requiredButtonText)) {
            self.openPlaid()
        }

        self.componentContent.addSubview(done)
        done.constraint(attribute: .leading,
                           relatedBy: .equal,
                           toItem: self.componentContent,
                           attribute: .leading,
                           constant: UIValues.componentRequiredButtonsMargin.left)
        done.constraint(attribute: .trailing,
                           relatedBy: .equal,
                           toItem: self.componentContent,
                           attribute: .trailing,
                           constant: UIValues.componentRequiredButtonsMargin.right)
        done.constraint(attribute: .bottom,
                           relatedBy: .equal,
                           toItem: self.componentContent,
                           attribute: .bottomMargin,
                           constant: UIValues.componentRequiredButtonsMargin.bottom)
        done.constraint(attribute: .height,
                           relatedBy: .equal,
                           toItem: nil,
                           attribute: .notAnAttribute,
                           constant: UIValues.componentRequiredButtonsHeight)
    }

    internal func bankAccountsView_Done() {

        // -- Title
        self.createStateTitle(
            stringKey: UIStrings.doneText,
            image: UIImage(named: "kyc_verified", in: Bundle(for: Self.self), with: nil)!
        )

        // -- Buttons
        let done = CYBButton(title: localizer.localize(with: UIStrings.doneButtonText)) {
            self.dismiss(animated: true)
        }

        self.componentContent.addSubview(done)
        done.constraint(attribute: .leading,
                           relatedBy: .equal,
                           toItem: self.componentContent,
                           attribute: .leading,
                           constant: UIValues.componentRequiredButtonsMargin.left)
        done.constraint(attribute: .trailing,
                           relatedBy: .equal,
                           toItem: self.componentContent,
                           attribute: .trailing,
                           constant: UIValues.componentRequiredButtonsMargin.right)
        done.constraint(attribute: .bottom,
                           relatedBy: .equal,
                           toItem: self.componentContent,
                           attribute: .bottomMargin,
                           constant: UIValues.componentRequiredButtonsMargin.bottom)
        done.constraint(attribute: .height,
                           relatedBy: .equal,
                           toItem: nil,
                           attribute: .notAnAttribute,
                           constant: UIValues.componentRequiredButtonsHeight)
    }

    internal func bankAccountsView_Error() {

        // -- Title
        self.createStateTitle(
            stringKey: UIStrings.errorText,
            image: UIImage(named: "kyc_error", in: Bundle(for: Self.self), with: nil)!
        )

        // -- Buttons
        let done = CYBButton(title: localizer.localize(with: UIStrings.errorButtonText)) {
            self.dismiss(animated: true)
        }

        self.componentContent.addSubview(done)
        done.constraint(attribute: .leading,
                           relatedBy: .equal,
                           toItem: self.componentContent,
                           attribute: .leading,
                           constant: UIValues.componentRequiredButtonsMargin.left)
        done.constraint(attribute: .trailing,
                           relatedBy: .equal,
                           toItem: self.componentContent,
                           attribute: .trailing,
                           constant: UIValues.componentRequiredButtonsMargin.right)
        done.constraint(attribute: .bottom,
                           relatedBy: .equal,
                           toItem: self.componentContent,
                           attribute: .bottomMargin,
                           constant: UIValues.componentRequiredButtonsMargin.bottom)
        done.constraint(attribute: .height,
                           relatedBy: .equal,
                           toItem: nil,
                           attribute: .notAnAttribute,
                           constant: UIValues.componentRequiredButtonsHeight)
    }

    internal func createStateTitle(stringKey: String, image: UIImage) {

        let title = UILabel()
        title.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.sizeToFit()
        title.font = UIValues.componentTitleFont
        title.textColor = UIValues.componentTitleColor
        title.textAlignment = .center
        title.setLocalizedText(key: stringKey, localizer: localizer)

        self.componentContent.addSubview(title)
        title.constraint(attribute: .centerX,
                       relatedBy: .equal,
                       toItem: self.componentContent,
                       attribute: .centerX)
        title.constraint(attribute: .centerY,
                       relatedBy: .equal,
                       toItem: self.componentContent,
                       attribute: .centerY)
        title.constraint(attribute: .height,
                         relatedBy: .equal,
                         toItem: nil,
                         attribute: .notAnAttribute,
                         constant: 25)

        let icon = UIImageView(image: image)
        self.componentContent.addSubview(icon)
        icon.constraint(attribute: .centerY,
                       relatedBy: .equal,
                       toItem: self.componentContent,
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

extension BankAccountsViewController: BankAccountsViewProvider {

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath,
                   withAccount dataModel: ExternalBankAccountBankModel) -> UITableViewCell {

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

    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath,
                   withAccount balance: ExternalBankAccountBankModel) {

        let detail = BankAccountDetailModal(bankAccountsViewModel: self.bankAccountsViewModel, account: balance)
        detail.present()
    }
}

extension BankAccountsViewController {

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
    }
}

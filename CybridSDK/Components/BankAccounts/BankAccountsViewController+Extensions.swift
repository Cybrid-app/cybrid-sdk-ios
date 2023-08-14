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
            self.bankAccountsViewModel?.openBankAuthorization()
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

    internal func bankAccountsView_Authorization() {

        // -- Scroll
        let scroll = UIScrollView()
        self.componentContent.addSubview(scroll)
        let contentView = setupScrollView(scroll, parent: componentContent)

        // -- IamgeTitle
        let imageTitle = UIImageView(image: getImage("bankAuthorizationImage", aClass: Self.self))
        contentView.addSubview(imageTitle)
        imageTitle.constraintTop(contentView, margin: 0)
        imageTitle.centerHorizontal(parent: contentView)
        imageTitle.setConstraintsSize(size: CGSize(width: 183, height: 174))

        // -- Title
        let titleString = localizer.localize(with: UIStrings.authMessageTitle)
        let title = UILabel()
        title.font = UIFont.make(ofSize: 23)
        title.textAlignment = .center
        let paragraphStyle = getParagraphStyle(1.19)
        paragraphStyle.alignment = .center
        title.setParagraphText(titleString, paragraphStyle)
        contentView.addSubview(title)
        title.below(imageTitle, top: 17)
        title.constraintLeft(contentView, margin: 15)
        title.constraintRight(contentView, margin: 15)
        title.constraintHeight(32)

        // -- Warning Container
        let warningContainer = UIView()
        warningContainer.layer.backgroundColor = UIColor(red: 0.983, green: 0.894, blue: 0.578, alpha: 1).cgColor
        warningContainer.layer.cornerRadius = 10
        contentView.addSubview(warningContainer)
        warningContainer.below(title, top: 18)
        warningContainer.constraintLeft(contentView, margin: 15)
        warningContainer.constraintRight(contentView, margin: 15)
        warningContainer.constraintHeight(103)

        // -- Warning Label
        let warningString = localizer.localize(with: UIStrings.authWarningMessage)
        let warningLabel = UILabel()
        warningLabel.font = UIFont.make(ofSize: 17.5, weight: .bold)
        warningLabel.numberOfLines = 0
        warningLabel.lineBreakMode = .byWordWrapping
        let warningLabelParagraph = getParagraphStyle(1.1)
        warningLabelParagraph.alignment = .justified
        warningLabel.setParagraphText(warningString, warningLabelParagraph)
        warningContainer.addSubview(warningLabel)
        warningLabel.centerVertical(parent: warningContainer)
        warningLabel.constraintLeft(warningContainer, margin: 20)
        warningLabel.constraintRight(warningContainer, margin: 20)

        // -- Message
        let messageString = localizer.localize(with: UIStrings.authMessageString)
        let messageLabel = UILabel()
        messageLabel.font = UIFont.make(ofSize: 18)
        messageLabel.numberOfLines = 0
        messageLabel.lineBreakMode = .byWordWrapping
        let messageParagraph = getParagraphStyle(1.1)
        messageParagraph.alignment = .justified
        messageLabel.setParagraphText(messageString, messageParagraph)
        contentView.addSubview(messageLabel)
        messageLabel.below(warningContainer, top: 17)
        messageLabel.constraintLeft(contentView, margin: 20)
        messageLabel.constraintRight(contentView, margin: 20)

        // -- Continue button
        let authorizeString = localizer.localize(with: UIStrings.authButton)
        let authorizeButton = CYBButton(title: authorizeString) { [self] in
            self.openPlaid()
        }
        contentView.addSubview(authorizeButton)
        authorizeButton.below(messageLabel, top: 25)
        authorizeButton.constraintLeft(contentView, margin: 15)
        authorizeButton.constraintRight(contentView, margin: 15)
        authorizeButton.constraintHeight(48)
        authorizeButton.constraintBottom(contentView, margin: 15)
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
        
        static let authMessageTitle = "cybrid.bank.accounts.auth.title"
        static let authWarningMessage = "cybrid.bank.accounts.auth.warning"
        static let authMessageString = "cybrid.bank.accounts.auth.message"
        static let authButton = "cybrid.bank.accounts.auth.button"
    }
}

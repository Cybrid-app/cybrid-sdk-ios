//
//  TransferViewController+Extensions.swift
//  CybridSDK
//
//  Created by Erick Sanchez Perez on 18/03/23.
//

import Foundation
import UIKit

extension TransferViewController {

    internal func transferView_Loading() {

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
                         constant: UIValues.loadingTitleMargin.left)
        title.constraint(attribute: .trailing,
                         relatedBy: .equal,
                         toItem: self.componentContent,
                         attribute: .trailing,
                         constant: -UIValues.loadingTitleMargin.right)
        title.constraint(attribute: .height,
                         relatedBy: .equal,
                         toItem: nil,
                         attribute: .notAnAttribute,
                         constant: UIValues.loadingTitleHeight)

        // -- Spinner
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.addBelow(toItem: title, height: UIValues.loadingSpinnerHeight, margins: UIValues.loadingSpinnerMargin)
        spinner.color = UIColor.black
        spinner.startAnimating()
    }

    internal func transferView_Accounts() {

        // -- Title
        let title = UILabel()
        title.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.sizeToFit()
        title.font = UIValues.accountsTitleFont
        title.textColor = UIValues.accountsTitleColor
        title.textAlignment = .center
        title.setLocalizedText(key: UIStrings.accountsTitleText, localizer: localizer)
        title.asFirstIn(self.componentContent, height: UIValues.accountsTitleHeight, margins: UIValues.accountsTitleMargin)

        // -- Balance
        let balance = UILabel()
        balance.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        balance.translatesAutoresizingMaskIntoConstraints = false
        balance.sizeToFit()
        balance.font = UIValues.accountsBalanceFont
        balance.textColor = UIColor.black
        balance.textAlignment = .center
        balance.text = self.transferViewModel.fiatBalance.value
        balance.addBelow(toItem: title, height: UIValues.accountsBalanceHeight, margins: UIValues.accountsBalanceMargin)
        self.transferViewModel.fiatBalance.bind { value in
            balance.text = value
        }

        // -- Segment
        let segmentsLabels = [UIStrings.accountsDepositText, UIStrings.accountsWithdrawText]
        let segments = UISegmentedControl(items: segmentsLabels.map { localizer.localize(with: $0) })
        segments.translatesAutoresizingMaskIntoConstraints = false
        segments.selectedSegmentIndex = 0
        segments.addTarget(transferViewModel, action: #selector(transferViewModel.segmentedControlValueChanged(_:)), for: .valueChanged)
        segments.addBelow(toItem: balance, height: UIValues.accountsSegmentHeight, margins: UIValues.accountsSegmentMargin)

        // -- From/to
        let fromTo = self.createSubTitleLabel(key: UIStrings.accountsFromText)
        fromTo.addBelow(toItem: segments, height: UIValues.accountsFromToHeight, margins: UIValues.accountsFromToMargin)
        transferViewModel.isWithdraw.bind { [self] value in
            if value {
                fromTo.setLocalizedText(key: UIStrings.accountsToText, localizer: localizer)
            } else {
                fromTo.setLocalizedText(key: UIStrings.accountsFromText, localizer: localizer)
            }
        }

        // -- From/To Field
        let fromToField = self.createFromField()
        self.setFromFieldData(field: fromToField)
        fromToField.addBelow(toItem: fromTo, height: UIValues.accountsFromToFieldHeight, margins: UIValues.accountsFromToFieldMargin)

        // -- Amount
        let amount = self.createSubTitleLabel(key: UIStrings.accountsAmountText)
        amount.addBelow(toItem: fromToField, height: UIValues.accountsFromToHeight, margins: UIValues.accountsAmountMargin)

        // -- Amount Field
        let amountField = self.createAmountField()
        self.setAmountFieldData(field: amountField)
        amountField.addBelow(toItem: amount, height: UIValues.accountsAmountFieldHeight, margins: UIValues.accountsAmountFieldMargin)

        // -- Action button
        let actionButton = CYBButton(
            title: localizer.localize(with: UIStrings.accountsActionButtonText),
            action: { [self] in

                let modal = TransferModal(transferViewModel: self.transferViewModel!)
                modal.present()
            })
        actionButton.addBelow(toItem: amountField, height: 48, margins: UIValues.accountsActionButtonMargin)

    }

    internal func transferView_Error() {

        // -- Title
        self.createStateTitle(
            stringKey: UIStrings.errorText,
            image: UIImage(named: "kyc_error", in: Bundle(for: Self.self), with: nil)!
        )

        // -- Buttons
        let done = CYBButton(title: localizer.localize(with: UIStrings.errorButton)) {
            self.dismiss(animated: true)
        }

        self.componentContent.addSubview(done)
        done.constraint(attribute: .leading,
                           relatedBy: .equal,
                           toItem: self.componentContent,
                           attribute: .leading,
                           constant: UIValues.actionButtonMargin.left)
        done.constraint(attribute: .trailing,
                           relatedBy: .equal,
                           toItem: self.componentContent,
                           attribute: .trailing,
                           constant: UIValues.actionButtonMargin.right)
        done.constraint(attribute: .bottom,
                           relatedBy: .equal,
                           toItem: self.componentContent,
                           attribute: .bottomMargin,
                           constant: UIValues.actionButtonMargin.bottom)
        done.constraint(attribute: .height,
                           relatedBy: .equal,
                           toItem: nil,
                           attribute: .notAnAttribute,
                           constant: UIValues.actionButtonHeight)
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

    func createSubTitleLabel(key: String) -> UILabel {

        let view = UILabel()
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        view.sizeToFit()
        view.font = UIValues.compontntSubTitleFont
        view.textColor = UIValues.componentSubTitleColor
        view.setLocalizedText(key: key, localizer: localizer)
        return view
    }

    func createFromField() -> CYBTextField {

        let fromTextField = CYBTextField(style: .rounded, icon: .urlImage(""), theme: theme)
        fromTextField.accessibilityIdentifier = "accountsPickerTextField"
        fromTextField.tintColor = UIColor.clear
        self.accountsPickerView.delegate = self.transferViewModel
        self.accountsPickerView.dataSource = self.transferViewModel
        self.accountsPickerView.accessibilityIdentifier = "accountsPicker"
        if self.transferViewModel.externalBankAccounts.value.count > 1 {
            fromTextField.inputView = self.accountsPickerView
        }
        return fromTextField
    }

    func setFromFieldData(field: CYBTextField) {

        let account = self.transferViewModel.externalBankAccounts.value.first
        let accountMask = account?.plaidAccountMask ?? ""
        let accountName = account?.plaidAccountName ?? ""
        let accountID = account?.plaidInstitutionId ?? ""
        let name = "\(accountID) - \(accountName) (\(accountMask))"

        field.updateIcon(.image("test_bank"))
        field.text = name
    }

    func createAmountField() -> CYBTextField {

        let textField = CYBTextField(style: .plain, icon: .text(""), theme: theme)
        textField.placeholder = "0.0"
        textField.keyboardType = .decimalPad
        textField.rightViewMode = .always
        textField.accessibilityIdentifier = "amountTextField"
        return textField
    }

    func setAmountFieldData(field: CYBTextField) {

        let asset = self.transferViewModel.currentFiatCurrency
        field.updateIcon(.text(asset))
    }
}

extension TransferViewController {

    enum UIValues {

        // -- Sizes
        static let loadingTitleSize: CGFloat = 17
        static let loadingTitleHeight: CGFloat = 20
        static let loadingSpinnerHeight: CGFloat = 30
        static let loadingSpinnerMargin = UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
        static let actionButtonHeight: CGFloat = 50
        static let accountsTitleHeight: CGFloat = 16
        static let accountsBalanceHeight: CGFloat = 32
        static let accountsSegmentHeight: CGFloat = 32
        static let accountsFromToHeight: CGFloat = 16
        static let accountsFromToFieldHeight: CGFloat = 47
        static let accountsAmountFieldHeight: CGFloat = 44

        // -- Colors
        static let componentTitleColor = UIColor.black
        static let componentSubTitleColor = UIColor.init(hex: "#757575")
        static let accountsTitleColor = UIColor.init(hex: "#636366")

        // -- Fonts
        static let compontntContentTitleFont = UIFont.make(ofSize: 25)
        static let compontntSubTitleFont = UIFont.make(ofSize: 13)
        static let componentTitleFont = UIFont.make(ofSize: 17, weight: .bold)
        static let accountsTitleFont = UIFont.make(ofSize: 13)
        static let accountsBalanceFont = UIFont.make(ofSize: 23)

        // -- Margins
        static let loadingTitleMargin = UIEdgeInsets(top: 40, left: 10, bottom: 0, right: 10)
        static let actionButtonMargin = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: -10)
        static let accountsTitleMargin = UIEdgeInsets(top: 10, left: 16, bottom: 0, right: 16)
        static let accountsBalanceMargin = UIEdgeInsets(top: 3, left: 16, bottom: 0, right: 16)
        static let accountsSegmentMargin = UIEdgeInsets(top: 25, left: 16, bottom: 0, right: 16)
        static let accountsFromToMargin = UIEdgeInsets(top: 45, left: 16, bottom: 0, right: 16)
        static let accountsFromToFieldMargin = UIEdgeInsets(top: 18, left: 16, bottom: 0, right: 16)
        static let accountsAmountMargin = UIEdgeInsets(top: 30, left: 16, bottom: 0, right: 16)
        static let accountsAmountFieldMargin = UIEdgeInsets(top: 16, left: 16, bottom: 0, right: 16)
        static let accountsActionButtonMargin = UIEdgeInsets(top: 40, left: 16, bottom: 0, right: 16)
    }

    enum UIStrings {

        static let loadingText = "cybrid.transfer.loading.text"
        static let errorText = "cybrid.transfer.error.text"
        static let errorButton = "cybrid.transfer.error.text"
        static let accountsTitleText = "cybrid.transfer.account.title.text"
        static let accountsDepositText = "cybrid.transfer.account.deposit.text"
        static let accountsWithdrawText = "cybrid.transfer.account.withdraw.text"
        static let accountsFromText = "cybrid.transfer.account.from.text"
        static let accountsToText = "cybrid.transfer.account.to.text"
        static let accountsAmountText = "cybrid.transfer.account.amount.text"
        static let accountsActionButtonText = "cybrid.transfer.action.button.text"
    }
}

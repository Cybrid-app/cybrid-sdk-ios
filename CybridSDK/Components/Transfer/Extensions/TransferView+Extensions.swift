//
//  TransferViewController+Extensions.swift
//  CybridSDK
//
//  Created by Erick Sanchez Perez on 18/03/23.
//

import Foundation
import UIKit

extension TransferView {

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
        self.addSubview(icon)
        icon.constraint(attribute: .centerY,
                       relatedBy: .equal,
                       toItem: self.componentContent,
                       attribute: .centerY)
        icon.constraint(attribute: .trailing,
                        relatedBy: .equal,
                        toItem: title,
                        attribute: .leading,
                        constant: -5)
        icon.constraint(attribute: .width,
                        relatedBy: .equal,
                        toItem: nil,
                        attribute: .notAnAttribute,
                        constant: 20)
        icon.constraint(attribute: .height,
                        relatedBy: .equal,
                        toItem: nil,
                        attribute: .notAnAttribute,
                        constant: 20)
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

    func createBalanceLoader() -> UIView {

        let loaderContainer = UIView()

        let spinner = UIActivityIndicatorView(style: .medium)
        loaderContainer.addSubview(spinner)
        spinner.constraint(attribute: .centerY,
                           relatedBy: .equal,
                           toItem: loaderContainer,
                           attribute: .centerY)
        spinner.constraint(attribute: .centerX,
                           relatedBy: .equal,
                           toItem: loaderContainer,
                           attribute: .centerX)
        spinner.constraint(attribute: .width,
                           relatedBy: .equal,
                           toItem: nil,
                           attribute: .notAnAttribute,
                           constant: UIValues.loadingTitleHeight)
        spinner.constraint(attribute: .height,
                           relatedBy: .equal,
                           toItem: nil,
                           attribute: .notAnAttribute,
                           constant: UIValues.loadingTitleHeight)

        loaderContainer.backgroundColor = UIColor.white.withAlphaComponent(0)
        spinner.color = UIColor.black
        spinner.startAnimating()
        return loaderContainer
    }

    func createFromField() -> CYBTextField {

        let fromTextField = CYBTextField(style: .rounded, icon: .urlImage(""), theme: theme)
        fromTextField.accessibilityIdentifier = "accountsPickerTextField"
        fromTextField.tintColor = UIColor.clear
        self.accountsPickerView.delegate = self
        self.accountsPickerView.dataSource = self
        self.accountsPickerView.accessibilityIdentifier = "accountsPicker"
        if self.transferViewModel.externalBankAccounts.value.count > 1 {
            fromTextField.inputView = self.accountsPickerView
        }
        return fromTextField
    }

    func setFromFieldData(field: CYBTextField) {

        let account = self.transferViewModel.currentExternalBankAccount.value
        self.transferViewModel.currentExternalBankAccount.value = account
        let name = self.transferViewModel.getAccountNameInFormat(account)

        if account?.state == "refreshRequired" {
            field.updateIcon(.image("kyc_error"))
        } else {
            field.updateIcon(.image("test_bank"))
        }

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

        let asset = Cybrid.fiat.code
        field.updateIcon(.text(asset))
    }
}

extension TransferView: UIPickerViewDelegate, UIPickerViewDataSource {

    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.transferViewModel.externalBankAccounts.value.count
    }

    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

        let account = self.transferViewModel.externalBankAccounts.value[row]
        self.transferViewModel.currentExternalBankAccount.value = account
        let name = self.transferViewModel.getAccountNameInFormat(account)
        return name
    }

    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.transferViewModel.currentExternalBankAccount.value = self.transferViewModel.externalBankAccounts.value[row]
    }
}

extension TransferView {

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
        static let warningText = "cybrid.transfer.warning.text"
        static let errorButton = "cybrid.transfer.error.button"
        static let accountsTitleText = "cybrid.transfer.account.title.text"
        static let accountsDepositText = "cybrid.transfer.account.deposit.text"
        static let accountsWithdrawText = "cybrid.transfer.account.withdraw.text"
        static let accountsFromText = "cybrid.transfer.account.from.text"
        static let accountsToText = "cybrid.transfer.account.to.text"
        static let accountsAmountText = "cybrid.transfer.account.amount.text"
        static let accountsActionButtonText = "cybrid.transfer.action.button.text"
    }
}

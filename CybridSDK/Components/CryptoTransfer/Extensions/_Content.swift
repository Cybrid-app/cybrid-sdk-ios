//
//  _Content.swift
//  CybridSDK
//
//  Created by Erick Sanchez on 18/09/23.
//

import UIKit
import CybridApiBankSwift

extension CryptoTransferView {

    internal func cryptoTransferView_Content() {

        // -- Title
        let titleString = localizer.localize(with: Strings.contentTitle)
        let title = self.label(
            font: UIFont.make(ofSize: 23, weight: .bold),
            color: UIColor.init(hex: "#3A3A3C"),
            text: titleString,
            lineHeight: 1.15,
            aligment: .left)
        self.addSubview(title)
        title.constraintTop(self, margin: 10)
        title.constraintLeft(self, margin: 10)
        title.constraintRight(self, margin: 10)

        // -- Account title
        // let accountTitleString = localizer.localize(with: UIStrings.createWalletAssetTitle)
        let accountTitleString = "From Account"
        let accountTitle = self.label(
            font: UIFont.make(ofSize: 14, weight: .regular),
            color: UIColor(hex: "#818181"),
            text: accountTitleString,
            lineHeight: 1.05,
            aligment: .left)
        self.addSubview(accountTitle)
        accountTitle.below(title, top: 35)
        accountTitle.constraintLeft(self, margin: 10)
        accountTitle.constraintRight(self, margin: 10)

        // -- Account Picker
        let accountPicker = AccountPicker(
            accounts: cryptoTransferViewModel?.accounts ?? [],
            delegate: self
        )
        self.addSubview(accountPicker)
        accountPicker.below(accountTitle, top: 10)
        accountPicker.constraintLeft(self, margin: 10)
        accountPicker.constraintRight(self, margin: 10)

        // -- Wallet title
        // let accountTitleString = localizer.localize(with: UIStrings.createWalletAssetTitle)
        let walletTitleString = "To Wallet"
        let walletTitle = self.label(
            font: UIFont.make(ofSize: 14, weight: .regular),
            color: UIColor(hex: "#818181"),
            text: walletTitleString,
            lineHeight: 1.05,
            aligment: .left)
        self.addSubview(walletTitle)
        walletTitle.below(accountPicker, top: 35)
        walletTitle.constraintLeft(self, margin: 10)
        walletTitle.constraintRight(self, margin: 10)

        // -- Wallet Picker
        let walletPicker = WalletPicker(
            wallets: cryptoTransferViewModel?.externalWallets ?? [],
            asset: accountPicker.accountSelected?.asset ?? ""
        )
        self.addSubview(walletPicker)
        walletPicker.below(walletTitle, top: 10)
        walletPicker.constraintLeft(self, margin: 10)
        walletPicker.constraintRight(self, margin: 10)

        // -- Amount title
        // let accountTitleString = localizer.localize(with: UIStrings.createWalletAssetTitle)
        let amountTitleString = "Amount"
        let amountTitle = self.label(
            font: UIFont.make(ofSize: 14, weight: .regular),
            color: UIColor(hex: "#818181"),
            text: amountTitleString,
            lineHeight: 1.05,
            aligment: .left)
        self.addSubview(amountTitle)
        amountTitle.below(walletPicker, top: 35)
        amountTitle.constraintLeft(self, margin: 10)
        amountTitle.constraintRight(self, margin: 10)

        // -- Amount Input
        let switchButton = self.createSwitchButton()
        switchButton.accessibilityIdentifier = "TradeComponent_SwitchButton"
        let amountTextField = self.createAmountField(switchButton: switchButton)
        amountTextField.accessibilityIdentifier = "TradeComponent_AmountField"
        amountTextField.updateIcon(
            .text(accountPicker.accountSelected?.asset ?? "")
        )
        self.addSubview(amountTextField)
        amountTextField.below(amountTitle, top: 10)
        amountTextField.constraintLeft(self, margin: 10)
        amountTextField.constraintRight(self, margin: 10)

        // -- Flag, realTimePrice and maxButton
        // var flagIcon = URLImageView(url: nil)

        // -- Continue button
        // let continueButtonString = localizer.localize(with: UIStrings.createWalletSaveButton)
        let continueButtonString = "Continue"
        let continueButton = CYBButton(title: continueButtonString) {}
        self.addSubview(continueButton)
        continueButton.constraintLeft(self, margin: 10)
        continueButton.constraintRight(self, margin: 10)
        continueButton.constraintBottom(self, margin: 5)

        // -- Binds
        self.cryptoTransferViewModel?.currentAccount.bind { account in
            if let account {
                walletPicker.getWalletsByAsset(asset: account.asset!)
            }
        }

        self.cryptoTransferViewModel?.isTransferInFiat.bind { [self] state in
            if state {
                amountTextField.updateIcon(
                    .text(self.cryptoTransferViewModel?.fiat.code ?? Cybrid.fiat.code)
                )
            } else {
                amountTextField.updateIcon(
                    .text(accountPicker.accountSelected?.asset ?? "")
                )
            }
        }
    }

    func createSwitchButton() -> UIButton {

        let image = UIImage(named: "switchIcon", in: Bundle(for: Self.self), with: nil)
        let switchButton = UIButton(type: .custom)
        switchButton.setImage(image, for: .normal)
        switchButton.addTarget(cryptoTransferViewModel, action: #selector(cryptoTransferViewModel?.switchActionHandler), for: .touchUpInside)
        switchButton.accessibilityIdentifier = "switchButton"
        switchButton.constraint(attribute: .height,
                                relatedBy: .equal,
                                toItem: nil,
                                attribute: .notAnAttribute,
                                constant: UIValues.contentSwitchButtonSize.height)
        switchButton.constraint(attribute: .width,
                                relatedBy: .equal,
                                toItem: nil,
                                attribute: .notAnAttribute,
                                constant: UIValues.contentSwitchButtonSize.width)
        return switchButton
    }

    func createAmountField(switchButton: UIButton) -> CYBTextField {

        let textField = CYBTextField(style: .plain, icon: .text(""), theme: Cybrid.theme)
        textField.placeholder = "0.0"
        textField.keyboardType = .decimalPad
        // textField.delegate = self
        textField.rightView = switchButton
        textField.rightViewMode = .always
        textField.accessibilityIdentifier = "amountTextField"
        return textField
    }
}

extension CryptoTransferView: AccountPickerDelegate {
    public func onAccountSelected(account: AccountBankModel) {
        self.cryptoTransferViewModel?.currentAccount.value = account
        self.cryptoTransferViewModel?.isTransferInFiat.value = false
    }
}

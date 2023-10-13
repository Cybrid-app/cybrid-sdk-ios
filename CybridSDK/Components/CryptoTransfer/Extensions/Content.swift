//
//  Content.swift
//  CybridSDK
//
//  Created by Erick Sanchez on 11/10/23.
//

import UIKit
import CybridApiBankSwift

extension CryptoTransferView {

    internal func cryptoTransferView_Content() {

        // -- Title
        let title = self.label(
            font: UIFont.make(ofSize: 23, weight: .bold),
            color: UIColor.init(hex: "#3A3A3C"),
            text: localizer.localize(with: Strings.contentTitle),
            lineHeight: 1.15,
            aligment: .left)
        self.addSubview(title)
        title.constraintTop(self, margin: 10)
        title.constraintLeft(self, margin: 10)
        title.constraintRight(self, margin: 10)

        // -- Account title
        let accountTitle = self.label(
            font: UIFont.make(ofSize: 14, weight: .regular),
            color: UIColor(hex: "#818181"),
            text: localizer.localize(with: Strings.contentFrom),
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
        self.cryptoTransferViewModel?.currentAccount.value = accountPicker.accountSelected

        // -- Wallet title
        let walletTitle = self.label(
            font: UIFont.make(ofSize: 14, weight: .regular),
            color: UIColor(hex: "#818181"),
            text: localizer.localize(with: Strings.contentTo),
            lineHeight: 1.05,
            aligment: .left)
        self.addSubview(walletTitle)
        walletTitle.below(accountPicker, top: 35)
        walletTitle.constraintLeft(self, margin: 10)
        walletTitle.constraintRight(self, margin: 10)

        // -- Wallet Picker
        let walletPicker = WalletPicker(
            wallets: cryptoTransferViewModel?.externalWallets ?? [],
            asset: accountPicker.accountSelected?.asset ?? "",
            delegate: self
        )
        self.addSubview(walletPicker)
        walletPicker.below(walletTitle, top: 10)
        walletPicker.constraintLeft(self, margin: 10)
        walletPicker.constraintRight(self, margin: 10)
        self.cryptoTransferViewModel?.currentExternalWallet = walletPicker.walletSelected

        // -- Amount title
        let amountTitle = self.label(
            font: UIFont.make(ofSize: 14, weight: .regular),
            color: UIColor(hex: "#818181"),
            text: localizer.localize(with: Strings.contentAmount),
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
        let flagIcon = URLImageView(url: nil)
        let realTimePriceLabel = self.label(
            font: UIFont.make(ofSize: 13, weight: .regular),
            color: UIColor(hex: "#000000"),
            text: "",
            lineHeight: 1.53,
            aligment: .left)
        let maxButton = UIButton()
        self.createRealTimeLabel(
            topView: amountTextField,
            icon: flagIcon,
            realTimeLabel: realTimePriceLabel,
            maxButton: maxButton
        )

        // -- Error
        let errorLabel = self.label(
            font: UIFont.make(ofSize: 13, weight: .regular),
            color: UIColor(hex: "#E91E26"),
            text: localizer.localize(with: Strings.contentErrorInsufficient),
            lineHeight: 1.53,
            aligment: .left)
        self.addSubview(errorLabel)
        errorLabel.below(flagIcon, top: 5)
        errorLabel.constraintLeft(self, margin: 10)
        errorLabel.constraintRight(self, margin: 10)
        errorLabel.isHidden = !cryptoTransferViewModel!.amountWithPriceErrorObservable.value

        // -- Continue button
        let continueButtonString = localizer.localize(with: Strings.contentButtonContinue)
        let continueButton = CYBButton(title: continueButtonString) { [self] in
            let modal = CryptoTransferModal(
                cryptoTransferViewModel: self.cryptoTransferViewModel!)
            modal.present()
            cryptoTransferViewModel?.createQuote(amount: amountTextField.text?.stringValue ?? "0")
        }
        continueButton.isEnabled = !cryptoTransferViewModel!.amountWithPriceErrorObservable.value
        self.addSubview(continueButton)
        continueButton.constraintLeft(self, margin: 10)
        continueButton.constraintRight(self, margin: 10)
        continueButton.constraintBottom(self, margin: 5)

        // -- Binds
        self.cryptoTransferViewModel?.currentAccount.bind { account in
            if let account {
                walletPicker.getWalletsByAsset(asset: account.asset!)
                self.cryptoTransferViewModel?.calculatePreQuote()
            }
        }

        self.cryptoTransferViewModel?.isTransferInFiat.bind { [self] state in
            if state {
                amountTextField.updateIcon(
                    .text(self.cryptoTransferViewModel?.fiat.code ?? Cybrid.fiat.code)
                )
                self.setDataForRealTimeLabel(
                    icon: flagIcon,
                    asset: accountPicker.accountSelected?.asset ?? ""
                )
                maxButton.isHidden = true
            } else {
                amountTextField.updateIcon(
                    .text(accountPicker.accountSelected?.asset ?? "")
                )
                self.setDataForRealTimeLabel(
                    icon: flagIcon,
                    asset: self.cryptoTransferViewModel?.fiat.code ?? Cybrid.fiat.code
                )
                maxButton.isHidden = false
            }
            self.cryptoTransferViewModel?.calculatePreQuote()
        }

        self.cryptoTransferViewModel?.amountInputObservable.bind { [self] amount in

            amountTextField.text = amount
            self.cryptoTransferViewModel?.currentAmountInput = amount
            self.cryptoTransferViewModel?.calculatePreQuote()
        }

        self.cryptoTransferViewModel?.amountWithPriceObservable.bind { amount in
            realTimePriceLabel.text = amount
        }

        self.cryptoTransferViewModel?.amountWithPriceErrorObservable.bind { state in
            errorLabel.isHidden = !state
            continueButton.customState = !state ? .normal : .disabled
        }

        self.cryptoTransferViewModel?.currentAccount.bind { [self] account in
            self.cryptoTransferViewModel?.changeCurrentAccount(account)
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
        textField.delegate = self
        textField.rightView = switchButton
        textField.rightViewMode = .always
        textField.accessibilityIdentifier = "amountTextField"
        return textField
    }

    func createRealTimeLabel(topView: UIView, icon: URLImageView, realTimeLabel: UILabel, maxButton: UIButton) {

        let marginTop: CGFloat = 10

        // -- Icon
        self.addSubview(icon)
        icon.constraintLeft(self, margin: 10)
        icon.below(topView, top: marginTop)
        icon.setConstraintsSize(size: CGSize(width: 28, height: 24))

        // -- Real Time Price Label
        self.addSubview(realTimeLabel)
        realTimeLabel.leftAside(icon, margin: 7.5)
        realTimeLabel.below(topView, top: marginTop * 1.5)

        // -- Max Button
        let maxButtonString = localizer.localize(with: Strings.contentButtonMax)
        maxButton.backgroundColor = UIColor.clear
        maxButton.setTitleColor(UIColor(hex: "#2F54EB"), for: .normal)
        maxButton.setTitle(maxButtonString, for: .normal)
        maxButton.titleLabel?.font = UIFont.make(ofSize: 13, weight: .regular)
        maxButton.accessibilityIdentifier = "TradeComponent_Content_MaxButton"
        maxButton.addTarget(cryptoTransferViewModel, action: #selector(self.cryptoTransferViewModel?.maxButtonClickHandler), for: .touchUpInside)
        self.addSubview(maxButton)
        maxButton.below(topView, top: marginTop)
        maxButton.constraintRight(self, margin: 10)
    }

    func setDataForRealTimeLabel(icon: URLImageView, asset: String) {

        let iconUrl = Cybrid.getAssetURL(with: asset)
        icon.setURL(iconUrl)
    }
}

extension CryptoTransferView: AccountPickerDelegate {
    public func onAccountSelected(account: AccountBankModel) {
        self.cryptoTransferViewModel?.currentAccount.value = account
        self.cryptoTransferViewModel?.isTransferInFiat.value = false
    }
}

extension CryptoTransferView: WalletPickerDelegate {
    public func onWalletSelected(wallet: ExternalWalletBankModel) {
        self.cryptoTransferViewModel?.currentExternalWallet = wallet
    }
}

extension CryptoTransferView: UITextFieldDelegate {

    public func textFieldDidChangeSelection(_ textField: UITextField) {

        var amountString = textField.text ?? "0"
        if amountString.contains(".") {

            let leftSide = "0"
            let rightSide = "00"
            let stringParts = amountString.getParts()

            if stringParts[0] == "." {
                amountString = "\(leftSide)\(amountString)"
            }

            if stringParts[stringParts.count - 1] == "." {
                amountString = "\(amountString)\(rightSide)"
            }
        }
        self.cryptoTransferViewModel?.currentAmountInput = amountString
        self.cryptoTransferViewModel?.calculatePreQuote()
    }

    public func textFieldForceUpdate(text: String) {}
}

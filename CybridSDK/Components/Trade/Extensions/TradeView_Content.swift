//
//  Content.swift
//  CybridSDK
//
//  Created by Erick Sanchez on 01/11/23.
//

import UIKit

extension TradeView {

    internal func tradeView_Content() {

        // -- Segment
        let segmentsLabels = [TradeType.buy, TradeType.sell]
        let segments = UISegmentedControl(items: segmentsLabels.map { localizer.localize(with: $0.localizationKey) })
        segments.translatesAutoresizingMaskIntoConstraints = false
        segments.selectedSegmentIndex = 0
        segments.addTarget(tradeViewModel, action: #selector(tradeViewModel.segmentedControlValueChanged(_:)), for: .valueChanged)
        segments.asFirstIn(
            self,
            height: CGFloat(32),
            margins: UIMargins.segmentsMargin)

        // -- From:
        let fromLabel = createSubTitleLabel(Strings.contentFrom)
        fromLabel.addBelow(toItem: segments, height: 16, margins: UIMargins.subTitleFromMargin)

        // -- From UITextField
        self.fromTextField = self.createFromField()
        self.setFromFieldData()
        fromTextField.addBelow(toItem: fromLabel, height: 45, margins: UIMargins.fiatSelectorMargin)

        // -- To:
        let toLabel = createSubTitleLabel(Strings.contentTo)
        toLabel.addBelow(toItem: fromTextField, height: 16, margins: UIMargins.subTitletoMargin)

        // -- To UITextField
        self.toTextField = self.createToField()
        self.setToFieldData()
        toTextField.addBelow(toItem: toLabel, height: 45, margins: UIMargins.cryptoSelectorMargin)

        // -- Amount
        let amount = createSubTitleLabel(Strings.contentAmount)
        amount.addBelow(toItem: toTextField, height: 16, margins: UIMargins.contentAmountMargin)

        // -- Amount UITextField
        let switchButton = self.createSwitchButton()
        switchButton.accessibilityIdentifier = "TradeComponent_SWitchButton"

        self.amountTextField = self.createAmountField(switchButton: switchButton)
        self.amountTextField.accessibilityIdentifier = "TradeComponent_AmountField"
        self.setAmountFieldData()
        self.amountTextField.addBelow(toItem: amount, height: 44, margins: UIMargins.contentAmountFieldMargin)

        // -- Flag, Amount calculated and MAX button
        self.amountPriceLabel = createSubTitleLabel()
        self.maxButton = self.createMaxButton()
        self.flagIcon.addThreeInLine(toItem: self.amountTextField,
                                     width: 28,
                                     height: 24,
                                     margins: UIMargins.contentFlagMargin,
                                     second: self.amountPriceLabel,
                                     secondHeight: 24,
                                     secondMargins: UIMargins.contentPriceLabelMargin,
                                     third: maxButton,
                                     thirdWidth: 40,
                                     thirdHeight: 24,
                                     thirdMargins: UIMargins.contentMaxButtonMargin)
        self.setAmountPriceData()

        // -- Action button part 1
        self.actionButton = CYBButton(
            title: localizer.localize(with: CybridLocalizationKey.trade(.buy(.cta))),
            action: { [weak self] in

                self?.tradeViewModel.createQuote()
                let modal = TradeModal(tradeViewModel: (self?.tradeViewModel)!)
                modal.disableDismiss = true
                modal.present()
            })
        self.actionButton.accessibilityIdentifier = "TradeComponent_ActionButton"

        // -- Error
        let errorLabel = createSubTitleLabel(Strings.contentErrorLabel)
        errorLabel.textColor = UIColor(hex: "#E91E26")
        errorLabel.addBelow(toItem: amountPriceLabel, height: UIValues.errorLabelHeight, margins: UIMargins.contentErrorLabelMargin)
        errorLabel.isHidden = !self.tradeViewModel.currentAmountWithPriceError.value
        self.tradeViewModel.currentAmountWithPriceError.bind { value in

            errorLabel.isHidden = !value
            self.actionButton.isHidden = value
        }

        // -- Action button part 2
        self.actionButton.addBelow(toItem: errorLabel, height: 48, margins: UIMargins.contentActionButton)

        // -- View Binds
        self.setViewBinds()
    }
}

extension TradeView: UIPickerViewDelegate, UIPickerViewDataSource {

    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {

        if pickerView.accessibilityIdentifier == "fiatPicker" {
            return self.tradeViewModel.fiatAccounts.count
        } else {
            return self.tradeViewModel.tradingAccounts.count
        }
    }

    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

        let account: AccountAssetUIModel!
        if pickerView.accessibilityIdentifier == "fiatPicker" {
            account = self.tradeViewModel.fiatAccounts[row]
        } else {
            account = self.tradeViewModel.tradingAccounts[row]
        }

        let name = account.asset.name
        return "\(name) - \(account.balanceFormatted)"
    }

    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

        if pickerView.accessibilityIdentifier == "fiatPicker" {
            self.tradeViewModel.currentCounterAsset.value = self.tradeViewModel.fiatAccounts[row].asset
        } else {
            self.tradeViewModel.currentAsset.value = self.tradeViewModel.tradingAccounts[row].asset
            self.tradeViewModel.currentAccountToTrade.value = self.tradeViewModel.tradingAccounts.first(where: {
                $0.asset.code == self.tradeViewModel.currentAsset.value?.code
            })
            self.tradeViewModel.currentAccountCounterToTrade.value = self.tradeViewModel.fiatAccounts.first(where: {
                $0.asset.code == self.tradeViewModel.currentCounterAsset.value?.code
            })
        }
    }
}

extension TradeView: UITextFieldDelegate {

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
        self.tradeViewModel.currentAmountInput = amountString
        self.tradeViewModel.calculatePreQuote()
    }

    public func textFieldForceUpdate(text: String) {}
}

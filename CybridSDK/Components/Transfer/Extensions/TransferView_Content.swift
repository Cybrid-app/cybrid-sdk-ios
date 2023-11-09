//
//  TransferView_Content.swift
//  CybridSDK
//
//  Created by Erick Sanchez on 06/11/23.
//

import UIKit

extension TransferView {

    internal func transferView_Content() {

        // -- ErrorView
        self.errorMessageView.backgroundColor = UIColor.red
        self.errorMessageView.textColor = UIColor.white
        self.errorMessageView.font = UIFont.systemFont(ofSize: 14)
        self.errorMessageView.textAlignment = .center
        self.errorMessageView.numberOfLines = 0
        self.addSubview(self.errorMessageView)
        self.errorMessageView.constraintSafeTop(self, margin: 0)
        self.errorMessageView.constraintLeft(self, margin: 10)
        self.errorMessageView.constraintRight(self, margin: 10)
        self.errorMessageView.constraintHeight(28)
        self.errorMessageView.isHidden = true
        self.transferViewModel.errorMessage.bind { error in
            if error {
                self.errorMessageView.isHidden = false
                self.errorMessageView.text = self.localizer.localize(with: "cybrid.transfer.errorMessage.text")
            }
        }

        // -- Title
        let title = UILabel()
        title.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.sizeToFit()
        title.font = UIValues.accountsTitleFont
        title.textColor = UIValues.accountsTitleColor
        title.textAlignment = .center
        title.setLocalizedText(key: UIStrings.accountsTitleText, localizer: localizer)
        title.addBelow(toItem: self.errorMessageView, height: UIValues.accountsTitleHeight, margins: UIValues.accountsTitleMargin)

        // -- Balance
        let balance = UILabel()
        balance.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        balance.translatesAutoresizingMaskIntoConstraints = false
        balance.accessibilityIdentifier = "TrasnferComponent_Balance"
        balance.sizeToFit()
        balance.font = UIValues.accountsBalanceFont
        balance.textColor = UIColor.black
        balance.textAlignment = .center
        balance.text = self.transferViewModel.fiatBalance.value
        balance.addBelow(toItem: title, height: UIValues.accountsBalanceHeight, margins: UIValues.accountsBalanceMargin)
        self.transferViewModel.fiatBalance.bind { value in
            balance.text = value
        }

        // -- Balance Loader
        let balanceLoader = self.createBalanceLoader()
        balanceLoader.addBelow(toItem: title, height: UIValues.accountsBalanceHeight, margins: UIValues.accountsBalanceMargin)
        balanceLoader.isHidden = true

        // -- Balance and balance loader visivility
        self.transferViewModel.balanceLoading.bind { value in
            
            DispatchQueue.main.async {
                if value == .CONTENT {
                    balance.isHidden = false
                    balanceLoader.isHidden = true
                } else {
                    balance.isHidden = true
                    balanceLoader.isHidden = false
                }
            }
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
        fromToField.accessibilityIdentifier = "TransferComponent_AccountField"
        self.setFromFieldData(field: fromToField)
        fromToField.addBelow(toItem: fromTo, height: UIValues.accountsFromToFieldHeight, margins: UIValues.accountsFromToFieldMargin)

        // -- Amount
        let amount = self.createSubTitleLabel(key: UIStrings.accountsAmountText)
        amount.addBelow(toItem: fromToField, height: UIValues.accountsFromToHeight, margins: UIValues.accountsAmountMargin)

        // -- Amount Field
        self.amountField = self.createAmountField()
        self.amountField.accessibilityIdentifier = "TransferComponent_AmountField"
        self.setAmountFieldData(field: self.amountField)
        self.amountField.addBelow(toItem: amount, height: UIValues.accountsAmountFieldHeight, margins: UIValues.accountsAmountFieldMargin)

        // -- Action button
        let actionButton = CYBButton(
            title: localizer.localize(with: UIStrings.accountsActionButtonText),
            action: { [self] in
                let amount = self.amountField.text ?? ""
                if !amount.isEmpty {
                    transferViewModel.amount = amount
                    transferViewModel.createQuote(amount: amount)
                    let modal = TransferModal(transferViewModel: self.transferViewModel!)
                    modal.present()
                }
            })
        actionButton.addBelow(toItem: amountField, height: 48, margins: UIValues.accountsActionButtonMargin)
    }
}

//
//  TradeViewController+Extensions.swift
//  CybridSDK
//
//  Created by Erick Sanchez Perez on 31/01/23.
//

import Foundation
import UIKit

extension TradeViewController {

    internal func tradeView_Loading() {

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

    internal func tradeView_ListPrices() {

        let listPricesView = ListPricesView()
        let listPricesViewModel = ListPricesViewModel(cellProvider: listPricesView,
                                                      dataProvider: CybridSession.current,
                                                      logger: Cybrid.logger,
                                                      taskScheduler: self.pricesScheduler)

        listPricesView.setViewModel(listPricesViewModel: listPricesViewModel)
        listPricesView.itemDelegate = tradeViewModel
        tradeViewModel.listPricesViewModel = listPricesViewModel

        let listPricesViewContainer = UIView()
        self.componentContent.addSubview(listPricesViewContainer)
        listPricesViewContainer.constraint(attribute: .top,
                                  relatedBy: .equal,
                                  toItem: self.componentContent,
                                  attribute: .top)
        listPricesViewContainer.constraint(attribute: .leading,
                                  relatedBy: .equal,
                                  toItem: self.componentContent,
                                  attribute: .leading)
        listPricesViewContainer.constraint(attribute: .trailing,
                                  relatedBy: .equal,
                                  toItem: self.componentContent,
                                  attribute: .trailing)
        listPricesViewContainer.constraint(attribute: .bottom,
                                  relatedBy: .equal,
                                  toItem: self.componentContent,
                                  attribute: .bottom)
        listPricesView.embed(in: listPricesViewContainer)
    }

    internal func tradeView_Content() {

        // -- Segment
        let segmentsLabels = [_TradeType.buy, _TradeType.sell]
        let segments = UISegmentedControl(items: segmentsLabels.map { localizer.localize(with: $0.localizationKey) })
        segments.translatesAutoresizingMaskIntoConstraints = false
        segments.selectedSegmentIndex = 0
        segments.addTarget(tradeViewModel, action: #selector(tradeViewModel.segmentedControlValueChanged(_:)), for: .valueChanged)
        segments.asFirstIn(
            self.componentContent,
            height: CGFloat(32),
            margins: UIMargins.segmentsMargin)

        // -- From:
        let fromLabel = createSubTitleLabel(UIStrings.contentFrom)
        fromLabel.addBelow(toItem: segments, height: 16, margins: UIMargins.subTitleFromMargin)

        // -- From UITextField
        self.fromTextField = self.createFromField()
        self.setFromFieldData()
        fromTextField.addBelow(toItem: fromLabel, height: 45, margins: UIMargins.fiatSelectorMargin)

        // -- To:
        let toLabel = createSubTitleLabel(UIStrings.contentTo)
        toLabel.addBelow(toItem: fromTextField, height: 16, margins: UIMargins.subTitletoMargin)

        // -- To UITextField
        self.toTextField = self.createToField()
        self.setToFieldData()
        toTextField.addBelow(toItem: toLabel, height: 45, margins: UIMargins.cryptoSelectorMargin)

        // -- Amount
        let amount = createSubTitleLabel(UIStrings.contentAmount)
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
        let errorLabel = createSubTitleLabel(UIStrings.contentErrorLabel)
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

extension TradeViewController {

    func createSubTitleLabel(_ key: String? = nil) -> UILabel {

        let view = UILabel()
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        view.sizeToFit()
        view.font = UIValues.subTitleFont
        view.textColor = UIValues.subTitleColor
        if key != nil {
            view.setLocalizedText(key: key!, localizer: localizer)
        }
        return view
    }

    func createFromField() -> CYBTextField {

        let fromTextField = CYBTextField(style: .rounded, icon: .urlImage(""), theme: theme)
        fromTextField.accessibilityIdentifier = "fiatPickerTextField"
        fromTextField.tintColor = UIColor.clear
        self.fiatPickerView.delegate = self
        self.fiatPickerView.dataSource = self
        self.fiatPickerView.accessibilityIdentifier = "fiatPicker"
        if self.tradeViewModel.fiatAccounts.count > 1 {
            fromTextField.inputView = self.fiatPickerView
        }
        return fromTextField
    }

    func setFromFieldData() {

        let pairAsset = self.tradeViewModel.currentCounterAsset.value
        let pairAssetAccount = self.tradeViewModel.fiatAccounts.first(where: {
            $0.asset.code == pairAsset?.code
        })
        let pairAssetAccountURL = pairAssetAccount?.assetURL ?? ""
        let name = pairAssetAccount?.asset.name ?? ""
        let asset = pairAssetAccount?.account.asset ?? ""
        let balance = pairAssetAccount?.balanceFormatted ?? ""
        let pairAssetAccountText = "\(name)(\(asset)) - \(balance)"

        self.fromTextField.updateIcon(.urlImage(pairAssetAccountURL))
        self.fromTextField.text = pairAssetAccountText
    }

    func createToField() -> CYBTextField {

        let toTextField = CYBTextField(style: .rounded, icon: .urlImage(""), theme: theme)
        toTextField.accessibilityIdentifier = "tradingPickerTextField"
        toTextField.tintColor = UIColor.clear
        self.tradingPickerView.delegate = self
        self.tradingPickerView.dataSource = self
        self.tradingPickerView.accessibilityIdentifier = "tradingPicker"
        toTextField.inputView = self.tradingPickerView
        return toTextField
    }

    func setToFieldData() {

        let asset = self.tradeViewModel.currentAsset.value
        let assetAccount = self.tradeViewModel.tradingAccounts.first(where: {
            $0.asset.code == asset?.code
        })
        let assetAccountURL = assetAccount?.assetURL ?? ""
        let name = assetAccount?.asset.name ?? ""
        let balance = assetAccount?.balanceFormatted ?? ""
        let assetAccountText = "\(name) - \(balance)"

        self.toTextField.updateIcon(.urlImage(assetAccountURL))
        self.toTextField.text = assetAccountText
    }

    func createAmountField(switchButton: UIButton) -> CYBTextField {

        let textField = CYBTextField(style: .plain, icon: .text(""), theme: theme)
        textField.placeholder = "0.0"
        textField.keyboardType = .decimalPad
        textField.delegate = self
        textField.rightView = switchButton
        textField.rightViewMode = .always
        textField.accessibilityIdentifier = "amountTextField"
        return textField
    }

    func setAmountFieldData() {

        let asset = self.tradeViewModel.currentAccountToTrade.value
        self.amountTextField.updateIcon(.text(asset?.asset.code ?? ""))
    }

    func createSwitchButton() -> UIButton {

        let image = UIImage(named: "switchIcon", in: Bundle(for: Self.self), with: nil)
        let switchButton = UIButton(type: .custom)
        switchButton.setImage(image, for: .normal)
        switchButton.addTarget(tradeViewModel, action: #selector(tradeViewModel.switchAction), for: .touchUpInside)
        switchButton.accessibilityIdentifier = "switchButton"

        switchButton.constraint(attribute: .height,
                                relatedBy: .equal,
                                toItem: nil,
                                attribute: .notAnAttribute,
                                constant: UIValues.switchButtonSize.height)
        switchButton.constraint(attribute: .width,
                                relatedBy: .equal,
                                toItem: nil,
                                attribute: .notAnAttribute,
                                constant: UIValues.switchButtonSize.width)
        return switchButton
    }

    func createMaxButton() -> UIButton {

        let textString = localizer.localize(with: UIStrings.maxButtonLabel)
        let button = UIButton()
        button.backgroundColor = UIColor.clear
        button.setTitleColor(UIValues.maxButtonColor, for: .normal)
        button.setTitle(textString, for: .normal)
        button.titleLabel?.font = UIValues.maxButtonFont
        button.accessibilityIdentifier = "TradeComponent_Content_MaxButton"
        button.isHidden = true
        button.addTarget(self.tradeViewModel, action: #selector(self.tradeViewModel.maxButtonClickHandler), for: .touchUpInside)
        return button
    }

    func setAmountPriceData() {

        self.flagIcon.setURL(self.tradeViewModel.currentAccountCounterToTrade.value?.assetURL ?? "")
        self.amountPriceLabel.text = self.tradeViewModel.currentAmountWithPrice.value
    }

    // -- Binds
    func setViewBinds() {

        self.tradeViewModel.currentCounterAsset.bind { [self] _ in

            self.fromTextField.resignFirstResponder()
            self.toTextField.resignFirstResponder()
            self.setFromFieldData()
            self.setToFieldData()
            self.setAmountFieldData()
            self.setAmountPriceData()
        }

        self.tradeViewModel.currentAsset.bind { [self] _ in

            self.fromTextField.resignFirstResponder()
            self.toTextField.resignFirstResponder()
            self.setFromFieldData()
            self.setToFieldData()
            self.setAmountFieldData()
            self.setAmountPriceData()
        }

        self.tradeViewModel.currentAccountToTrade.bind { [self] _ in

            self.setAmountFieldData()
            self.setAmountPriceData()
            self.tradeViewModel.calculatePreQuote()
        }

        self.tradeViewModel.currentAccountCounterToTrade.bind { [self] _ in

            self.setAmountFieldData()
            self.setAmountPriceData()
            self.tradeViewModel.calculatePreQuote()
        }

        self.tradeViewModel.currentAmountWithPrice.bind { [self] _ in
            self.amountPriceLabel.text = self.tradeViewModel.currentAmountWithPrice.value
        }

        self.tradeViewModel.segmentSelection.bind { [self] segment in

            self.tradeViewModel.calculatePreQuote()
            self.actionButton.setTitle(title: localizer.localize(with: segment == .buy ? UIStrings.contentBuyButton : UIStrings.contentSellButton))
        }

        self.tradeViewModel.currentMaxButtonHide.bind { [self] state in
            self.maxButton.isHidden = state
        }

        self.tradeViewModel.currentAmountObservable.bind { [self] value in
            self.amountTextField.text = value
            self.textFieldDidChangeSelection(self.amountTextField)
        }
    }
}

extension TradeViewController: UIPickerViewDelegate, UIPickerViewDataSource {

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

extension TradeViewController: UITextFieldDelegate {

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

extension TradeViewController {

    enum UIValues {

        // -- Sizes
        static let componentTitleSize: CGFloat = 17
        static let componentTitleHeight: CGFloat = 20
        static let componentTitleMargin = UIEdgeInsets(top: 40, left: 10, bottom: 0, right: 10)
        static let componentRequiredButtonsMargin = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: -10)

        static let loadingSpinnerHeight: CGFloat = 30
        static let loadingSpinnerMargin = UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
        static let componentRequiredButtonsHeight: CGFloat = 50
        static let switchButtonSize = CGSize(width: 14, height: 18)
        static let errorLabelHeight: CGFloat = 20

        // -- Colors
        static let componentTitleColor = UIColor.black
        static let subTitleColor = UIColor(hex: "#757575")
        static let maxButtonColor = UIColor(hex: "#007AFF")

        // -- Fonts
        static let componentTitleFont = UIFont.make(ofSize: 17, weight: .bold)
        static let subTitleFont = UIFont.make(ofSize: 13)
        static let maxButtonFont = UIFont.make(ofSize: 15)
    }

    enum UIMargins {

        static let segmentsMargin = UIEdgeInsets(top: 10, left: 13, bottom: 0, right: 13)
        static let subTitleFromMargin = UIEdgeInsets(top: 30, left: 13, bottom: 0, right: 13)
        static let fiatSelectorMargin = UIEdgeInsets(top: 13, left: 13, bottom: 0, right: 13)
        static let subTitletoMargin = UIEdgeInsets(top: 24, left: 13, bottom: 0, right: 13)
        static let cryptoSelectorMargin = UIEdgeInsets(top: 13, left: 13, bottom: 0, right: 13)
        static let contentAmountMargin = UIEdgeInsets(top: 34, left: 13, bottom: 0, right: 13)
        static let contentAmountFieldMargin = UIEdgeInsets(top: 16, left: 13, bottom: 0, right: 13)
        static let contentFlagMargin = UIEdgeInsets(top: 17, left: 13, bottom: 0, right: 0)
        static let contentPriceLabelMargin = UIEdgeInsets(top: 17, left: 6, bottom: 0, right: 5)
        static let contentMaxButtonMargin = UIEdgeInsets(top: 17, left: 0, bottom: 0, right: 14)
        static let contentActionButton = UIEdgeInsets(top: 27, left: 13, bottom: 0, right: 13)
        static let contentErrorLabelMargin = UIEdgeInsets(top: 0, left: 13, bottom: 0, right: 13)
    }

    enum UIStrings {

        static let loadingText = "cybrid.tradeView.loading.title"
        static let contentFrom = "cybrid.tradeView.content.subtitle.from"
        static let contentTo = "cybrid.tradeView.content.subtitle.to"
        static let contentAmount = "cybrid.tradeView.content.subtitle.amount"
        static let contentBuyButton = "cybrid.account.trade.detail.bought"
        static let contentSellButton = "cybrid.account.trade.detail.sold"
        static let contentErrorLabel = "cybrid.tradeView.content.error"
        static let maxButtonLabel = "cybrid.trade.content.maxButton"
    }
}

//
//  TradeView+Extensions.swift
//  CybridSDK
//
//  Created by Erick Sanchez on 01/11/23.
//

import UIKit

extension TradeView {

    internal func tradeView_Loading() {
        let loadingString = self.localizer.localize(with: Strings.loadingTitle)
        self.createLoaderScreen(text: loadingString)
    }

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

        let textString = localizer.localize(with: Strings.maxButtonLabel)
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
            self.actionButton.setTitle(title: localizer.localize(with: segment == .buy ? Strings.contentBuyButton : Strings.contentSellButton))
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

extension TradeView {

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

    enum Strings {

        static let loadingTitle = "cybrid.tradeView.loading.title"
        static let contentFrom = "cybrid.tradeView.content.subtitle.from"
        static let contentTo = "cybrid.tradeView.content.subtitle.to"
        static let contentAmount = "cybrid.tradeView.content.subtitle.amount"
        static let contentBuyButton = "cybrid.account.trade.detail.bought"
        static let contentSellButton = "cybrid.account.trade.detail.sold"
        static let contentErrorLabel = "cybrid.tradeView.content.error"
        static let maxButtonLabel = "cybrid.trade.content.maxButton"
    }
}

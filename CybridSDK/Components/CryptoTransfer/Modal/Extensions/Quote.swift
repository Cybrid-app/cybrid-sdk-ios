//
//  Quote.swift
//  CybridSDK
//
//  Created by Erick Sanchez on 11/10/23.
//

import UIKit

extension CryptoTransferModal {

    internal func cryptoTransferModal_Quote() {

        // --
        let marginHorizontal: CGFloat = 15

        // -- Title
        let title = self.label(
            font: UIFont.make(ofSize: 22),
            color: UIColor.black,
            text: localizer.localize(with: Strings.titleString),
            lineHeight: 1.05,
            aligment: .left)
        self.componentContent.addSubview(title)
        title.constraintLeft(self.componentContent, margin: marginHorizontal)
        title.constraintTop(self.componentContent, margin: 10)
        title.constraintRight(self.componentContent, margin: marginHorizontal)

        // -- Sub
        let sub = self.label(
            font: UIFont.make(ofSize: 14),
            color: UIColor(hex: "#636366"),
            text: localizer.localize(with: Strings.subTitleString),
            lineHeight: 1.14,
            aligment: .left)
        self.componentContent.addSubview(sub)
        sub.constraintLeft(self.componentContent, margin: marginHorizontal)
        sub.below(title, top: 10)
        sub.constraintRight(self.componentContent, margin: marginHorizontal)

        // -- From (Account)
        let account = self.cryptoTransferViewModel.currentAccount.value
        let fromTitle = self.label(
            font: UIFont.make(ofSize: 14),
            color: UIColor(hex: "#424242"),
            text: localizer.localize(with: Strings.from),
            lineHeight: 1.8,
            aligment: .left)
        self.componentContent.addSubview(fromTitle)
        fromTitle.constraintLeft(self.componentContent, margin: marginHorizontal)
        fromTitle.below(sub, top: 25)
        fromTitle.constraintRight(self.componentContent, margin: marginHorizontal)

        let fromValue = AccountView(account: account)
        self.componentContent.addSubview(fromValue)
        fromValue.constraintLeft(self.componentContent, margin: marginHorizontal)
        fromValue.below(fromTitle, top: 10)
        fromValue.constraintRight(self.componentContent, margin: marginHorizontal)

        // -- To (Wallet)
        let wallet = self.cryptoTransferViewModel.currentWallet.value
        let toTitle = self.label(
            font: UIFont.make(ofSize: 14),
            color: UIColor(hex: "#424242"),
            text: localizer.localize(with: Strings.toTitle),
            lineHeight: 1.8,
            aligment: .left)
        self.componentContent.addSubview(toTitle)
        toTitle.constraintLeft(self.componentContent, margin: marginHorizontal)
        toTitle.below(fromValue, top: 20)
        toTitle.constraintRight(self.componentContent, margin: marginHorizontal)

        let toValue = WalletView(wallet: wallet)
        self.componentContent.addSubview(toValue)
        toValue.constraintLeft(self.componentContent, margin: marginHorizontal)
        toValue.below(toTitle, top: 10)
        toValue.constraintRight(self.componentContent, margin: marginHorizontal)

        // -- Amount
        let asset = try? Cybrid.findAsset(code: account?.asset ?? "")
        let amountTitle = self.label(
            font: UIFont.make(ofSize: 14),
            color: UIColor(hex: "#424242"),
            text: localizer.localize(with: Strings.amount),
            lineHeight: 1,
            aligment: .left)
        self.componentContent.addSubview(amountTitle)
        amountTitle.constraintLeft(self.componentContent, margin: marginHorizontal)
        amountTitle.below(toValue, top: 20)
        amountTitle.constraintRight(self.componentContent, margin: marginHorizontal)

        let amount = self.cryptoTransferViewModel.currentQuote.value?.deliverAmount ?? "0"
        let amountDecimal = CDecimal(amount)
        let amountReady = AssetFormatter.forBase(asset!, amount: amountDecimal)
        let amountFormatted = AssetFormatter.format(asset!, amount: amountReady).removeTrailingZeros()
        let amountValue = self.label(
            font: UIFont.make(ofSize: 16),
            color: UIColor.black,
            text: amountFormatted,
            lineHeight: 1,
            aligment: .left)
        self.componentContent.addSubview(amountValue)
        amountValue.constraintLeft(self.componentContent, margin: marginHorizontal)
        amountValue.below(amountTitle, top: 7.5)
        amountValue.constraintRight(self.componentContent, margin: marginHorizontal)

        // -- Transaction Fee
        let feeTitle = self.label(
            font: UIFont.make(ofSize: 14),
            color: UIColor(hex: "#424242"),
            text: localizer.localize(with: Strings.transactionFee),
            lineHeight: 1,
            aligment: .left)
        self.componentContent.addSubview(feeTitle)
        feeTitle.constraintLeft(self.componentContent, margin: marginHorizontal)
        feeTitle.below(amountValue, top: 20)
        feeTitle.constraintRight(self.componentContent, margin: marginHorizontal)

        let fee = self.cryptoTransferViewModel.currentQuote.value?.fee ?? "0"
        let feeDecimal = CDecimal(fee)
        let feeReady = AssetFormatter.forBase(Cybrid.fiat, amount: feeDecimal)
        let feeFormatted = AssetFormatter.format(Cybrid.fiat, amount: feeReady).removeTrailingZeros()
        let feeValue = self.label(
            font: UIFont.make(ofSize: 16),
            color: UIColor.black,
            text: feeFormatted,
            lineHeight: 1,
            aligment: .left)
        self.componentContent.addSubview(feeValue)
        feeValue.constraintLeft(self.componentContent, margin: marginHorizontal)
        feeValue.below(feeTitle, top: 7.5)
        feeValue.constraintRight(self.componentContent, margin: marginHorizontal)

        // -- Network Fee
        let networkFeeTitle = self.label(
            font: UIFont.make(ofSize: 14),
            color: UIColor(hex: "#424242"),
            text: localizer.localize(with: Strings.networkFee),
            lineHeight: 1,
            aligment: .left)
        self.componentContent.addSubview(networkFeeTitle)
        networkFeeTitle.constraintLeft(self.componentContent, margin: marginHorizontal)
        networkFeeTitle.below(feeValue, top: 20)
        networkFeeTitle.constraintRight(self.componentContent, margin: marginHorizontal)

        let networkFeeAsset = try? Cybrid.findAsset(code: self.cryptoTransferViewModel.currentQuote.value?.networkFeeAsset ?? "")
        let networkFee = self.cryptoTransferViewModel.currentQuote.value?.networkFee ?? "0"
        let networkFeeDecimal = CDecimal(networkFee)
        let networkFeeReady = AssetFormatter.forBase(networkFeeAsset!, amount: networkFeeDecimal)
        let networkFeeFormatted = AssetFormatter.format(networkFeeAsset!, amount: networkFeeReady).removeTrailingZeros()
        let networkFeeValue = self.label(
            font: UIFont.make(ofSize: 16),
            color: UIColor.black,
            text: networkFeeFormatted,
            lineHeight: 1,
            aligment: .left)
        self.componentContent.addSubview(networkFeeValue)
        networkFeeValue.constraintLeft(self.componentContent, margin: marginHorizontal)
        networkFeeValue.below(networkFeeTitle, top: 7.5)
        networkFeeValue.constraintRight(self.componentContent, margin: marginHorizontal)

        // -- Continue Button
        let continueButton = CYBButton(
            title: localizer.localize(with: Strings.confirmButton)
        ) {
            self.cryptoTransferViewModel.createTransfer()
        }
        self.componentContent.addSubview(continueButton)
        continueButton.constraintLeft(self.componentContent, margin: marginHorizontal)
        continueButton.below(networkFeeValue, top: 25)
        continueButton.constraintRight(self.componentContent, margin: marginHorizontal)
        continueButton.constraintHeight(50)
    }
}

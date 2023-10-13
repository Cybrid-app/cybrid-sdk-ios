//
//  Quote.swift
//  CybridSDK
//
//  Created by Erick Sanchez on 11/10/23.
//

import UIKit

extension CryptoTransferModal {

    internal func cryptoTransferModal_Quote() {

        // -- Title
        let title = self.label(
            font: UIFont.make(ofSize: 22),
            color: UIColor.black,
            text: "Confirm withdraw",
            lineHeight: 1.05,
            aligment: .left)
        self.componentContent.addSubview(title)
        title.constraintLeft(self.componentContent, margin: 10)
        title.constraintTop(self.componentContent, margin: 10)
        title.constraintRight(self.componentContent, margin: 10)

        // -- Sub
        let sub = self.label(
            font: UIFont.make(ofSize: 13),
            color: UIColor(hex: "#636366"),
            text: "Please confirm the withdrawal details are correct.",
            lineHeight: 1.14,
            aligment: .left)
        self.componentContent.addSubview(sub)
        sub.constraintLeft(self.componentContent, margin: 10)
        sub.below(title, top: 10)
        sub.constraintRight(self.componentContent, margin: 10)

        // -- From
        let fromTitle = self.label(
            font: UIFont.make(ofSize: 12),
            color: UIColor(hex: "#424242"),
            text: "From my account",
            lineHeight: 1.65,
            aligment: .left)
        self.componentContent.addSubview(fromTitle)
        fromTitle.constraintLeft(self.componentContent, margin: 10)
        fromTitle.below(sub, top: 25)
        fromTitle.constraintRight(self.componentContent, margin: 10)

        let account = self.cryptoTransferViewModel.currentAccount.value
        let asset = try? Cybrid.findAsset(code: account?.asset ?? "")
        let assetName = asset?.name ?? ""
        let assetCode = asset?.code ?? ""
        let fromValue = self.label(
            font: UIFont.make(ofSize: 14),
            color: UIColor.black,
            text: "\(assetName) \(assetCode)",
            lineHeight: 0.94,
            aligment: .left)
        self.componentContent.addSubview(fromValue)
        fromValue.constraintLeft(self.componentContent, margin: 10)
        fromValue.below(fromTitle, top: 7.5)
        fromValue.constraintRight(self.componentContent, margin: 10)

        // -- Amount
        let amountTitle = self.label(
            font: UIFont.make(ofSize: 12),
            color: UIColor(hex: "#424242"),
            text: "Amount",
            lineHeight: 1.65,
            aligment: .left)
        self.componentContent.addSubview(amountTitle)
        amountTitle.constraintLeft(self.componentContent, margin: 10)
        amountTitle.below(fromValue, top: 20)
        amountTitle.constraintRight(self.componentContent, margin: 10)

        let amount = self.cryptoTransferViewModel.currentQuote.value?.deliverAmount ?? "0"
        let amountDecimal = CDecimal(amount)
        let amountReady = AssetFormatter.forBase(asset!, amount: amountDecimal)
        let amountFormatted = AssetFormatter.format(asset!, amount: amountReady).removeTrailingZeros()
        let amountValue = self.label(
            font: UIFont.make(ofSize: 14),
            color: UIColor.black,
            text: amountFormatted,
            lineHeight: 0.94,
            aligment: .left)
        self.componentContent.addSubview(amountValue)
        amountValue.constraintLeft(self.componentContent, margin: 10)
        amountValue.below(amountTitle, top: 7.5)
        amountValue.constraintRight(self.componentContent, margin: 10)

        // -- Transaction Fee
        let feeTitle = self.label(
            font: UIFont.make(ofSize: 12),
            color: UIColor(hex: "#424242"),
            text: "Transacion Fee",
            lineHeight: 1.65,
            aligment: .left)
        self.componentContent.addSubview(feeTitle)
        feeTitle.constraintLeft(self.componentContent, margin: 10)
        feeTitle.below(amountValue, top: 20)
        feeTitle.constraintRight(self.componentContent, margin: 10)

        let fee = self.cryptoTransferViewModel.currentQuote.value?.fee ?? "0"
        let feeDecimal = CDecimal(fee)
        let feeReady = AssetFormatter.forBase(Cybrid.fiat, amount: feeDecimal)
        let feeFormatted = AssetFormatter.format(Cybrid.fiat, amount: feeReady).removeTrailingZeros()
        let feeValue = self.label(
            font: UIFont.make(ofSize: 14),
            color: UIColor.black,
            text: feeFormatted,
            lineHeight: 0.94,
            aligment: .left)
        self.componentContent.addSubview(feeValue)
        feeValue.constraintLeft(self.componentContent, margin: 10)
        feeValue.below(feeTitle, top: 7.5)
        feeValue.constraintRight(self.componentContent, margin: 10)

        // -- Network Fee
        let networkFeeTitle = self.label(
            font: UIFont.make(ofSize: 12),
            color: UIColor(hex: "#424242"),
            text: "Network Fee",
            lineHeight: 1.65,
            aligment: .left)
        self.componentContent.addSubview(networkFeeTitle)
        networkFeeTitle.constraintLeft(self.componentContent, margin: 10)
        networkFeeTitle.below(feeValue, top: 20)
        networkFeeTitle.constraintRight(self.componentContent, margin: 10)

        let networkFeeAsset = try? Cybrid.findAsset(code: self.cryptoTransferViewModel.currentQuote.value?.networkFeeAsset ?? "")
        let networkFee = self.cryptoTransferViewModel.currentQuote.value?.networkFee ?? "0"
        let networkFeeDecimal = CDecimal(networkFee)
        let networkFeeReady = AssetFormatter.forBase(networkFeeAsset!, amount: networkFeeDecimal)
        let networkFeeFormatted = AssetFormatter.format(networkFeeAsset!, amount: networkFeeReady).removeTrailingZeros()
        let networkFeeValue = self.label(
            font: UIFont.make(ofSize: 14),
            color: UIColor.black,
            text: networkFeeFormatted,
            lineHeight: 0.94,
            aligment: .left)
        self.componentContent.addSubview(networkFeeValue)
        networkFeeValue.constraintLeft(self.componentContent, margin: 10)
        networkFeeValue.below(networkFeeTitle, top: 7.5)
        networkFeeValue.constraintRight(self.componentContent, margin: 10)

        // -- Continue Button
        let continueButton = CYBButton(
            title: "Confirm"
        ) {
            self.cryptoTransferViewModel.createTransfer()
        }
        self.componentContent.addSubview(continueButton)
        continueButton.constraintLeft(self.componentContent, margin: 10)
        continueButton.below(networkFeeValue, top: 25)
        continueButton.constraintRight(self.componentContent, margin: 10)
        continueButton.constraintHeight(50)
    }
}

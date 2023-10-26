//
//  AccountView.swift
//  CybridSDK
//
//  Created by Erick Sanchez on 25/10/23.
//

import UIKit
import CybridApiBankSwift

public class AccountView: UIView {

    private var heightConstraint: NSLayoutConstraint?
    private var account: AccountBankModel?
    private var fieldContainer = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    @available(iOS, deprecated: 10, message: "You should never use this init method.")
    required init?(coder: NSCoder) {
        assertionFailure("init(coder:) should never be used")
        return nil
    }

    init(account: AccountBankModel?) {

        super.init(frame: CGRect.zero)
        self.account = account
        setupView()
    }

    internal func setupView() {

        self.heightConstraint = self.constraintHeight(52)
        self.createFieldContainer()
        self.createFieldContent(account: self.account)
    }

    internal func createFieldContainer() {

        // -- Field Container
        self.fieldContainer = UIView()
        fieldContainer.backgroundColor = UIColor(hex: "#F5F5F5")
        fieldContainer.layer.cornerRadius = 8
        self.addSubview(fieldContainer)
        fieldContainer.constraintLeft(self, margin: 0)
        fieldContainer.constraintRight(self, margin: 0)
        fieldContainer.constraintTop(self, margin: 0)
        fieldContainer.constraintHeight(52)
    }

    internal func createFieldContent(account: AccountBankModel?) {

        // --
        let assetCode = account?.asset ?? ""

        // -- Icon
        let iconUrl = Cybrid.getAssetURL(with: assetCode)
        let icon = URLImageView(urlString: iconUrl)
        fieldContainer.addSubview(icon!)
        icon?.constraintLeft(fieldContainer, margin: 15)
        icon?.centerVertical(parent: fieldContainer)
        icon?.setConstraintsSize(size: CGSize(width: 28, height: 28))

        // -- Name
        let asset = Cybrid.assets.first(where: { $0.code == assetCode })
        let nameString = asset?.name ?? ""
        let paragraphStyle = getParagraphStyle(1.05)
        paragraphStyle.alignment = .left
        let name = UILabel()
        name.font = UIFont.make(ofSize: 17)
        name.textColor = UIColor.black
        name.setParagraphText(nameString.capitalized, paragraphStyle)
        fieldContainer.addSubview(name)
        name.leftAside(icon!, margin: 15)
        name.centerVertical(parent: fieldContainer)

        // -- Balance
        let balanceValue = BigDecimal(account?.platformBalance ?? "0", precision: asset?.decimals ?? 0) ?? BigDecimal(0)
        let balanceValueFormatted = CybridCurrencyFormatter.formatInputNumber(balanceValue).removeTrailingZeros()

        // -- Code && Balance
        let codeString = assetCode
        let codeAndBalanceString = "\(codeString.uppercased()) - \(balanceValueFormatted)"
        let codeAndBalanceParagraphStyle = getParagraphStyle(1.05)
        codeAndBalanceParagraphStyle.alignment = .left
        let codeAndBalance = UILabel()
        codeAndBalance.font = UIFont.make(ofSize: 16)
        codeAndBalance.textColor = UIColor(hex: "#757575")
        codeAndBalance.setParagraphText(codeAndBalanceString, codeAndBalanceParagraphStyle)
        fieldContainer.addSubview(codeAndBalance)
        codeAndBalance.leftAside(name, margin: 5)
        codeAndBalance.centerVertical(parent: fieldContainer)
    }
}

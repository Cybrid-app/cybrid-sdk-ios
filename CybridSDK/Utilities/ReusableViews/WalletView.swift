//
//  WalletView.swift
//  CybridSDK
//
//  Created by Erick Sanchez on 25/10/23.
//

import UIKit
import CybridApiBankSwift

public class WalletView: UIView {

    private var heightConstraint: NSLayoutConstraint?
    private var wallet: ExternalWalletBankModel?
    private var fieldContainer = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    @available(iOS, deprecated: 10, message: "You should never use this init method.")
    required init?(coder: NSCoder) {
        assertionFailure("init(coder:) should never be used")
        return nil
    }

    init(wallet: ExternalWalletBankModel?) {

        super.init(frame: CGRect.zero)
        self.wallet = wallet
        setupView()
    }

    internal func setupView() {

        self.heightConstraint = self.constraintHeight(52)
        self.createFieldContainer()
        self.createFieldContent(wallet: self.wallet)
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

    internal func createFieldContent(wallet: ExternalWalletBankModel?) {

        // --
        let assetCode = wallet?.asset ?? ""

        // -- Icon
        let iconUrl = Cybrid.getAssetURL(with: assetCode)
        let icon = URLImageView(urlString: iconUrl)
        fieldContainer.addSubview(icon!)
        icon?.constraintLeft(fieldContainer, margin: 15)
        icon?.centerVertical(parent: fieldContainer)
        icon?.setConstraintsSize(size: CGSize(width: 28, height: 28))

        // -- Name
        let nameString = wallet?.name ?? ""
        let paragraphStyle = getParagraphStyle(1.05)
        paragraphStyle.alignment = .left
        let name = UILabel()
        name.font = UIFont.make(ofSize: 17)
        name.textColor = UIColor.black
        name.setParagraphText(nameString.capitalized, paragraphStyle)
        fieldContainer.addSubview(name)
        name.leftAside(icon!, margin: 15)
        name.centerVertical(parent: fieldContainer)
    }
}

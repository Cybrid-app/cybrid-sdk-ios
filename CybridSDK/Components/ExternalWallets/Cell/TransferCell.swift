//
//  TransferCell.swift
//  CybridSDK
//
//  Created by Erick Sanchez on 03/10/23.
//

import CybridApiBankSwift
import UIKit

class TransferCell: UITableViewCell {

    static let reuseIdentifier = "externalWalletTransferCell"
    override var reuseIdentifier: String? { Self.reuseIdentifier }

    private var icon = UIImageView()
    private var type = UILabel()
    private var date = UILabel()
    private var amount = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {

        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    @available(iOS, deprecated: 10, message: "You should never use this init method.")
    required init?(coder: NSCoder) {
        assertionFailure("init(coder:) should never be used")
        return nil
    }

    private func setupViews() {

        // -- Icon
        self.icon = UIImageView(image: getImage("ic_crypto_transfer", aClass: Self.self))
        self.addSubview(icon)
        icon.constraintLeft(self, margin: 0)
        icon.centerVertical(parent: self)
        icon.setConstraintsSize(size: CGSize(width: 26, height: 26))

        // -- Type
        let typeStyle = getParagraphStyle(1.07)
        typeStyle.alignment = .left
        self.type.font = UIFont.make(ofSize: 17)
        self.type.textColor = UIColor.black
        self.type.setParagraphText("Withdraw", typeStyle)
        self.addSubview(self.type)
        self.type.leftAside(icon, margin: 15)
        self.type.constraintTop(self, margin: 5.5)

        // -- Date
        let dateStyle = getParagraphStyle(1.07)
        dateStyle.alignment = .left
        self.date.font = UIFont.make(ofSize: 16)
        self.date.textColor = UIColor(hex: "#636366")
        self.date.setParagraphText("", dateStyle)
        self.addSubview(self.date)
        self.date.leftAside(icon, margin: 15)
        self.date.below(type, top: 5)

        // -- Amount
        self.addSubview(self.amount)
        self.amount.constraintRight(self, margin: 0)
        self.amount.centerVertical(parent: self)
    }

    func setData(_ transfer: TransferBankModel) {

        // -- Date
        let dateInFormat = getFormattedDate(transfer.createdAt, format: "MMM dd, YYYY")
        self.date.text = dateInFormat

        // -- Asset
        guard let asset = try? Cybrid.findAsset(code: transfer.asset ?? "")
        else { return }

        // -- Amount
        let amountCD = CDecimal(transfer.amount ?? 0)
        let amountInAsset = AssetFormatter.forBase(asset, amount: amountCD).removeTrailingZeros()
        self.amount.setAttributedText(
            mainText: amountInAsset,
            mainTextFont: UIFont.make(ofSize: 16),
            mainTextColor: UIColor.black,
            attributedText: asset.code,
            attributedTextFont: UIFont.make(ofSize: 14),
            attributedTextColor: UIColor(hex: "#636366"),
            side: .left)
    }
}

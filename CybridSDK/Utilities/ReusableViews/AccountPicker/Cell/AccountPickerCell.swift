//
//  AccountPickerCell.swift
//  CybridSDK
//
//  Created by Erick Sanchez on 19/09/23.
//

import CybridApiBankSwift
import UIKit

class AccountPickerCell: UITableViewCell {

    static let reuseIdentifier = "accountPickerCell"
    override var reuseIdentifier: String? { Self.reuseIdentifier }

    private var icon = URLImageView(url: nil)
    private var name = UILabel()
    private var codeAndBalance = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    @available(iOS, deprecated: 10, message: "You should never use this init method.")
    required init?(coder: NSCoder) {
        assertionFailure("init(coder:) should never be used")
        return nil
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    private func setupViews() {

        // -- Icon
        self.addSubview(icon)
        icon.constraintLeft(self, margin: 10)
        icon.centerVertical(parent: self)
        icon.setConstraintsSize(size: CGSize(width: 28, height: 28))

        // -- Name
        self.name = UILabel()
        name.font = UIFont.make(ofSize: 17)
        name.textColor = UIColor.black
        self.addSubview(name)
        name.leftAside(icon, margin: 15)
        name.centerVertical(parent: self)

        // -- Code && Balance
        self.codeAndBalance = UILabel()
        codeAndBalance.font = UIFont.make(ofSize: 16)
        codeAndBalance.textColor = UIColor(hex: "#757575")
        self.addSubview(codeAndBalance)
        codeAndBalance.leftAside(name, margin: 5)
        codeAndBalance.centerVertical(parent: self)
    }

    func setData(account: AccountBankModel) {

        // -- Icon
        let iconUrl = Cybrid.getAssetURL(with: account.asset!)
        self.icon.setURL(iconUrl)

        // -- Name
        let asset = Cybrid.assets.first(where: { $0.code == account.asset! })
        let nameString = asset?.name ?? ""
        let paragraphStyle = getParagraphStyle(1.05)
        paragraphStyle.alignment = .left
        self.name.setParagraphText(nameString, paragraphStyle)

        // -- Balance
        let balanceValue = BigDecimal(account.platformBalance ?? "0", precision: asset?.decimals ?? 0) ?? BigDecimal(0)
        let balanceValueFormatted = CybridCurrencyFormatter.formatInputNumber(balanceValue).removeTrailingZeros()

        // -- Code && Balance
        let codeString = account.asset ?? ""
        let codeAndBalanceString = "\(codeString.uppercased()) - \(balanceValueFormatted)"
        let codeAndBalanceParagraphStyle = getParagraphStyle(1.05)
        codeAndBalanceParagraphStyle.alignment = .left
        self.codeAndBalance.setParagraphText(codeAndBalanceString, codeAndBalanceParagraphStyle)
    }
}

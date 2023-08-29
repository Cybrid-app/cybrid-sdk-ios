//
//  AssetPickerCell.swift
//  CybridSDK
//
//  Created by Erick Sanchez on 22/08/23.
//

import CybridApiBankSwift
import UIKit

class AssetPickerCell: UITableViewCell {

    static let reuseIdentifier = "assetPickerCell"
    override var reuseIdentifier: String? { Self.reuseIdentifier }

    private var icon = URLImageView(url: nil)
    private var name = UILabel()

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
        name.constraintRight(self, margin: 10)
        name.centerVertical(parent: self)
    }

    func setData(asset: AssetBankModel) {

        // -- Icon
        let iconUrl = Cybrid.getAssetURL(with: asset.code)
        self.icon.setURL(iconUrl)

        // -- Name
        let paragraphStyle = getParagraphStyle(1.05)
        paragraphStyle.alignment = .left
        self.name.setParagraphText(asset.name.capitalized, paragraphStyle)
    }
}

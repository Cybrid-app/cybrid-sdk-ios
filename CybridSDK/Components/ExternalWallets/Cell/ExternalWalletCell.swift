//
//  ExternalWalletCell.swift
//  CybridSDK
//
//  Created by Erick Sanchez on 21/08/23.
//

import CybridApiBankSwift
import UIKit

class ExternalWalletCell: UITableViewCell {

    static let reuseIdentifier = "externalWalletCell"
    override var reuseIdentifier: String? { Self.reuseIdentifier }

    private var icon = URLImageView(url: nil)
    private var name = UILabel()
    private var statusChip = UILabel()

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
        icon.constraintLeft(self, margin: 7.5)
        icon.centerVertical(parent: self)
        icon.setConstraintsSize(size: CGSize(width: 28, height: 28))

        // -- Status chip
        self.statusChip = UILabel()
        self.statusChip.layer.masksToBounds = true
        self.statusChip.layer.cornerRadius = CGFloat(10)
        self.statusChip.setContentHuggingPriority(.required, for: .horizontal)
        self.statusChip.translatesAutoresizingMaskIntoConstraints = false
        self.statusChip.font = UIFont.make(ofSize: 12)
        self.statusChip.textAlignment = .center
        self.addSubview(self.statusChip)
        self.statusChip.centerVertical(parent: self)
        self.statusChip.constraintRight(self, margin: 7.5)
        self.statusChip.setConstraintsSize(size: CGSize(width: 80, height: 24))

        // -- Name
        self.name = UILabel()
        self.addSubview(name)
        name.leftAside(icon, margin: 15)
        name.rightAside(statusChip, margin: 15)
        name.centerVertical(parent: self)
    }

    func setData(wallet: ExternalWalletBankModel) {

        // -- Asset
        let asset = try? Cybrid.findAsset(code: wallet.asset!)

        // -- Icon
        let iconUrl = Cybrid.getAssetURL(with: asset?.code ?? "")
        self.icon.setURL(iconUrl)

        // -- Name
        let nameString = wallet.name ?? ""
        let codeString = asset?.code ?? ""
        self.name.setAttributedText(
            mainText: nameString,
            mainTextFont: UIFont.make(ofSize: 17),
            mainTextColor: UIColor.black,
            attributedText: codeString,
            attributedTextFont: UIFont.make(ofSize: 12.5, weight: .medium),
            attributedTextColor: UIColor(hex: "#8a8a8d"),
            side: .left)

        // -- Status chip
        // let localizer = CybridLocalizer()
        switch wallet.state {
        case .storing, .pending:

            self.statusChip.isHidden = false
            self.statusChip.textColor = UIColor.black
            self.statusChip.backgroundColor = UIColor(hex: "#FCDA66")
            self.statusChip.text = "Pending"
            // self.statusChip.setLocalizedText(key: UIString.transferPending, localizer: localizer)

        case .failed:

            self.statusChip.isHidden = false
            self.statusChip.textColor = UIColor.white
            self.statusChip.backgroundColor = UIColor(hex: "#D45736")
            self.statusChip.text = "Failed"
            // self.statusChip.setLocalizedText(key: UIString.transferFailed, localizer: localizer)

        case .completed:
            self.statusChip.isHidden = false
            self.statusChip.textColor = UIColor.white
            self.statusChip.backgroundColor = UIColor(hex: "#4dae51")
            self.statusChip.text = "Approved"

        default:
            self.statusChip.isHidden = true
        }
        self.statusChip.layoutSubviews()
    }
}

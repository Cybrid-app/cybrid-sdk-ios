//
//  BankAccountCell.swift
//  CybridSDK
//
//  Created by Erick Sanchez Perez on 20/02/23.
//

import CybridApiBankSwift
import Foundation
import UIKit

class BankAccountCell: UITableViewCell {

    static let reuseIdentifier = "bankAccountsCell"
    override var reuseIdentifier: String? { Self.reuseIdentifier }

    private var accountIcon = UIImageView()
    private var accountName = UILabel()

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
        self.accountIcon.translatesAutoresizingMaskIntoConstraints = false
        self.accountIcon.image = UIImage(named: "test_bank", in: Bundle(for: Self.self), with: nil)!
        self.addSubview(self.accountIcon)
        self.accountIcon.constraint(attribute: .leading,
                                    relatedBy: .equal,
                                    toItem: self,
                                    attribute: .leading,
                                    constant: 16)
        self.accountIcon.constraint(attribute: .centerY,
                                    relatedBy: .equal,
                                    toItem: self,
                                    attribute: .centerY)
        self.accountIcon.constraint(attribute: .height,
                                    relatedBy: .equal,
                                    toItem: nil,
                                    attribute: .notAnAttribute,
                                    constant: UIValues.iconSize.width)
        self.accountIcon.constraint(attribute: .width,
                                    relatedBy: .equal,
                                    toItem: nil,
                                    attribute: .notAnAttribute,
                                    constant: UIValues.iconSize.height)

        // -- Account name label
        self.accountName.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        self.accountName.translatesAutoresizingMaskIntoConstraints = false
        self.accountName.sizeToFit()
        self.accountName.font = UIValues.nameAccountFont
        self.accountName.textColor = UIValues.nameAccountColor
        self.accountName.textAlignment = .left

        self.addSubview(self.accountName)
        accountName.constraint(attribute: .leading,
                               relatedBy: .equal,
                               toItem: self.accountIcon,
                               attribute: .trailing,
                               constant: 15)
        accountName.constraint(attribute: .centerY,
                               relatedBy: .equal,
                               toItem: self,
                               attribute: .centerY)
        accountName.constraint(attribute: .trailing,
                               relatedBy: .equal,
                               toItem: self,
                               attribute: .trailing,
                               constant: 10)
        accountName.constraint(attribute: .height,
                               relatedBy: .equal,
                               toItem: nil,
                               attribute: .notAnAttribute,
                               constant: UIValues.iconSize.width)
    }

    func setData(account: ExternalBankAccountBankModel) {

        if account.state == .refreshRequired {
            self.accountIcon.image = UIImage(named: "kyc_error", in: Bundle(for: Self.self), with: nil)!
        }

        let accountMask = account.plaidAccountMask ?? ""
        let accountName = account.plaidAccountName ?? ""
        let accountID = account.plaidInstitutionId ?? ""
        let name = "\(accountID) - \(accountName) (\(accountMask))"
        self.accountName.text = name
    }
}

extension BankAccountCell {

    enum UIValues {

        // -- Sizes
        static let iconSize = CGSize(width: 27, height: 27)

        // -- Fonts
        static let nameAccountFont = UIFont.make(ofSize: 17)

        // -- Colors
        static let nameAccountColor = UIColor.black
    }
}

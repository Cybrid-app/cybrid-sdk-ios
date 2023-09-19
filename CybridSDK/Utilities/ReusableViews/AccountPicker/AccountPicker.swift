//
//  AccountPicker.swift
//  CybridSDK
//
//  Created by Erick Sanchez on 19/09/23.
//

import UIKit
import CybridApiBankSwift

public protocol AccountPickerDelegate: AnyObject {
    func onAccountSelected(account: AccountBankModel)
}

public class AccountPicker: UIView {

    private var heightConstraint: NSLayoutConstraint?
    private var listItemsHeightConstraint: NSLayoutConstraint?
    private var isOpen = false
    private var accounts: [AccountBankModel] = []
    public var accountSelected: AccountBankModel?
    weak var delegate: AccountPickerDelegate?

    private var fieldContainer = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    @available(iOS, deprecated: 10, message: "You should never use this init method.")
    required init?(coder: NSCoder) {
        assertionFailure("init(coder:) should never be used")
        return nil
    }

    init(accounts: [AccountBankModel], delegate: AccountPickerDelegate? = nil) {

        super.init(frame: CGRect.zero)
        self.accounts = accounts
        if !self.accounts.isEmpty {
            self.accounts = self.accounts.filter { $0.type == .trading }
            self.accounts = self.accounts.sorted(by: {
                $0.asset! < $1.asset!
            })
        }
        self.delegate = delegate
        setupView()
    }

    internal func setupView() {

        self.heightConstraint = self.constraintHeight(52)
        self.createFieldContainer()

        if !self.accounts.isEmpty {

            let account = self.accounts.first
            self.createFieldContent(account: account!)
            self.createListItems()
        }
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

        // -- Click action
        self.fieldContainer.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(fieldContainerAction))
        self.fieldContainer.addGestureRecognizer(tapGesture)
    }

    internal func createFieldContent(account: AccountBankModel) {

        // --
        self.accountSelected = account

        // -- Removing prev
        for view in self.fieldContainer.subviews {
            view.removeFromSuperview()
        }

        // -- Add new
        // -- Icon
        let iconUrl = Cybrid.getAssetURL(with: account.asset!)
        let icon = URLImageView(urlString: iconUrl)
        fieldContainer.addSubview(icon!)
        icon?.constraintLeft(fieldContainer, margin: 10)
        icon?.centerVertical(parent: fieldContainer)
        icon?.setConstraintsSize(size: CGSize(width: 28, height: 28))

        // -- Name
        let asset = Cybrid.assets.first(where: { $0.code == account.asset! })
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
        let balanceValue = BigDecimal(account.platformBalance ?? "0", precision: asset?.decimals ?? 0) ?? BigDecimal(0)
        let balanceValueFormatted = CybridCurrencyFormatter.formatInputNumber(balanceValue).removeTrailingZeros()

        // -- Code && Balance
        let codeString = account.asset ?? ""
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

    internal func createListItems() {

        // -- Table
        let listItems = UITableView()
        listItems.delegate = self
        listItems.dataSource = self
        listItems.alwaysBounceVertical = true
        listItems.flashScrollIndicators()
        listItems.register(AccountPickerCell.self, forCellReuseIdentifier: AccountPickerCell.reuseIdentifier)
        listItems.backgroundColor = UIColor.white
        self.addSubview(listItems)
        listItems.below(self.fieldContainer, top: 7) // h:60
        listItems.constraintLeft(self, margin: 0)
        listItems.constraintRight(self, margin: 0)
        self.listItemsHeightConstraint = listItems.constraintHeight(0)
    }

    // MARK: View Click Actions
    @objc func fieldContainerAction() {

        if isOpen {
            self.close()
        } else {
            self.open()
        }
    }

    // MARK: Close/Open
    internal func open() {

        self.isOpen = !self.isOpen
        self.heightConstraint?.constant = 210
        self.listItemsHeightConstraint?.constant = 150
    }

    internal func close() {

        self.isOpen = !self.isOpen
        self.heightConstraint?.constant = 52
        self.listItemsHeightConstraint?.constant = 0
    }
}

extension AccountPicker: UITableViewDelegate, UITableViewDataSource {

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.accounts.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let account = self.accounts[indexPath.row]
        guard
            let cell = tableView.dequeueReusableCell(
                withIdentifier: AccountPickerCell.reuseIdentifier,
                for: indexPath) as? AccountPickerCell
        else {
            return UITableViewCell()
        }
        cell.setData(account: account)
        return cell
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let account = self.accounts[indexPath.row]
        self.createFieldContent(account: account)
        self.close()
        self.delegate?.onAccountSelected(account: account)
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52
    }
}

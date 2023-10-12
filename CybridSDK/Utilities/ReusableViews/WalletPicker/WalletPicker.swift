//
//  WalletPicker.swift
//  CybridSDK
//
//  Created by Erick Sanchez on 19/09/23.
//

import UIKit
import CybridApiBankSwift

public protocol WalletPickerDelegate: AnyObject {
    func onWalletSelected(wallet: ExternalWalletBankModel)
}

public class WalletPicker: UIView {

    private var heightConstraint: NSLayoutConstraint?
    private var listItemsHeightConstraint: NSLayoutConstraint?
    private var isOpen = false
    private var originalWallets: [ExternalWalletBankModel] = []
    private var wallets: [ExternalWalletBankModel] = []
    public var walletSelected: ExternalWalletBankModel?
    weak var delegate: WalletPickerDelegate?

    private var fieldContainer = UIView()
    let listItems = UITableView()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    @available(iOS, deprecated: 10, message: "You should never use this init method.")
    required init?(coder: NSCoder) {
        assertionFailure("init(coder:) should never be used")
        return nil
    }

    init(
        wallets: [ExternalWalletBankModel],
        asset: String,
        delegate: WalletPickerDelegate? = nil) {

        super.init(frame: CGRect.zero)
        self.originalWallets = wallets
        self.getWalletsByAsset(asset: asset, change: false)
        self.delegate = delegate
        setupView()
    }

    func getWalletsByAsset(asset: String, change: Bool = true) {

        if !self.originalWallets.isEmpty {
            self.wallets = []
            self.wallets = self.originalWallets.filter { $0.asset == asset }
            self.wallets = self.wallets.sorted(by: {
                $0.name! < $1.name!
            })
        }

        if change {

            self.listItems.reloadData()
            self.createFieldContent(wallet: !self.wallets.isEmpty ? self.wallets.first : nil)
        }
    }

    internal func setupView() {

        self.heightConstraint = self.constraintHeight(52)
        self.createFieldContainer()

        if !self.wallets.isEmpty {

            let wallet = self.wallets.first
            self.createFieldContent(wallet: wallet!)
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

    internal func createFieldContent(wallet: ExternalWalletBankModel?) {

        // --
        self.walletSelected = wallet

        // -- Removing prev
        for view in self.fieldContainer.subviews {
            view.removeFromSuperview()
        }

        if let wallet {

            // -- Add new
            // -- Icon
            let iconUrl = Cybrid.getAssetURL(with: wallet.asset!)
            let icon = URLImageView(urlString: iconUrl)
            fieldContainer.addSubview(icon!)
            icon?.constraintLeft(fieldContainer, margin: 10)
            icon?.centerVertical(parent: fieldContainer)
            icon?.setConstraintsSize(size: CGSize(width: 28, height: 28))

            // -- Name
            let nameString = wallet.name ?? ""
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

    internal func createListItems() {

        // -- Table
        listItems.delegate = self
        listItems.dataSource = self
        listItems.alwaysBounceVertical = true
        listItems.flashScrollIndicators()
        listItems.register(WalletPickerCell.self, forCellReuseIdentifier: WalletPickerCell.reuseIdentifier)
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
            if !self.wallets.isEmpty {
                self.open()
            }
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

extension WalletPicker: UITableViewDelegate, UITableViewDataSource {

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.wallets.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let wallet = self.wallets[indexPath.row]
        guard
            let cell = tableView.dequeueReusableCell(
                withIdentifier: WalletPickerCell.reuseIdentifier,
                for: indexPath) as? WalletPickerCell
        else {
            return UITableViewCell()
        }
        cell.setData(wallet: wallet)
        return cell
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let wallet = self.wallets[indexPath.row]
        self.createFieldContent(wallet: wallet)
        self.close()
        self.delegate?.onWalletSelected(wallet: wallet)
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52
    }
}

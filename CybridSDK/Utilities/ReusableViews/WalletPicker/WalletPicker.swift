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
    private var wallets: Observable<[ExternalWalletBankModel]> = .init([])
    private var filterWallets: [ExternalWalletBankModel] = []
    private var currentWallet: Observable<ExternalWalletBankModel?> = .init(nil)
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
        wallets: Observable<[ExternalWalletBankModel]>,
        currentWallet: Observable<ExternalWalletBankModel?>,
        delegate: WalletPickerDelegate? = nil
    ) {

        super.init(frame: CGRect.zero)
        self.wallets = wallets
        self.currentWallet = currentWallet
        self.delegate = delegate
        setupView()
    }

    internal func setupView() {

        self.heightConstraint = self.constraintHeight(52)
        self.createFieldContainer()
        if !self.wallets.value.isEmpty {
            self.currentWallet.bind { wallet in
                self.createFieldContent(wallet: wallet)
                self.createListItems()
            }
        }
        self.close()
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

        // -- Filter wallets without currentAccount
        self.filterWallets = []
        self.filterWallets = self.wallets.value.filter { wallet in
            return wallet.guid != currentWallet.value?.guid
        }
        listItems.reloadData()
    }

    // MARK: View Click Actions
    @objc func fieldContainerAction() {

        if isOpen {
            self.close()
        } else {
            if !self.wallets.value.isEmpty && self.wallets.value.count > 1 {
                self.open()
            }
        }
    }

    // MARK: Close/Open
    internal func open() {

        self.isOpen = true
        self.heightConstraint?.constant = 210
        self.listItemsHeightConstraint?.constant = 150
    }

    internal func close() {

        self.isOpen = false
        self.heightConstraint?.constant = 52
        self.listItemsHeightConstraint?.constant = 0
    }
}

extension WalletPicker: UITableViewDelegate, UITableViewDataSource {

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filterWallets.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let wallet = self.filterWallets[indexPath.row]
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

        let wallet = self.filterWallets[indexPath.row]
        self.delegate?.onWalletSelected(wallet: wallet)
        self.close()
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52
    }
}

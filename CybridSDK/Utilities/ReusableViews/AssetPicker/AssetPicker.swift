//
//  AssetPicker.swift
//  CybridSDK
//
//  Created by Erick Sanchez on 22/08/23.
//

import UIKit
import CybridApiBankSwift

public class AssetPicker: UIView {

    private var heightConstraint: NSLayoutConstraint?
    private var listItemsHeightConstraint: NSLayoutConstraint?
    private var isOpen = false
    private var assets: [AssetBankModel] = []
    public var assetSelected: AssetBankModel?

    private var fieldContainer = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    @available(iOS, deprecated: 10, message: "You should never use this init method.")
    required init?(coder: NSCoder) {

        assertionFailure("init(coder:) should never be used")
        return nil
    }

    init(assets: [AssetBankModel]) {

        super.init(frame: CGRect.zero)
        self.assets = assets
        if !self.assets.isEmpty {
            self.assets = self.assets.filter { $0.type == "crypto" }
            self.assets = self.assets.sorted(by: { $0.name < $1.name })
        }
        setupView()
    }

    internal func setupView() {

        self.heightConstraint = self.constraintHeight(52)
        self.createFieldContainer()

        if !self.assets.isEmpty {

            let asset = self.assets.first
            self.createFieldContent(asset: asset!)
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

    internal func createFieldContent(asset: AssetBankModel) {

        // --
        self.assetSelected = asset

        // -- Removing prev
        for view in self.fieldContainer.subviews {
            view.removeFromSuperview()
        }

        // -- Add new
        // -- Icon
        let iconUrl = Cybrid.getAssetURL(with: asset.code)
        let icon = URLImageView(urlString: iconUrl)
        fieldContainer.addSubview(icon!)
        icon?.constraintLeft(fieldContainer, margin: 10)
        icon?.centerVertical(parent: fieldContainer)
        icon?.setConstraintsSize(size: CGSize(width: 28, height: 28))

        // -- Name
        let paragraphStyle = getParagraphStyle(1.05)
        paragraphStyle.alignment = .left
        let name = UILabel()
        name.font = UIFont.make(ofSize: 17)
        name.textColor = UIColor.black
        name.setParagraphText(asset.name.capitalized, paragraphStyle)
        fieldContainer.addSubview(name)
        name.leftAside(icon!, margin: 15)
        name.constraintRight(fieldContainer, margin: 10)
        name.centerVertical(parent: fieldContainer)
    }

    internal func createListItems() {

        // -- Table
        let listItems = UITableView()
        listItems.delegate = self
        listItems.dataSource = self
        listItems.alwaysBounceVertical = true
        listItems.flashScrollIndicators()
        listItems.register(AssetPickerCell.self, forCellReuseIdentifier: AssetPickerCell.reuseIdentifier)
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

extension AssetPicker: UITableViewDelegate, UITableViewDataSource {

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.assets.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let asset = self.assets[indexPath.row]
        guard
            let cell = tableView.dequeueReusableCell(
                withIdentifier: AssetPickerCell.reuseIdentifier,
                for: indexPath) as? AssetPickerCell
        else {
            return UITableViewCell()
        }
        cell.setData(asset: asset)
        return cell
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let asset = self.assets[indexPath.row]
        self.createFieldContent(asset: asset)
        self.close()
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52
    }
}

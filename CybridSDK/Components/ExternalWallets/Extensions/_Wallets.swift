//
//  _Wallets.swift
//  CybridSDK
//
//  Created by Erick Sanchez on 22/08/23.
//

import UIKit

extension ExternalWalletsView {

    internal func externalWalletsView_Wallets() {

        // -- Add button
        let addButton = CYBButton(title: "Add wallet") {
            self.externalWalletsViewModel?.uiState.value = .CREATE
        }
        self.addSubview(addButton)
        addButton.constraintLeft(self, margin: 10)
        addButton.constraintRight(self, margin: 10)
        addButton.constraintBottom(self, margin: 0)
        addButton.constraintHeight(48)

        // -- Check for empty state with empty externalWalletsActive
        if self.externalWalletsViewModel!.externalWalletsActive.isEmpty {

            let emptySection = self.createEmptySection(text: "No wallets have been added.")
            self.addSubview(emptySection)
            emptySection.centerVertical(parent: self)
            emptySection.constraintLeft(self, margin: 10)
            emptySection.constraintRight(self, margin: 10)

        } else {

            // -- Title
            let title = self.label(
                font: UIFont.make(ofSize: 23, weight: .bold),
                color: UIColor.init(hex: "#3A3A3C"),
                text: "My wallets",
                lineHeight: 1.15,
                aligment: .left)
            self.addSubview(title)
            title.constraintTop(self, margin: 10)
            title.constraintLeft(self, margin: 10)
            title.constraintRight(self, margin: 10)

            // -- Wallets table
            let walletsTable = UITableView()
            walletsTable.delegate = self
            walletsTable.dataSource = self
            walletsTable.register(ExternalWalletCell.self, forCellReuseIdentifier: ExternalWalletCell.reuseIdentifier)
            walletsTable.accessibilityIdentifier = "walletsTable"
            self.addSubview(walletsTable)
            walletsTable.below(title, top: 30)
            walletsTable.constraintLeft(self, margin: 0)
            walletsTable.constraintRight(self, margin: 0)
            walletsTable.above(addButton, bottom: 15)
        }
    }
}

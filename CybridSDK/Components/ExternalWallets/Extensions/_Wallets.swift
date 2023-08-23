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
            self.createEmptySection()
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
            let walletTable = UITableView()
            walletTable.delegate = self
            walletTable.dataSource = self
            walletTable.register(ExternalWalletCell.self, forCellReuseIdentifier: ExternalWalletCell.reuseIdentifier)
            self.addSubview(walletTable)
            walletTable.below(title, top: 30)
            walletTable.constraintLeft(self, margin: 0)
            walletTable.constraintRight(self, margin: 0)
            walletTable.above(addButton, bottom: 15)
        }
    }
}

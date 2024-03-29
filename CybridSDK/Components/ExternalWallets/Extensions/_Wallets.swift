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
        let addButtonString = localizer.localize(with: UIStrings.walletsAddButton)
        let addButton = CYBButton(title: addButtonString) {
            self.externalWalletViewModel?.uiState.value = .CREATE
        }
        self.addSubview(addButton)
        addButton.constraintLeft(self, margin: 10)
        addButton.constraintRight(self, margin: 10)
        addButton.constraintBottom(self, margin: 0)
        addButton.constraintHeight(48)

        // -- Check for empty state with empty externalWalletsActive
        if self.externalWalletViewModel!.externalWalletsActive.isEmpty {

            let emptyString = localizer.localize(with: UIStrings.walletsEmptyTitle)
            let emptySection = self.createEmptySection(text: emptyString)
            self.addSubview(emptySection)
            emptySection.centerVertical(parent: self)
            emptySection.constraintLeft(self, margin: 10)
            emptySection.constraintRight(self, margin: 10)

        } else {

            // -- Title
            let titleString = localizer.localize(with: UIStrings.walletsTitle)
            let title = self.label(
                font: UIFont.make(ofSize: 23, weight: .bold),
                color: UIColor.init(hex: "#3A3A3C"),
                text: titleString,
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
            walletsTable.backgroundColor = UIColor.white
            self.addSubview(walletsTable)
            walletsTable.below(title, top: 30)
            walletsTable.constraintLeft(self, margin: 0)
            walletsTable.constraintRight(self, margin: 0)
            walletsTable.above(addButton, bottom: 15)
        }
    }
}

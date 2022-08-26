//
//  AccountTradeDetailModal.swift
//  CybridSDK
//
//  Created by Erick Sanchez Perez on 26/08/22.
//

import Foundation
import UIKit

class AccountTradeDetailModal: UIModal {
    
    private var trade: TradeUIModel
    private let localizer: Localizer
    private var onConfirm: (() -> Void)?

    init(trade: TradeUIModel, theme: Theme, localizer: Localizer, onConfirm: (() -> Void)?) {

        self.trade = trade
        self.localizer = localizer
        self.onConfirm = onConfirm
        super.init(theme: theme)
        
        setupViews()
    }

    @available(iOS, deprecated: 10, message: "You should never use this init method.")
    required init?(coder: NSCoder) {
        
        assertionFailure("init(coder:) should never be used")
        return nil
    }

    private func setupViews() {

        // -- Title View
        let titleView = UILabel.makeBasic(
            font: UIValues.titleFont,
            color: UIValues.titleColor,
            aligment: .left)
        titleView.text = "Hola mundo"
        titleView.addAsFirstElement(
            parent: self.containerView,
            height: UIValues.titleSize,
            margins: UIValues.titleSizeMargin)
    }
}

extension AccountTradeDetailModal {

    enum UIValues {

        // -- Font
        static let titleFont = UIFont.make(ofSize: 22)
        
        // -- Size
        static let titleSize: CGFloat = 28
        static let titleSizeMargin = UIEdgeInsets(top: 28, left: 24, bottom: 0, right: 24)

        // -- Color
        static let titleColor = UIColor.black
    }
}

//
//  TradeModal.swift
//  CybridSDK
//
//  Created by Erick Sanchez Perez on 21/04/23.
//

import CybridApiBankSwift
import Foundation
import UIKit

class TradeModal: UIModal {
    
    internal var localizer: Localizer!
    
    internal var tradeBankModel: TradeBankModel
    
    init(tradeBankModel: TradeBankModel) {

        self.tradeBankModel = tradeBankModel

        super.init(height: UIValues.modalSize)

        self.localizer = CybridLocalizer()
        self.setupViews()
    }

    @available(iOS, deprecated: 10, message: "You should never use this init method.")
    required init?(coder: NSCoder) {

        assertionFailure("init(coder:) should never be used")
        return nil
    }

    private func setupViews() {

        self.initComponentContent()
        self.manageCurrentStateUI()
    }
}

extension TradeModal {

    enum UIValues {

        // -- Sizes
        static let modalSize: CGFloat = 411
        static let titleHeight: CGFloat = 28

        // -- Fonts
        static let titleFont = UIFont.make(ofSize: 22)

        // -- Colors
        static let titleColor = UIColor.black

        // -- Margins
        static let titleMargins = UIEdgeInsets(top: 28, left: 24, bottom: 0, right: 24)
    }

    enum UIStrings {

        static let titleString = "cybrid.bank.accounts.detail.title.text"
    }
}

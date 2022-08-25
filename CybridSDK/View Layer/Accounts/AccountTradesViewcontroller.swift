//
//  AccountTradesViewcontroller.swift
//  CybridSDK
//
//  Created by Erick Sanchez Perez on 25/08/22.
//

import Foundation
import UIKit

public final class AccountTradesViewController: UIViewController {

    private var balance: AccountAssetPriceModel!
    private var accountsViewModel: AccountsViewModel!
    private var tradesViewModel: AccountTradeViewModel!

    private var theme: Theme!
    private var localizer: Localizer!

    // -- Views
    var balanceAssetIcon: URLImageView!
    var balanceAssetName: UILabel!
    var assetTitleContainer: UIStackView!

    internal init(balance: AccountAssetPriceModel, accountsViewModel: AccountsViewModel) {

        super.init(nibName: nil, bundle: nil)
        self.balance = balance
        self.accountsViewModel = accountsViewModel
        self.tradesViewModel = AccountTradeViewModel(
            dataProvider: CybridSession.current,
            logger: Cybrid.logger)
        self.theme = Cybrid.theme
        self.localizer = CybridLocalizer()
        
        self.tradesViewModel.getTrades(accountGuid: balance.accountGuid)
        self.setupView()
    }

    @available(iOS, deprecated: 10, message: "You should never use this init method.")
    required init?(coder: NSCoder) {
      assertionFailure("init(coder:) should never be used")
      return nil
    }

    func setupView() {

        view.backgroundColor = .white
        self.createAssetTitle()
        self.createBalanceTitles()
    }
}

extension AccountTradesViewController {

    private func createAssetTitle() {

        // -- Icon
        balanceAssetIcon = URLImageView(urlString: balance.accountAssetURL)
        balanceAssetIcon?.setConstraintsSize(size: UIValues.balanceAssetIconSize)

        // -- Name
        balanceAssetName = UILabel()
        balanceAssetName.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        balanceAssetName.translatesAutoresizingMaskIntoConstraints = false
        balanceAssetName.sizeToFit()
        balanceAssetName.font = UIValues.balanceAssetNameFont
        balanceAssetName.textColor = UIValues.balanceAssetNameColor
        balanceAssetName.textAlignment = .center
        balanceAssetName.text = balance.assetName

        // -- AssetTitle Container
        assetTitleContainer = UIStackView(arrangedSubviews: [balanceAssetIcon, balanceAssetName])
        assetTitleContainer.axis = .horizontal
        assetTitleContainer.distribution = .fill
        assetTitleContainer.alignment = .center
        assetTitleContainer.spacing = UIConstants.zero

        self.view.addSubview(assetTitleContainer)
        self.centerHorizontalView(container: assetTitleContainer)
    }

    private func createBalanceTitles() {

        // -- Balancr Value
        let balanceValueView = UILabel()
        balanceValueView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        balanceValueView.translatesAutoresizingMaskIntoConstraints = false
        balanceValueView.sizeToFit()
        balanceValueView.font = UIValues.balanceValueViewFont
        balanceValueView.textColor = UIValues.balanceValueViewColor
        balanceValueView.textAlignment = .center
        balanceValueView.setAttributedText(mainText: balance.accountBalanceFormatted,
                                           mainTextFont: UIValues.balanceValueViewFont,
                                           mainTextColor: UIValues.balanceValueViewColor,
                                           attributedText: balance.accountAssetCode,
                                           attributedTextFont: UIValues.balanceValueCodeViewFont,
                                           attributedTextColor: UIValues.balanceValueCodeViewColor)
        balanceValueView.addBelow(
            toItem: assetTitleContainer,
            height: UIValues.balanceValueViewSize,
            margins: UIValues.balanceValueViewMargin)

        // -- Balance Fiat Value
        let balanceFiatValueView = UILabel()
        balanceFiatValueView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        balanceFiatValueView.translatesAutoresizingMaskIntoConstraints = false
        balanceFiatValueView.sizeToFit()
        balanceFiatValueView.font = UIValues.balanceFiatValueFont
        balanceFiatValueView.textColor = UIValues.balanceFiatValueColor
        balanceFiatValueView.textAlignment = .center
        balanceFiatValueView.setAttributedText(mainText: balance.accountBalanceInFiatFormatted,
                                               mainTextFont: UIValues.balanceFiatValueFont,
                                               mainTextColor: UIValues.balanceFiatValueColor,
                                               attributedText: balance.pairAsset?.code ?? "",
                                               attributedTextFont: UIValues.balanceFiatValueCodeFont,
                                               attributedTextColor: UIValues.balanceFiatValueCodeColor)
        balanceFiatValueView.addBelow(
            toItem: balanceValueView,
            height: UIValues.balanceFiatValueViewSize,
            margins: UIValues.balanceFiatValueViewMargins)
    }

    private func centerHorizontalView(container: UIStackView) {

        container.translatesAutoresizingMaskIntoConstraints = false
        container.constraint(attribute: .top,
                             relatedBy: .equal,
                             toItem: self.view,
                             attribute: .topMargin,
                             constant: UIValues.assetTitleViewMargin.top)
        container.constraint(attribute: .centerX,
                             relatedBy: .equal,
                             toItem: self.view,
                             attribute: .centerX)
        container.constraint(attribute: .width,
                             relatedBy: .equal,
                             toItem: nil,
                             attribute: .notAnAttribute,
                             constant: 120)
        container.constraint(attribute: .height,
                             relatedBy: .equal,
                             toItem: nil,
                             attribute: .notAnAttribute,
                             constant: UIValues.assetTitleViewHeight)
    }
}

extension AccountTradesViewController {

    enum UIValues {

        // -- Sizes
        static let assetTitleViewMargin = UIEdgeInsets(top: 36, left: 0, bottom: 0, right: 0)
        static let assetTitleViewHeight: CGFloat = 25
        static let balanceAssetIconSize = CGSize(width: assetTitleViewHeight, height: assetTitleViewHeight)
        static let balanceAssetNameMargin = UIEdgeInsets(top: 4, left: 10, bottom: 0, right: 0)
        static let balanceValueViewMargin = UIEdgeInsets(top: 19, left: 10, bottom: 0, right: 10)
        static let balanceValueViewSize: CGFloat = 35
        static let balanceFiatValueViewMargins = UIEdgeInsets(top: 2, left: 10, bottom: 0, right: 10)
        static let balanceFiatValueViewSize: CGFloat = 23

        // -- Fonts
        static let balanceAssetNameFont = UIFont.make(ofSize: 16.5, weight: .medium)
        static let balanceValueViewFont = UIFont.make(ofSize: 28)
        static let balanceValueCodeViewFont = UIFont.make(ofSize: 18)
        static let balanceFiatValueFont = UIFont.make(ofSize: 17)
        static let balanceFiatValueCodeFont = UIFont.make(ofSize: 17)

        // -- Colors
        static let balanceAssetNameColor = UIColor(hex: "#3A3A3C")
        static let balanceValueViewColor = UIColor.black
        static let balanceValueCodeViewColor = UIColor(hex: "#8E8E93")
        static let balanceFiatValueColor = UIColor(hex: "#636366")
        static let balanceFiatValueCodeColor = UIColor(hex: "#757575")
    }
}

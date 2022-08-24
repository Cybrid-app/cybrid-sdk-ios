//
//  AccountsCellç.swift
//  CybridSDK
//
//  Created by Erick Sanchez Perez on 24/08/22.
//

import Foundation
import UIKit

class AccountsCell: UITableViewCell {
    
    static let reuseIdentifier = "accountsCell"
    override var reuseIdentifier: String? { Self.reuseIdentifier }
    
    private let theme: Theme
    
    private var icon = URLImageView(url: nil)
    private var assetName = UILabel()
    private var accountBalance = UILabel()
    private var assetPrice = UILabel()
    private var accountBalanceFiat = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
      self.theme = Cybrid.theme
      super.init(style: style, reuseIdentifier: reuseIdentifier)
      setupViews()
    }

    @available(iOS, deprecated: 10, message: "You should never use this init method.")
    required init?(coder: NSCoder) {
      assertionFailure("init(coder:) should never be used")
      return nil
    }
    
    private func setupViews() {
        
        backgroundColor = theme.colorTheme.primaryBackgroundColor
        self.setupIcon()
        self.setupLabels()
        
        // -- Vertical Stacks
        let leftSide = createVerticalStackView(top: assetName, bottom: assetPrice)
        let rightSide = createVerticalStackView(top: accountBalance, bottom: accountBalanceFiat)
        
        // -- Horizontal Stack
        self.createStackView(left: icon,
                             center: leftSide,
                             right: rightSide)
    }
    
    func setData(balance: AccountAssetPriceModel) {
        
        print(balance)
        // -- Setup icon
        icon.setURL(balance.accountAssetURL)
    }
}

extension AccountsCell {

    private func setupIcon() {

        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.constraint(attribute: .height,
                        relatedBy: .equal,
                        toItem: nil,
                        attribute: .notAnAttribute,
                        constant: UIConstants.iconWidht)
        icon.constraint(attribute: .width,
                        relatedBy: .equal,
                        toItem: nil,
                        attribute: .notAnAttribute,
                        constant: UIConstants.iconHeight)
    }

    private func setupLabels() {

        // -- Asset name
        self.setupBasicLabel(assetName,
                             side: .left,
                             font: UIFont.make(ofSize: UIConstants.assetNameSize),
                             color: UIConstants.assetNameColor)

        // -- Account balance
        self.setupBasicLabel(accountBalance,
                             side: .right,
                             font: UIFont.make(ofSize: UIConstants.accountBalanceSize),
                             color: UIConstants.accountBalanceColor)

        // -- Asset price
        self.setupBasicLabel(assetPrice,
                             side: .left,
                             font: UIFont.make(ofSize: UIConstants.assetPriceSize),
                             color: UIConstants.assetPriceColor)

        // -- Account balance fiat
        self.setupBasicLabel(accountBalanceFiat,
                             side: .right,
                             font: UIFont.make(ofSize: UIConstants.accountBalanceFiatSize),
                             color: UIConstants.accountBalanceFiatColor)
    }

    private func createVerticalStackView(top: UIView, bottom: UIView) -> UIStackView {

        let stack = UIStackView(arrangedSubviews: [top, bottom])
        stack.axis = .vertical
        stack.spacing = 10
        stack.distribution = .equalSpacing
        stack.alignment = .leading
        return stack
    }

    private func createStackView(left: UIView, center: UIView, right: UIView) {

      let contentStackView = UIStackView(arrangedSubviews: [left, center, right])
      contentStackView.axis = .horizontal
      contentStackView.spacing = 10
      contentStackView.distribution = .fill
      contentStackView.alignment = .center
      addSubview(contentStackView)
        
      contentStackView.translatesAutoresizingMaskIntoConstraints = false
      contentStackView.constraint(attribute: .top,
                                  relatedBy: .equal,
                                  toItem: self,
                                  attribute: .top,
                                  constant: 10)
      contentStackView.constraint(attribute: .bottom,
                                  relatedBy: .equal,
                                  toItem: self,
                                  attribute: .bottom,
                                  constant: -10)
      contentStackView.constraint(attribute: .leading,
                                  relatedBy: .equal,
                                  toItem: self,
                                  attribute: .leading,
                                  constant: 10)
      contentStackView.constraint(attribute: .trailing,
                                  relatedBy: .equal,
                                  toItem: self,
                                  attribute: .trailing,
                                  constant: -10)
    }
    
    private func setupBasicLabel(_ label: UILabel, side: UILabel.Side, font: UIFont, color: UIColor?) {
        
        switch side {
            
        case .left:
            label.setContentCompressionResistancePriority(.defaultHigh - 1, for: .horizontal)
            label.setContentHuggingPriority(.required, for: .horizontal)
            label.setContentHuggingPriority(.defaultHigh, for: .vertical)
            
        case .right:
            label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
            label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        }
        
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.sizeToFit()
        label.font = font
        label.textColor = color ?? UIColor.black
    }
}

extension AccountsCell {
    
    enum UIConstants {
        
        // -- Sizes
        static let iconWidht: CGFloat = 24
        static let iconHeight: CGFloat = 24
        static let assetNameSize: CGFloat = 14
        static let accountBalanceSize: CGFloat = 14
        static let assetPriceSize: CGFloat = 13
        static let accountBalanceFiatSize: CGFloat = 14
        
        // -- Colors
        static let assetNameColor = UIColor.black
        static let accountBalanceColor = UIColor.black
        static let assetPriceColor = UIColor(hex: "#636366")
        static let accountBalanceFiatColor = UIColor(hex: "#636366")
    }
}

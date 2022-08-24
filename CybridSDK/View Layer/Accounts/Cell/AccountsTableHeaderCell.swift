//
//  AccountsTableHeaderCell.swift
//  CybridSDK
//
//  Created by Erick Sanchez Perez on 24/08/22.
//

import UIKit

class AccountsTableHeaderCell: UITableViewHeaderFooterView {

    private let localizer: Localizer
    
    @available(iOS, deprecated: 10, message: "You should never use this init method.")
    required init?(coder: NSCoder) {
      assertionFailure("init(coder:) should never be used")
      return nil
    }
    
    override init(reuseIdentifier: String? = nil) {

        localizer = CybridLocalizer()
        super.init(reuseIdentifier: reuseIdentifier)
        self.setupViews()
    }

    func setupViews() {
        
        // -- Creating left view
        let asseTitle = createTitleLabel()
        let marketPriceLabel = createTitleLabel()
        let leftSide = createVerticalStack(labelOne: asseTitle, labelTwo: marketPriceLabel)
        
        // -- Creatin right side
        let balanceTitle = createTitleLabel()
        let currecnyTitle = createTitleLabel()
        let rightSide = createVerticalStack(labelOne: balanceTitle, labelTwo: currecnyTitle)

        // -- Join
        let stack = createHorizontalStack(one: leftSide, two: rightSide)
        addSubview(stack)
        stack.backgroundColor = UIColor.red
        stack.translatesAutoresizingMaskIntoConstraints = true
        stack.constraint(attribute: .top,
                         relatedBy: .equal,
                         toItem: self,
                         attribute: .top,
                         constant: 0)
        stack.constraint(attribute: .bottom,
                         relatedBy: .equal,
                         toItem: self,
                         attribute: .bottom,
                         constant: -0)
        stack.constraint(attribute: .leading,
                         relatedBy: .equal,
                         toItem: self,
                         attribute: .leading,
                         constant: 6)
        stack.constraint(attribute: .trailing,
                         relatedBy: .equal,
                         toItem: self,
                         attribute: .trailing,
                         constant: -6)
        stack.constraint(attribute: .height,
                         relatedBy: .equal,
                         toItem: nil,
                         attribute: .notAnAttribute,
                         constant: 50)
    }
}

extension AccountsTableHeaderCell {
    
    private func createTitleLabel() -> UILabel {
        
        let label = UILabel()
        label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.baselineAdjustment = .alignCenters
        label.sizeToFit()
        label.font = FormatStyle.headerSmall.font
        label.textColor = UIColor.white
        let text = localizer.localize(with: CybridLocalizationKey.cryptoPriceList(.headerCurrency))
        label.text = text.uppercased()
        return label
    }
    
    private func createVerticalStack(labelOne: UILabel, labelTwo: UILabel) -> UIStackView {
        
        let stack = UIStackView(arrangedSubviews: [labelOne, labelTwo])
        stack.axis = .vertical
        stack.spacing = 10//Constants.ContentStackView.itemSpacing
        stack.distribution = .equalSpacing
        stack.alignment = .leading
        return stack
    }
    
    private func createHorizontalStack(one: UIStackView, two: UIStackView) -> UIStackView {
        
        let stack = UIStackView(arrangedSubviews: [one, two])
        stack.axis = .horizontal
        stack.spacing = 10//Constants.ContentStackView.itemSpacing
        stack.distribution = .fill
        stack.alignment = .center
        return stack
    }
}

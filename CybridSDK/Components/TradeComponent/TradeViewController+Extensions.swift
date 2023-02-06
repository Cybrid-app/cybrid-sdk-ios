//
//  TradeViewController+Extensions.swift
//  CybridSDK
//
//  Created by Erick Sanchez Perez on 31/01/23.
//

import Foundation
import UIKit

extension TradeViewController {

    internal func tradeView_Loading() {

        let title = UILabel()
        title.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.sizeToFit()
        title.font = UIValues.componentTitleFont
        title.textColor = UIValues.componentTitleColor
        title.textAlignment = .center
        title.setLocalizedText(key: UIStrings.loadingText, localizer: localizer)

        self.componentContent.addSubview(title)
        title.constraint(attribute: .centerY,
                         relatedBy: .equal,
                         toItem: self.componentContent,
                         attribute: .centerY)
        title.constraint(attribute: .leading,
                         relatedBy: .equal,
                         toItem: self.componentContent,
                         attribute: .leading,
                         constant: UIValues.componentTitleMargin.left)
        title.constraint(attribute: .trailing,
                         relatedBy: .equal,
                         toItem: self.componentContent,
                         attribute: .trailing,
                         constant: -UIValues.componentTitleMargin.right)
        title.constraint(attribute: .height,
                         relatedBy: .equal,
                         toItem: nil,
                         attribute: .notAnAttribute,
                         constant: UIValues.componentTitleHeight)

        // -- Spinner
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.addBelow(toItem: title, height: UIValues.loadingSpinnerHeight, margins: UIValues.loadingSpinnerMargin)
        spinner.color = UIColor.black
        spinner.startAnimating()
    }

    internal func tradeView_ListPrices() {

        let listPricesView = ListPricesView()
        listPricesView.itemDelegate = tradeViewModel

        let listPricesViewContainer = UIView()
        self.componentContent.addSubview(listPricesViewContainer)
        listPricesViewContainer.constraint(attribute: .top,
                                  relatedBy: .equal,
                                  toItem: self.componentContent,
                                  attribute: .top)
        listPricesViewContainer.constraint(attribute: .leading,
                                  relatedBy: .equal,
                                  toItem: self.componentContent,
                                  attribute: .leading)
        listPricesViewContainer.constraint(attribute: .trailing,
                                  relatedBy: .equal,
                                  toItem: self.componentContent,
                                  attribute: .trailing)
        listPricesViewContainer.constraint(attribute: .bottom,
                                  relatedBy: .equal,
                                  toItem: self.componentContent,
                                  attribute: .bottom)
        listPricesView.embed(in: listPricesViewContainer)
    }

    internal func tradeView_Content() {

        let segmentsLabels = [_TradeType.buy, _TradeType.sell]
        let segments = UISegmentedControl(items: segmentsLabels.map { localizer.localize(with: $0.localizationKey) })
        segments.translatesAutoresizingMaskIntoConstraints = false
        segments.selectedSegmentIndex = 0
        segments.addTarget(tradeViewModel, action: #selector(TradeViewModel.segmentedControlValueChanged(_:)), for: .valueChanged)
        segments.asFirstIn(
            self.componentContent,
            height: CGFloat(100),
            margins: UIEdgeInsets())
    }
}

extension TradeViewController {

    enum UIValues {

        // -- Sizes
        static let componentTitleSize: CGFloat = 17
        static let componentTitleHeight: CGFloat = 20
        static let componentTitleMargin = UIEdgeInsets(top: 40, left: 10, bottom: 0, right: 10)
        static let componentRequiredButtonsMargin = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: -10)

        static let loadingSpinnerHeight: CGFloat = 30
        static let loadingSpinnerMargin = UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
        static let componentRequiredButtonsHeight: CGFloat = 50

        // -- Colors
        static let componentTitleColor = UIColor.black

        // -- Fonts
        static let componentTitleFont = UIFont.make(ofSize: 17, weight: .bold)
    }

    enum UIStrings {

        static let loadingText = "cybrid.tradeView.loading.title"
    }
}

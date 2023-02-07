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
        let listPricesViewModel = ListPricesViewModel(cellProvider: listPricesView,
                                                      dataProvider: CybridSession.current,
                                                      logger: Cybrid.logger)

        listPricesView.setViewModel(listPricesViewModel: listPricesViewModel)
        listPricesView.itemDelegate = tradeViewModel
        tradeViewModel.listPricesViewModel = listPricesViewModel

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

        // -- Segment
        let segmentsLabels = [_TradeType.buy, _TradeType.sell]
        let segments = UISegmentedControl(items: segmentsLabels.map { localizer.localize(with: $0.localizationKey) })
        segments.translatesAutoresizingMaskIntoConstraints = false
        segments.selectedSegmentIndex = 0
        segments.addTarget(tradeViewModel, action: #selector(tradeViewModel.segmentedControlValueChanged(_:)), for: .valueChanged)
        segments.asFirstIn(
            self.componentContent,
            height: CGFloat(32),
            margins: UIMargins.segmentsMargin)

        // -- From:
        let fromLabel = createSubTitleLabel(UIStrings.contentFrom)
        fromLabel.addBelow(toItem: segments, height: 16, margins: UIMargins.subTitleFromMargin)

        // -- From UITextField
        let fromTextField = CYBTextField(style: .rounded, icon: .urlImage(""), theme: theme)
        fromTextField.accessibilityIdentifier = "fiatPickerTextField"
        fromTextField.placeholder = localizer.localize(with: CybridLocalizationKey.trade(.buy(.selectCurrency)))
        fromTextField.addBelow(toItem: fromLabel, height: 45, margins: UIMargins.fiatSelectorMargin)
        self.cryptoPickerView.delegate = tradeViewModel
        self.cryptoPickerView.dataSource = tradeViewModel
        fromTextField.inputView = self.cryptoPickerView

        // -- From:
        let toLabel = createSubTitleLabel(UIStrings.contentTo)
        toLabel.addBelow(toItem: fromTextField, height: 16, margins: UIMargins.subTitletoMargin)
    }
}

extension TradeViewController {

    func createSubTitleLabel(_ key: String) -> UILabel {

        let view = UILabel()
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        view.sizeToFit()
        view.font = UIValues.subTitleFont
        view.textColor = UIValues.subTitleColor
        view.setLocalizedText(key: key, localizer: localizer)
        return view
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
        static let subTitleColor = UIColor(hex: "#757575")

        // -- Fonts
        static let componentTitleFont = UIFont.make(ofSize: 17, weight: .bold)
        static let subTitleFont = UIFont.make(ofSize: 13)
    }

    enum UIMargins {

        static let segmentsMargin = UIEdgeInsets(top: 25, left: 13, bottom: 0, right: 13)
        static let subTitleFromMargin = UIEdgeInsets(top: 30, left: 13, bottom: 0, right: 13)
        static let fiatSelectorMargin = UIEdgeInsets(top: 13, left: 13, bottom: 0, right: 13)
        static let subTitletoMargin = UIEdgeInsets(top: 24, left: 13, bottom: 0, right: 13)
    }

    enum UIStrings {

        static let loadingText = "cybrid.tradeView.loading.title"
        static let contentFrom = "cybrid.tradeView.content.subtitle.from"
        static let contentTo = "cybrid.tradeView.content.subtitle.to"
    }
}

//
//  TradeViewController.swift
//  CybridSDK
//
//  Created by Erick Sanchez Perez on 30/01/23.
//

import Foundation
import UIKit

public final class TradeViewController: UIViewController {

    public enum ViewState { case LOADING, PRICES, CONTENT }

    internal var tradeViewModel: TradeViewModel!
    internal var theme: Theme!
    internal var localizer: Localizer!

    internal var componentContent = UIView()
    internal var currentState: Observable<ViewState> = .init(.LOADING)

    // MARK: Views
    internal var fromTextField: CYBTextField!
    internal var toTextField: CYBTextField!
    internal var amountTextField: CYBTextField!
    internal var flagIcon = URLImageView(url: nil)
    internal var amountPriceLabel: UILabel!
    internal var actionButton: CYBButton!
    internal lazy var fiatPickerView = UIPickerView()
    internal lazy var tradingPickerView = UIPickerView()

    public init() {

        super.init(nibName: nil, bundle: nil)
        self.tradeViewModel = TradeViewModel(
            dataProvider: CybridSession.current,
            logger: Cybrid.logger)

        self.currentState = self.tradeViewModel.uiState
        self.theme = Cybrid.theme
        self.localizer = CybridLocalizer()
        self.setupView()
    }

    @available(iOS, deprecated: 10, message: "You should never use this init method.")
    required init?(coder: NSCoder) {

      assertionFailure("init(coder:) should never be used")
      return nil
    }

    func setupView() {

        view.backgroundColor = .white
        self.initComponentContent()
        self.manageCurrentStateUI()

        // self.identityVerificationViewModel.getCustomerStatus()
    }
}

extension TradeViewController {

    private func initComponentContent() {

        // -- Component Container
        self.view.addSubview(self.componentContent)
        // self.componentContent.backgroundColor = UIColor.red.withAlphaComponent(0.5)
        self.componentContent.constraint(attribute: .top,
                                         relatedBy: .equal,
                                         toItem: self.view,
                                         attribute: .topMargin,
                                         constant: 10)
        self.componentContent.constraint(attribute: .leading,
                                         relatedBy: .equal,
                                         toItem: self.view,
                                         attribute: .leading,
                                         constant: 10)
        self.componentContent.constraint(attribute: .trailing,
                                         relatedBy: .equal,
                                         toItem: self.view,
                                         attribute: .trailing,
                                         constant: -10)
        self.componentContent.constraint(attribute: .bottom,
                                         relatedBy: .equal,
                                         toItem: self.view,
                                         attribute: .bottomMargin,
                                         constant: 10)
    }

    private func manageCurrentStateUI() {

        // -- Await for UI State changes
        self.currentState.bind { state in

            self.removeSubViewsFromContent()
            switch state {

            case .LOADING:
                self.tradeView_Loading()

            case .PRICES:
                self.tradeView_ListPrices()

            case .CONTENT:
                self.tradeView_Content()
            }
        }
    }

    private func removeSubViewsFromContent() {

        for view in self.componentContent.subviews {
            view.removeFromSuperview()
        }
    }
}

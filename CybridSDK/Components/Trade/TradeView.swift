//
//  TradeView.swift
//  CybridSDK
//
//  Created by Erick Sanchez on 01/11/23.
//

import UIKit

public final class TradeView: Component {

    public enum State { case LOADING, PRICES, CONTENT }
    public enum ModalState { case LOADING, CONTENT, SUBMITING, SUCCESS, ERROR }

    internal var localizer: Localizer!
    internal var theme: Theme!
    internal var tradeViewModel: TradeViewModel!

    internal var pricesScheduler = TaskScheduler()

    // MARK: Views
    internal var fromTextField: CYBTextField!
    internal var toTextField: CYBTextField!
    internal var amountTextField: CYBTextField!
    internal var flagIcon = URLImageView(url: nil)
    internal var amountPriceLabel: UILabel!
    internal var maxButton: UIButton!
    internal var actionButton: CYBButton!
    internal lazy var fiatPickerView = UIPickerView()
    internal lazy var tradingPickerView = UIPickerView()

    public func initComponent(tradeViewModel: TradeViewModel) {

        self.tradeViewModel = tradeViewModel
        self.theme = Cybrid.theme
        self.localizer = CybridLocalizer()
        self.setupView()
    }

    override func setupView() {

        self.backgroundColor = UIColor.white
        self.overrideUserInterfaceStyle = .light
        self.manageCurrentStateUI()
    }

    private func manageCurrentStateUI() {

        // -- Await for UI State changes
        self.tradeViewModel.uiState.bind { state in

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
}

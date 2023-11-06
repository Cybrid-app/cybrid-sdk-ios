//
//  ListPrices.swift
//  CybridSDK
//
//  Created by Erick Sanchez on 01/11/23.
//

import UIKit

extension TradeView {

    internal func tradeView_ListPrices() {

        let listPricesView = ListPricesView()
        let listPricesViewModel = ListPricesViewModel(cellProvider: listPricesView,
                                                      dataProvider: CybridSession.current,
                                                      logger: Cybrid.logger,
                                                      taskScheduler: self.pricesScheduler)

        listPricesView.setViewModel(listPricesViewModel: listPricesViewModel)
        listPricesView.itemDelegate = tradeViewModel
        tradeViewModel.listPricesViewModel = listPricesViewModel

        let listPricesViewContainer = UIView()
        self.addSubview(listPricesViewContainer)
        listPricesViewContainer.constraint(attribute: .top,
                                           relatedBy: .equal,
                                           toItem: self,
                                           attribute: .top)
        listPricesViewContainer.constraint(attribute: .leading,
                                           relatedBy: .equal,
                                           toItem: self,
                                           attribute: .leading)
        listPricesViewContainer.constraint(attribute: .trailing,
                                           relatedBy: .equal,
                                           toItem: self,
                                           attribute: .trailing)
        listPricesViewContainer.constraint(attribute: .bottom,
                                           relatedBy: .equal,
                                           toItem: self,
                                           attribute: .bottom)
        listPricesView.embed(in: listPricesViewContainer)
    }
}

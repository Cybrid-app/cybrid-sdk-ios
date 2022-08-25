//
//  AccountTradeViewModel.swift
//  CybridSDK
//
//  Created by Erick Sanchez Perez on 25/08/22.
//

import Foundation
import CybridApiBankSwift

class AccountTradeViewModel: NSObject {

    // MARK: Observed properties
    internal var tardes: Observable<[TradeBankModel]> = .init([])
    
    // MARK: Private properties
    // private unowned var cellProvider: AccountsViewProvider
    private var dataProvider: TradesRepoProvider
    private var logger: CybridLogger?
    
    init(dataProvider: TradesRepoProvider,
         logger: CybridLogger?) {

        //self.cellProvider = cellProvider
        self.dataProvider = dataProvider
        self.logger = logger
    }
    
    func getTrades(accountGuid: String) {
        dataProvider.fetchTrades(accountGuid: accountGuid) { [weak self] tradesResult in
            
            print(tradesResult)
        }
    }
}

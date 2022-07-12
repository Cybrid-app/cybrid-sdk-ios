//
//  CryptoPriceViewModel.swift
//  CybridSDK
//
//  Created by Cybrid on 20/06/22.
//

import CybridApiBankSwift
import UIKit

protocol CryptoPriceViewProvider: AnyObject {
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, withData dataModel: CryptoPriceModel) -> UITableViewCell
}

class CryptoPriceViewModel: NSObject {
  // MARK: Observed properties
  var cryptoPriceList: Observable<[CryptoPriceModel]> = .init([])

  // MARK: Private properties
  private unowned var cellProvider: CryptoPriceViewProvider
  private var dataProvider: SymbolsDataProvider

  init(cellProvider: CryptoPriceViewProvider, dataProvider: SymbolsDataProvider) {
    self.cellProvider = cellProvider
    self.dataProvider = dataProvider
  }

  func fetchPriceList() {
    dataProvider.fetchAvailableSymbols { result in
      switch result {
      case .success(let priceList):
        print(priceList)
      case .failure(let error):
        print(error)
      }
    }
    // FIXME: replace mocked data with service call response
    cryptoPriceList.value = CryptoPriceModel.mockList
  }
}

// MARK: - CryptoPriceViewModel + UITableViewDelegate + UITableViewDataSource

extension CryptoPriceViewModel: UITableViewDelegate, UITableViewDataSource {
  public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    cryptoPriceList.value.count
  }

  public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    cellProvider.tableView(tableView, cellForRowAt: indexPath, withData: cryptoPriceList.value[indexPath.row])
  }
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let view = CryptoPriceTableHeaderView()
    return view
  }
}

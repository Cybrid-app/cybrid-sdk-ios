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
  var cryptoPriceList: Observable<[CryptoPriceModel]> = .init([])
  unowned var cellProvider: CryptoPriceViewProvider

  init(cellProvider: CryptoPriceViewProvider) {
    self.cellProvider = cellProvider
  }

  func fetchPriceList() {
    // FIXME: replace mocked data with service call
    PricesAPI.listPrices(symbol: "BTC-USD") { result in
      switch result {
      case .success(let priceList):
        print(priceList)
      case .failure(let error):
        print(error)
      }
    }
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

//
//  CryptoPriceViewModel.swift
//  CybridSDK
//
//  Created by Cybrid on 20/06/22.
//

import UIKit

class CryptoPriceViewModel: NSObject {
  var cryptoPriceList: Observable<[CryptoPriceModel]> = .init([])

  func fetchPriceList() {
    // FIXME: replace mocked data with service call
    cryptoPriceList.value = CryptoPriceModel.mockList
  }
}

// MARK: - CryptoPriceViewModel + UITableViewDelegate + UITableViewDataSource

extension CryptoPriceViewModel: UITableViewDelegate, UITableViewDataSource {
  public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    cryptoPriceList.value.count
  }

  public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard
      let cell = tableView.dequeueReusableCell(
        withIdentifier: CryptoPriceTableViewCell.reuseIdentifier, for: indexPath
      ) as? CryptoPriceTableViewCell
    else {
      return UITableViewCell()
    }
    cell.customize(dataModel: cryptoPriceList.value[indexPath.row])
    return cell
  }
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let view = CryptoPriceTableHeaderView()
    return view
  }
}

// FIXME: Remove Mocked data
extension CryptoPriceModel {
  static let mockList: [CryptoPriceModel] = [
    .init(id: UUID().uuidString,
          imageURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/4/4f/YouTube_social_white_squircle.svg/1200px-YouTube_social_white_squircle.svg.png",
          cryptoId: "BTC",
          fiatId: "USD",
          name: "Bitcoin",
          price: 20_998.901_43),
    .init(id: UUID().uuidString,
          imageURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/4/4f/YouTube_social_white_squircle.svg/1200px-YouTube_social_white_squircle.svg.png",
          cryptoId: "ETH",
          fiatId: "USD",
          name: "Ethereum",
          price: 2_017.43),
    .init(id: UUID().uuidString,
          imageURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/4/4f/YouTube_social_white_squircle.svg/1200px-YouTube_social_white_squircle.svg.png",
          cryptoId: "DOGE",
          fiatId: "USD",
          name: "Dogecoin",
          price: 0.088_90)
  ]
}

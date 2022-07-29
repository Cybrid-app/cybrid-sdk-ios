//
//  CybridJSONDecoder.swift
//  CybridSDK
//
//  Created by Cybrid on 29/07/22.
//

import AnyCodable
import BigInt
import CybridApiBankSwift
import Foundation

final class CybridJSONDecoder: JSONDecoder {
  static var defaultDecoder: JSONDecoder {
      let decoder = JSONDecoder()
      decoder.dateDecodingStrategy = .formatted(CodableHelper.dateFormatter)
      return decoder
  }

  override func decode<T>(_ type: T.Type, from data: Data) throws -> T where T: Decodable {
    // Decode SymbolPriceBankModel
    switch type {
    case is Array<SymbolPriceBankModel>.Type:
      guard let list = try decodeSymbolPriceList(data: data) as? T else { throw DecodingError.customDecodingError }
      return list
    default:
      return try super.decode(type, from: data)
    }
  }

  func decodeSymbolPriceList(data: Data) throws -> [SymbolPriceBankModel] {
    let jsonObject = try JSONSerialization.jsonObject(with: data) as? [[String: Any]]
    guard let curatedList = try jsonObject?.compactMap({ dictionary in
      try SymbolPriceBankModel(json: dictionary)
    }) else {
      throw DecodingError.customDecodingError
    }
    return curatedList
  }
}

extension DecodingError {
  static var customDecodingError: Error {
    DecodingError.dataCorrupted(Context(codingPath: [], debugDescription: "Error found in Custom Decoder"))
  }
}

extension SymbolPriceBankModel {
  init(json: [String: Any]?) throws {
    guard let json = json else { throw DecodingError.customDecodingError }
    let buyPriceKey = SymbolPriceBankModel.CodingKeys.buyPrice.rawValue
    let sellPriceKey = SymbolPriceBankModel.CodingKeys.sellPrice.rawValue
    let buyPriceString = String(describing: AnyCodable(json[buyPriceKey]).value)
    let sellPriceString = String(describing: AnyCodable(json[sellPriceKey]).value)
    self.init(symbol: json[SymbolPriceBankModel.CodingKeys.symbol.rawValue] as? String,
              buyPrice: BigInt(buyPriceString),
              sellPrice: BigInt(sellPriceString),
              buyPriceLastUpdatedAt: json[SymbolPriceBankModel.CodingKeys.buyPriceLastUpdatedAt.rawValue] as? Date,
              sellPriceLastUpdatedAt: json[SymbolPriceBankModel.CodingKeys.sellPriceLastUpdatedAt.rawValue] as? Date)
  }
}

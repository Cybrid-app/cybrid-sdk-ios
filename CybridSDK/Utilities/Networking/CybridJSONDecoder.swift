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
  override func decode<T>(_ type: T.Type, from data: Data) throws -> T where T: Decodable {
    switch type {
    case is Array<SymbolPriceBankModel>.Type:
      // swiftlint:disable:next force_cast
      return try decodeSymbolPriceList(data: data) as! T
    case is AccountListBankModel.Type:
      // swiftlint:disable:next force_cast
      return try decodeAccountList(data: data) as! T
    default:
      return try super.decode(type, from: data)
    }
  }

  func stringValue(forKey key: String, in jsonData: Data, atIndex index: Int = 0) -> String? {
    guard let jsonString = String(data: jsonData, encoding: .utf8) else { return nil }
    let recurrentCharacters = CharacterSet(charactersIn: "\n ")
    let arrayContent = jsonString.trimmingCharacters(in: CharacterSet(charactersIn: "\n []{"))
    let dictionaries = arrayContent.split(separator: "}").map {
      $0.trimmingCharacters(in: recurrentCharacters)
    }
    guard dictionaries.count > index else { return nil }
    let selectedDict = dictionaries[index]
    let keypairs = selectedDict.split(separator: ",").map {
      $0.trimmingCharacters(in: recurrentCharacters)
    }
    guard let selectedKeyPair = keypairs.first(where: { substring in
      substring.contains(key)
    }) else { return nil }
    let keyValueSplit = selectedKeyPair.split(separator: ":")
    guard keyValueSplit.count == 2, let value = keyValueSplit.last else { return nil }
    return String(describing: value).trimmingCharacters(in: recurrentCharacters)
  }

  func decodeSymbolPriceList(data: Data) throws -> [SymbolPriceBankModel] {
    guard let jsonObject = try JSONSerialization.jsonObject(with: data) as? [[String: Any]] else {
      throw DecodingError.customDecodingError
    }
    var jsonStringObject: [[String: Any]] = jsonObject
    let buyPriceKey = SymbolPriceBankModel.CodingKeys.buyPrice.rawValue
    let sellPriceKey = SymbolPriceBankModel.CodingKeys.sellPrice.rawValue
    for index in jsonObject.indices {
      jsonStringObject[index][buyPriceKey] = stringValue(forKey: buyPriceKey, in: data, atIndex: index)
      jsonStringObject[index][sellPriceKey] = stringValue(forKey: sellPriceKey, in: data, atIndex: index)
    }
    let curatedList = jsonStringObject.compactMap { dictionary in
      SymbolPriceBankModel(json: dictionary)
    }
    return curatedList
  }

  func decodeAccountList(data: Data) throws -> AccountListBankModel? {
    guard let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
      throw DecodingError.customDecodingError
    }
    let jsonStringObject: [String: Any] = jsonObject
    let objectsValue = jsonStringObject[AccountListBankModel.CodingKeys.objects.rawValue] as? [[String: Any]]
    var objects = [AccountBankModel]()
    if let objectsValue = objectsValue {
        objects = AccountBankModel.fromArray(objects: objectsValue)
    }
    // -- Create AccountListBankModel
    return AccountListBankModel(
        total: jsonStringObject[AccountListBankModel.CodingKeys.total.rawValue] as? Int ?? 0,
        page: jsonStringObject[AccountListBankModel.CodingKeys.page.rawValue] as? Int ?? 0,
        perPage: jsonStringObject[AccountListBankModel.CodingKeys.perPage.rawValue] as? Int ?? 0,
        objects: objects)
  }
}

extension DecodingError {
  static var customDecodingError: Error {
    DecodingError.dataCorrupted(Context(codingPath: [], debugDescription: "Error found in Custom Decoder"))
  }
}

extension SymbolPriceBankModel {
  init?(json: [String: Any]) {
    guard
      let buyPriceString = json[SymbolPriceBankModel.CodingKeys.buyPrice.rawValue] as? String,
      let sellPriceString = json[SymbolPriceBankModel.CodingKeys.sellPrice.rawValue] as? String,
      let buyPrice = BigInt(buyPriceString),
      let sellPrice = BigInt(sellPriceString)
    else {
      return nil
    }
    self.init(symbol: json[SymbolPriceBankModel.CodingKeys.symbol.rawValue] as? String,
              buyPrice: buyPrice,
              sellPrice: sellPrice,
              buyPriceLastUpdatedAt: json[SymbolPriceBankModel.CodingKeys.buyPriceLastUpdatedAt.rawValue] as? Date,
              sellPriceLastUpdatedAt: json[SymbolPriceBankModel.CodingKeys.sellPriceLastUpdatedAt.rawValue] as? Date)
  }
}

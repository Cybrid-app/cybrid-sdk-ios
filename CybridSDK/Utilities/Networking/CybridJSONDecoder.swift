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
    // Decode SymbolPriceBankModel
    switch type {
    case is Array<SymbolPriceBankModel>.Type:
      // Force cast is valid here, since we are already falling into the case where T equals Array<SymbolPriceBankModel>
      // swiftlint:disable:next force_cast
      return try decodeSymbolPriceList(data: data) as! T
    case is QuoteBankModel.Type:
      // swiftlint:disable:next force_cast
      return try decodeQuoteBankModel(data: data) as! T
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

  func decodeQuoteBankModel(data: Data) throws -> QuoteBankModel {
    guard let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
      throw DecodingError.customDecodingError
    }
    var jsonStringObject: [String: Any] = jsonObject
    let deliverAmountKey = QuoteBankModel.CodingKeys.deliverAmount.rawValue
    let receiveAmountKey = QuoteBankModel.CodingKeys.receiveAmount.rawValue
    let feeAmountKey = QuoteBankModel.CodingKeys.fee.rawValue
    jsonStringObject[deliverAmountKey] = stringValue(forKey: deliverAmountKey, in: data, atIndex: 0)
    jsonStringObject[receiveAmountKey] = stringValue(forKey: receiveAmountKey, in: data, atIndex: 0)
    jsonStringObject[feeAmountKey] = stringValue(forKey: feeAmountKey, in: data, atIndex: 0)

    guard
      let model = QuoteBankModel(json: jsonStringObject)
    else {
      throw DecodingError.customDecodingError
    }
    return model
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

extension QuoteBankModel {
  init?(json: [String: Any]) {
    guard
      let deliverAmountString = json[QuoteBankModel.CodingKeys.deliverAmount.rawValue] as? String,
      let receiveAmountString = json[QuoteBankModel.CodingKeys.receiveAmount.rawValue] as? String,
      let feeAmountString = json[QuoteBankModel.CodingKeys.fee.rawValue] as? String,
      let deliverAmount = BigInt(deliverAmountString),
      let receiveAmount = BigInt(receiveAmountString),
      let feeAmount = BigInt(feeAmountString)
    else {
      return nil
    }
    self.init(guid: json[QuoteBankModel.CodingKeys.guid.rawValue] as? String,
              customerGuid: json[QuoteBankModel.CodingKeys.customerGuid.rawValue] as? String,
              symbol: json[QuoteBankModel.CodingKeys.symbol.rawValue] as? String,
              side: json[QuoteBankModel.CodingKeys.side.rawValue] as? SideBankModel,
              receiveAmount: receiveAmount,
              deliverAmount: deliverAmount,
              fee: feeAmount,
              issuedAt: json[QuoteBankModel.CodingKeys.issuedAt.rawValue] as? Date,
              expiresAt: json[QuoteBankModel.CodingKeys.expiresAt.rawValue] as? Date)
  }
}

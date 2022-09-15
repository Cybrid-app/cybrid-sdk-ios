//
//  CybridJSONDecoder.swift
//  CybridSDK
//
//  Created by Cybrid on 29/07/22.
//

import BigInt
import CybridApiBankSwift
import Foundation

final class CybridJSONDecoder: JSONDecoder {

    override func decode<T>(_ type: T.Type, from data: Data) throws -> T where T: Decodable {

        switch type {
        case is Array<SymbolPriceBankModel>.Type:
            // swiftlint:disable:next force_cast
            return try decodeSymbolPriceList(data: data) as! T
        case is QuoteBankModel.Type:
            // swiftlint:disable:next force_cast
            return try decodeQuoteBankModel(data: data) as! T
        case is TradeBankModel.Type:
            // swiftlint:disable:next force_cast
            return try decodeTradeBankModel(data: data) as! T
        case is AccountListBankModel.Type:
            // swiftlint:disable:next force_cast
            return try decodeAccountList(data: data) as! T
        default:
            return try super.decode(type, from: data)
        }
    }
}

extension CybridJSONDecoder {

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

    func decodeTradeBankModel(data: Data) throws -> TradeBankModel {

        guard let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            throw DecodingError.customDecodingError
        }
        var jsonStringObject: [String: Any] = jsonObject
        let deliverAmountKey = TradeBankModel.CodingKeys.deliverAmount.rawValue
        let receiveAmountKey = TradeBankModel.CodingKeys.receiveAmount.rawValue
        let feeAmountKey = TradeBankModel.CodingKeys.fee.rawValue
        jsonStringObject[deliverAmountKey] = stringValue(forKey: deliverAmountKey, in: data, atIndex: 0)
        jsonStringObject[receiveAmountKey] = stringValue(forKey: receiveAmountKey, in: data, atIndex: 0)
        jsonStringObject[feeAmountKey] = stringValue(forKey: feeAmountKey, in: data, atIndex: 0)

        guard
            let model = TradeBankModel(json: jsonStringObject)
        else {
            throw DecodingError.customDecodingError
        }
        return model
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

    func decoedTradeList(data: Data) throws -> TradeListBankModel? {

        guard let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            throw DecodingError.customDecodingError
        }
        let jsonStringObject: [String: Any] = jsonObject
        let objectsValue = jsonStringObject[TradeListBankModel.CodingKeys.objects.rawValue] as? [[String: Any]]
        var objects = [TradeBankModel]()
        if let objectsValue = objectsValue {
            objects = TradeBankModel.fromArray(objects: objectsValue)
        }
        return TradeListBankModel(
            total: jsonStringObject[TradeListBankModel.CodingKeys.total.rawValue] as? Int ?? 0,
            page: jsonStringObject[TradeListBankModel.CodingKeys.page.rawValue] as? Int ?? 0,
            perPage: jsonStringObject[TradeListBankModel.CodingKeys.perPage.rawValue] as? Int ?? 0,
            objects: objects)
    }
}

extension DecodingError {

    static var customDecodingError: Error {
        DecodingError.dataCorrupted(Context(codingPath: [], debugDescription: "Error found in Custom Decoder"))
    }
}

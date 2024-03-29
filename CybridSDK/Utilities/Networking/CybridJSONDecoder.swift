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

    // swiftlint:disable:next cyclomatic_complexity
    override func decode<T>(_ type: T.Type, from data: Data) throws -> T where T: Decodable {

        switch type {

        case is Array<SymbolPriceBankModel>.Type:
            return try decodeSymbolPriceList(data: data) as! T

        case is QuoteBankModel.Type:
            return try decodeQuoteBankModel(data: data) as! T

        case is TradeBankModel.Type:
            return try decodeTradeBankModel(data: data) as! T

        case is TradeListBankModel.Type:
            return try decodeTradeList(data: data) as! T

        case is AccountListBankModel.Type:
            return try decodeAccountList(data: data) as! T

        case is CustomerBankModel.Type:
            return try decodeCustomerBankModel(data: data) as! T

        case is IdentityVerificationListBankModel.Type:
            return try decodeIdentityVerificationListBankModel(data: data) as! T

        case is IdentityVerificationBankModel.Type:
            return try decodeIdentityVerificationBankModel(data: data) as! T

        case is IdentityVerificationWithDetailsBankModel.Type:
            return try decodeIdentityVerificationWithDetailsBankModel(data: data) as! T

        case is WorkflowBankModel.Type:
            return try decodeWorkflowBankModel(data: data) as! T

        case is WorkflowWithDetailsBankModel.Type:
            return try decodeWorkflowWithDetailsBankModel(data: data) as! T

        case is BankBankModel.Type:
            return try decodeBankBankModel(data: data) as! T

        case is ExternalBankAccountBankModel.Type:
            return try decodeExternalBankAccountBankModel(data: data) as! T

        case is ExternalBankAccountListBankModel.Type:
            return try decodeExternalBankAccountListBankModel(data: data) as! T

        case is TransferBankModel.Type:
            return try decodeTransferBankModel(data: data) as! T

        case is TransferListBankModel.Type:
            return try decodeTransferList(data: data) as! T

        case is DepositAddressListBankModel.Type:
            return try decodeDepostAddressList(data: data) as! T

        case is DepositAddressBankModel.Type:
            return try decodeDepositAddressBankModel(data: data) as! T

        case is ExternalWalletListBankModel.Type:
            return try decodeExternalWalletList(data: data) as! T

        case is ExternalWalletBankModel.Type:
            return try decodeExternalWalletBankModel(data: data) as! T

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
        let networkFeeAmountKey = QuoteBankModel.CodingKeys.networkFee.rawValue
        jsonStringObject[deliverAmountKey] = stringValue(forKey: deliverAmountKey, in: data, atIndex: 0)
        jsonStringObject[receiveAmountKey] = stringValue(forKey: receiveAmountKey, in: data, atIndex: 0)
        jsonStringObject[feeAmountKey] = stringValue(forKey: feeAmountKey, in: data, atIndex: 0)
        jsonStringObject[networkFeeAmountKey] = stringValue(forKey: networkFeeAmountKey, in: data, atIndex: 0)

        let model = QuoteBankModel(json: jsonStringObject)
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

    func decodeTradeList(data: Data) throws -> TradeListBankModel? {

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

    func decodeAccountList(data: Data) throws -> AccountListBankModel? {

        if let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
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
        return nil
    }

    func decodeCustomerBankModel(data: Data) throws -> CustomerBankModel {

        guard let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            throw DecodingError.customDecodingError
        }
        let jsonStrongObject: [String: Any] = jsonObject

        guard
            let model = CustomerBankModel(json: jsonStrongObject)
        else {
            throw DecodingError.customDecodingError
        }
        return model
    }

    func decodeIdentityVerificationListBankModel(data: Data) throws -> IdentityVerificationListBankModel? {

        guard let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            throw DecodingError.customDecodingError
        }
        let jsonStringObject: [String: Any] = jsonObject
        let objectsValue = jsonStringObject[IdentityVerificationListBankModel.CodingKeys.objects.rawValue] as? [[String: Any]]
        var objects = [IdentityVerificationBankModel]()
        if let objectsValue = objectsValue {
            objects = IdentityVerificationBankModel.fromArray(objects: objectsValue)
        }
        return IdentityVerificationListBankModel(
            total: jsonStringObject[CustomerListBankModel.CodingKeys.total.rawValue] as? Int ?? 0,
            page: jsonStringObject[CustomerListBankModel.CodingKeys.page.rawValue] as? Int ?? 0,
            perPage: jsonStringObject[CustomerListBankModel.CodingKeys.perPage.rawValue] as? Int ?? 0,
            objects: objects)
    }

    func decodeIdentityVerificationBankModel(data: Data) throws -> IdentityVerificationBankModel {

        guard let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            throw DecodingError.customDecodingError
        }
        let jsonStringObject: [String: Any] = jsonObject

        guard
            let model = IdentityVerificationBankModel(json: jsonStringObject)
        else {
            throw DecodingError.customDecodingError
        }
        return model
    }

    func decodeIdentityVerificationWithDetailsBankModel(data: Data) throws -> IdentityVerificationWithDetailsBankModel {

        guard let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            throw DecodingError.customDecodingError
        }
        let jsonStringObject: [String: Any] = jsonObject

        guard
            let model = IdentityVerificationWithDetailsBankModel(json: jsonStringObject)
        else {
            throw DecodingError.customDecodingError
        }
        return model
    }

    func decodeWorkflowBankModel(data: Data) throws -> WorkflowBankModel {

        guard let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            throw DecodingError.customDecodingError
        }
        let jsonStringObject: [String: Any] = jsonObject

        guard
            let model = WorkflowBankModel(json: jsonStringObject)
        else {
            throw DecodingError.customDecodingError
        }
        return model
    }

    func decodeWorkflowWithDetailsBankModel(data: Data) throws -> WorkflowWithDetailsBankModel {

        guard let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            throw DecodingError.customDecodingError
        }
        let jsonStringObject: [String: Any] = jsonObject

        guard
            let model = WorkflowWithDetailsBankModel(json: jsonStringObject)
        else {
            throw DecodingError.customDecodingError
        }
        return model
    }

    func decodeBankBankModel(data: Data) throws -> BankBankModel {

        guard let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            throw DecodingError.customDecodingError
        }
        let jsonStringObject: [String: Any] = jsonObject

        guard
            let model = BankBankModel(json: jsonStringObject)
        else {
            throw DecodingError.customDecodingError
        }
        return model
    }

    func decodeExternalBankAccountBankModel(data: Data) throws -> ExternalBankAccountBankModel {

        guard let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            throw DecodingError.customDecodingError
        }
        let jsonStringObject: [String: Any] = jsonObject

        guard
            let model = ExternalBankAccountBankModel(json: jsonStringObject)
        else {
            throw DecodingError.customDecodingError
        }
        return model
    }

    func decodeExternalBankAccountListBankModel(data: Data) throws -> ExternalBankAccountListBankModel? {

        guard let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            throw DecodingError.customDecodingError
        }
        let jsonStringObject: [String: Any] = jsonObject
        let objectsValue = jsonStringObject[ExternalBankAccountListBankModel.CodingKeys.objects.rawValue] as? [[String: Any]]
        var objects = [ExternalBankAccountBankModel]()
        if let objectsValue = objectsValue {
            objects = ExternalBankAccountBankModel.fromArray(objects: objectsValue)
        }
        return ExternalBankAccountListBankModel(
            total: jsonStringObject[TradeListBankModel.CodingKeys.total.rawValue] as? Int ?? 0,
            page: jsonStringObject[TradeListBankModel.CodingKeys.page.rawValue] as? Int ?? 0,
            perPage: jsonStringObject[TradeListBankModel.CodingKeys.perPage.rawValue] as? Int ?? 0,
            objects: objects)
    }

    func decodeTransferBankModel(data: Data) throws -> TransferBankModel {

        guard let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            throw DecodingError.customDecodingError
        }
        let jsonStringObject: [String: Any] = jsonObject
        guard
            let model = TransferBankModel(json: jsonStringObject)
        else {
            throw DecodingError.customDecodingError
        }
        return model
    }

    func decodeTransferList(data: Data) throws -> TransferListBankModel? {

        guard let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            throw DecodingError.customDecodingError
        }
        let jsonStringObject: [String: Any] = jsonObject
        let objectsValue = jsonStringObject[TransferListBankModel.CodingKeys.objects.rawValue] as? [[String: Any]]
        var objects = [TransferBankModel]()
        if let objectsValue = objectsValue {
            objects = TransferBankModel.fromArray(objects: objectsValue)
        }
        return TransferListBankModel(
            total: jsonStringObject[TransferListBankModel.CodingKeys.total.rawValue] as? Int ?? 0,
            page: jsonStringObject[TransferListBankModel.CodingKeys.page.rawValue] as? Int ?? 0,
            perPage: jsonStringObject[TransferListBankModel.CodingKeys.perPage.rawValue] as? Int ?? 0,
            objects: objects)
    }

    func decodeDepostAddressList(data: Data) throws -> DepositAddressListBankModel? {

        guard let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            throw DecodingError.customDecodingError
        }
        let jsonStringObject: [String: Any] = jsonObject
        let objectsValue = jsonStringObject[DepositAddressListBankModel.CodingKeys.objects.rawValue] as? [[String: Any]]
        var objects = [DepositAddressBankModel]()
        if let objectsValue = objectsValue {
            objects = DepositAddressBankModel.fromArray(objects: objectsValue)
        }
        return DepositAddressListBankModel(
            total: jsonStringObject[DepositAddressListBankModel.CodingKeys.total.rawValue] as? Int ?? 0,
            page: jsonStringObject[DepositAddressListBankModel.CodingKeys.page.rawValue] as? Int ?? 0,
            perPage: jsonStringObject[DepositAddressListBankModel.CodingKeys.perPage.rawValue] as? Int ?? 0,
            objects: objects)
    }

    func decodeDepositAddressBankModel(data: Data) throws -> DepositAddressBankModel {

        guard let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            throw DecodingError.customDecodingError
        }
        let jsonStringObject: [String: Any] = jsonObject
        guard
            let model = DepositAddressBankModel(json: jsonStringObject)
        else {
            throw DecodingError.customDecodingError
        }
        return model
    }

    func decodeExternalWalletList(data: Data) throws -> ExternalWalletListBankModel? {

        guard let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            throw DecodingError.customDecodingError
        }
        let jsonStringObject: [String: Any] = jsonObject
        let objectsValue = jsonStringObject[ExternalWalletListBankModel.CodingKeys.objects.rawValue] as? [[String: Any]]
        var objects = [ExternalWalletBankModel]()
        if let objectsValue = objectsValue {
            objects = ExternalWalletBankModel.fromArray(objects: objectsValue)
        }
        return ExternalWalletListBankModel(
            total: jsonStringObject[ExternalWalletListBankModel.CodingKeys.total.rawValue] as? Int ?? 0,
            page: jsonStringObject[ExternalWalletListBankModel.CodingKeys.page.rawValue] as? Int ?? 0,
            perPage: jsonStringObject[ExternalWalletListBankModel.CodingKeys.perPage.rawValue] as? Int ?? 0,
            objects: objects)
    }

    func decodeExternalWalletBankModel(data: Data) throws -> ExternalWalletBankModel {

        guard let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            throw DecodingError.customDecodingError
        }
        let jsonStringObject: [String: Any] = jsonObject
        guard
            let model = ExternalWalletBankModel(json: jsonStringObject)
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

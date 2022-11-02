//
//  IdentityVerificationBankModel+Extensions.swift
//  CybridSDK
//
//  Created by Erick Sanchez Perez on 01/11/22.
//

import Foundation
import CybridApiBankSwift

extension IdentityVerificationBankModel {

    init?(json: [String: Any]) {

        guard
            let createdAt = json[IdentityVerificationBankModel.CodingKeys.createdAt.rawValue] as? String
        else {
            return nil
        }

        let type = json[IdentityVerificationBankModel.CodingKeys.type.rawValue] as? String ?? ""
        let method = json[IdentityVerificationBankModel.CodingKeys.method.rawValue] as? String ?? ""
        let state = json[IdentityVerificationBankModel.CodingKeys.state.rawValue] as? String ?? ""
        let outcome = json[IdentityVerificationBankModel.CodingKeys.outcome.rawValue] as? String ?? ""
        let personaState = json[IdentityVerificationBankModel.CodingKeys.personaState.rawValue] as? String ?? ""

        let codingKeys = IdentityVerificationBankModel.CodingKeys.self
        let createdAtDate = getDate(stringDate: createdAt)

        self.init(
            guid: json[codingKeys.guid.rawValue] as? String ?? "",
            customerGuid: json[codingKeys.customerGuid.rawValue] as? String ?? "",
            type: IdentityVerificationBankModel.TypeBankModel(rawValue: type) ?? .kyc,
            method: IdentityVerificationBankModel.MethodBankModel(rawValue: method) ?? .idAndSelfie,
            createdAt: createdAtDate,
            state: IdentityVerificationBankModel.StateBankModel(rawValue: state) ?? .storing,
            outcome: IdentityVerificationBankModel.OutcomeBankModel(rawValue: outcome) ?? .passed,
            failureCodes: nil,
            personaInquiryId: json[codingKeys.personaInquiryId.rawValue] as? String ?? "",
            personaState: IdentityVerificationBankModel.PersonaStateBankModel(rawValue: personaState) ?? .unknown)
    }

    static func fromArray(objects: [[String: Any]]) -> [IdentityVerificationBankModel] {

        var models = [IdentityVerificationBankModel]()
        for object in objects {
            // -- Creating the AccountBankModel
            let model = IdentityVerificationBankModel(json: object)
            if let model = model {
                models.append(model)
            }
        }
        return models
    }
}
